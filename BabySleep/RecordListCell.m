//
//  RecordListCell.m
//  BabySleep
//
//  Created by Michael on 2016/8/29.
//  Copyright © 2016年 Michael. All rights reserved.
//

#import "RecordListCell.h"

#import "TFLargerHitButton.h"

#import "Utility.h"

#import "WXApi.h"

@interface RecordListCell ()

@property (nonatomic , strong) UIView *recordContentView;

@property (nonatomic , strong) UIImageView *iconImageView;

@property (nonatomic , strong) UILabel *titleName;

@property (nonatomic , strong) UIButton *shareBtn;

@property (nonatomic , strong) UISlider *slider;

@property (nonatomic , strong) UIView *iconBG;

@property (nonatomic , strong) UIImageView *deleteSelectImage;

@property (nonatomic , strong) MusicData *data;

@end

@implementation RecordListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.recordContentView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, SCREENWIDTH - 20, 115)];
        [self addSubview:self.recordContentView];
        
        self.deleteSelectImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 48, 20, 20)];
        self.deleteSelectImage.image = [UIImage imageNamed:@"delete_normal"];
        self.deleteSelectImage.hidden = YES;
        [self addSubview:self.deleteSelectImage];
        
        self.iconBG = [[UIView alloc] initWithFrame:CGRectMake(0, 33, 45, 45)];
        self.iconBG.layer.cornerRadius = 45 * 0.5;
        self.iconBG.layer.borderWidth = 1.0;
        self.iconBG.layer.borderColor = HexRGB(0xE3E3E3).CGColor;
        self.iconBG.clipsToBounds = YES;
        [self.recordContentView addSubview:self.iconBG];
        
        self.iconImageView = [[UIImageView alloc] initWithFrame:self.iconBG.bounds];
        [self.iconBG addSubview:self.iconImageView];
        
        self.titleName = [[UILabel alloc] initWithFrame:CGRectMake(65, 24, 150, 22)];
        self.titleName.textColor = HexRGB(0x9E9E9E);
        self.titleName.font = [UIFont fontWithName:@"DFPYuanW5" size:16];
        [self.recordContentView addSubview:self.titleName];
        
        self.slider = [[UISlider alloc] initWithFrame:CGRectMake(68, 58, SCREENWIDTH - 20 - 68 - 57, 30)];
        [self.slider setMinimumTrackTintColor:HexRGB(0xE3E3E3)];
        [self.slider setMaximumTrackTintColor:HexRGB(0xE3E3E3)];
        [self.slider setThumbImage:[UIImage imageNamed:@"slide_enable"] forState:UIControlStateNormal];
        [self.slider setThumbImage:[UIImage imageNamed:@"slide_disable"] forState:UIControlStateDisabled];
        [self.slider addTarget:self action:@selector(slideValueChange:) forControlEvents:UIControlEventValueChanged];
        [self.recordContentView addSubview:self.slider];

        self.shareBtn = [TFLargerHitButton buttonWithType:UIButtonTypeCustom];
        self.shareBtn.frame = CGRectMake(SCREENWIDTH - 20 - 40, 40, 16, 25);
        [self.shareBtn setImage:[UIImage imageNamed:@"home_shareoff"] forState:UIControlStateNormal];
        [self.shareBtn addTarget:self action:@selector(shareMusic:) forControlEvents:UIControlEventTouchUpInside];
        [self.recordContentView addSubview:self.shareBtn];
        
        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 113, SCREENWIDTH - 20, 1.5)];
        bottomLine.backgroundColor = HexRGB(0xF1F1F1);
        [self.recordContentView addSubview:bottomLine];
    }
    
    return self;
}

- (void)slideValueChange:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    
    self.data.volum = slider.value;
    
    self.VolumValueChange(slider.value);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureWithMusic:(MusicData *)music volum:(NSString *)volum selected:(BOOL)selected editMode:(BOOL)editMode
{
    self.titleName.text = music.musicName;
    
    self.data = music;
    
    if (self.indexPath.section == 1) {
        if (music.userData) {
            NSString *filePath = [[NSString alloc]initWithFormat:@"%@/Documents/%@",NSHomeDirectory(),music.imageName];
            if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
                self.iconImageView.image=[UIImage imageWithContentsOfFile:filePath];
            }
        }else{
            self.iconImageView.image = [UIImage imageNamed:music.imageName];
        }
    }else{
        self.iconImageView.image = [UIImage imageNamed:music.imageName];
    }
    
    self.slider.value = music.volum;
    
    if (editMode) {
        self.deleteSelectImage.hidden = NO;
        
        self.recordContentView.frame = CGRectMake(58, 0, SCREENWIDTH - 20, 115);
    }else{
        self.deleteSelectImage.hidden = YES;
        
        self.recordContentView.frame = CGRectMake(20, 0, SCREENWIDTH - 20, 115);
    }
    
    if (selected) {
        self.slider.enabled = YES;
        self.titleName.textColor = HexRGB(0x5C5C5C);
        [self.slider setMinimumTrackTintColor:HexRGB(0xFF756F)];
        [self.shareBtn setImage:[UIImage imageNamed:@"home_shareon"] forState:UIControlStateNormal];
        self.shareBtn.enabled = YES;
        self.iconBG.layer.borderColor = HexRGB(0xFF756F).CGColor;
    }else{
        self.slider.enabled = NO;
        self.titleName.textColor = HexRGB(0x9E9E9E);
        [self.slider setMinimumTrackTintColor:HexRGB(0xE3E3E3)];
        [self.shareBtn setImage:[UIImage imageNamed:@"home_shareoff"] forState:UIControlStateNormal];
        self.shareBtn.enabled = NO;
        self.iconBG.layer.borderColor = HexRGB(0xE3E3E3).CGColor;
    }
}

- (void)shareMusic:(id)sender
{
    WXMediaMessage *message = [self wxShareSiglMessageScene:[UIImage imageNamed:@"icon120.png"]];
    message.title = self.data.musicName;
    message.description = self.data.musicName;
    
    [self ShareWeixinLinkContent:message WXType:0];
}

- (void)deleteSelect:(BOOL)select
{
    if (select) {
        [self.deleteSelectImage setImage:[UIImage imageNamed:@"edit_choose"]];
    }else{
        [self.deleteSelectImage setImage:[UIImage imageNamed:@"delete_normal"]];
    }
}

#pragma mark - 微信分享
- (WXMediaMessage *)wxShareSiglMessageScene:(UIImage *)image
{
    WXMediaMessage *message = [WXMediaMessage message];
    
    WXFileObject *object = [WXFileObject object];
    object.fileExtension = @"caf";
    
    NSData* data = nil;
    if (self.indexPath.section == 0) {
        NSString *musicFilePath= [[NSBundle mainBundle] pathForResource:self.data.indexName ofType:@"m4a"];
        data = [NSData dataWithContentsOfFile:musicFilePath];
    }else{
        //1.音频文件的url路径
        NSString *urlStr=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        urlStr=[urlStr stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.caf",self.data.indexName]];
        data = [NSData dataWithContentsOfFile:urlStr];
    }
    
    object.fileData = data;
    
    message.mediaObject = object;
    
    [message setThumbData:UIImageJPEGRepresentation(image,1)];
    
    return message;
}

- (void)ShareWeixinLinkContent:(WXMediaMessage *)message WXType:(NSInteger)scene {
    if ([WXApi isWXAppInstalled]) {
        SendMessageToWXReq *wxRequest = [[SendMessageToWXReq alloc] init];
        
        if ([message.mediaObject isKindOfClass:[WXWebpageObject class]]) {
            WXWebpageObject *webpageObject = message.mediaObject;
            if (webpageObject.webpageUrl.length == 0) {
                wxRequest.text = message.title;
                wxRequest.bText = YES;
            } else {
                wxRequest.message = message;
            }
        } else if ([message.mediaObject isKindOfClass:[WXImageObject class]]) {
            wxRequest.bText = NO;
            wxRequest.message = message;
        } else if ([message.mediaObject isKindOfClass:[WXVideoObject class]]) {
            wxRequest.bText = NO;
            wxRequest.message = message;
        } else if ([message.mediaObject isKindOfClass:[WXFileObject class]]) {
            wxRequest.bText = NO;
            wxRequest.message = message;
        }
        
        wxRequest.bText = NO;
        wxRequest.scene = (int)scene;
        
        [WXApi sendReq:wxRequest];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败" message:@"请使用其它分享途径。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

@end

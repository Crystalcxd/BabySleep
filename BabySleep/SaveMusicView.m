//
//  SaveMusicView.m
//  BabySleep
//
//  Created by Michael on 2016/9/1.
//  Copyright © 2016年 Michael. All rights reserved.
//

#import "SaveMusicView.h"
#import "TFLargerHitButton.h"

#import "ELCImagePickerController.h"

#import "Utility.h"
#import "WMUserDefault.h"

@interface SaveMusicView ()<UIActionSheetDelegate,ELCImagePickerControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic , strong) UITextField *textField;

@property (nonatomic , strong) UIImageView *musicImageView;

@property (nonatomic , assign) BOOL imageChange;

@end

@implementation SaveMusicView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *BG = [[UIView alloc] initWithFrame:frame];
        BG.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.49];
        [self addSubview:BG];
        
        UIView *boardBG = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 288, 490)];
        boardBG.center = CGPointMake(CGRectGetWidth(frame) * 0.5, CGRectGetHeight(frame) * 0.5);
        boardBG.backgroundColor = [UIColor whiteColor];
        boardBG.layer.borderWidth = 3.0;
        boardBG.layer.borderColor = HexRGB(0xFF918C).CGColor;
        boardBG.layer.shadowColor = HexRGB(0x8697D4).CGColor;
        boardBG.layer.shadowOffset = CGSizeMake(1, 2);
        [self addSubview:boardBG];
        
        TFLargerHitButton *cancelBtn = [TFLargerHitButton buttonWithType:UIButtonTypeCustom];
        [cancelBtn setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
        cancelBtn.frame = CGRectMake(255, 15, 18, 18);
        [cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
        [boardBG addSubview:cancelBtn];
        
        UILabel *nameTitle = [[UILabel alloc] initWithFrame:CGRectMake(22, 33, 100, 18)];
        nameTitle.textColor = HexRGB(0x9E9E9E);
        nameTitle.font = [UIFont fontWithName:@"DFPYuanW5" size:18];
        nameTitle.text = @"名称";
        [boardBG addSubview:nameTitle];
        
        UIView *textFieldBG = [[UIView alloc] initWithFrame:CGRectMake(26, 66, 236, 34)];
        textFieldBG.layer.borderColor = HexRGB(0xFF756F).CGColor;
        textFieldBG.layer.borderWidth = 1.0;
        [boardBG addSubview:textFieldBG];
        
        self.textField = [[UITextField alloc] initWithFrame:CGRectMake(36, 66, 226, 34)];
        self.textField.font = [UIFont fontWithName:@"DFPYuanW5" size:18];
        self.textField.textColor = HexRGB(0xD0D0D0);
        self.textField.placeholder = @"不超过10个字符";
        [self.textField setValue:HexRGB(0xD0D0D0) forKeyPath:@"_placeholderLabel.textColor"];
        [boardBG addSubview:self.textField];
        
        UILabel *tipTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 108, 288, 17)];
        tipTitle.textAlignment = NSTextAlignmentCenter;
        tipTitle.textColor = HexRGB(0xD04CFF);
        tipTitle.font = [UIFont fontWithName:@"DFPYuanW5" size:12];
        tipTitle.text = @"提示：文件大于10M，无法使用微信分享。";
        [boardBG addSubview:tipTitle];
        
        self.musicData.imageName = @"record_save_head.png";

        UILabel *iconTitle = [[UILabel alloc] initWithFrame:CGRectMake(22, 175, 100, 18)];
        iconTitle.textColor = HexRGB(0x9E9E9E);
        iconTitle.font = [UIFont fontWithName:@"DFPYuanW5" size:18];
        iconTitle.text = @"头像";
        [boardBG addSubview:iconTitle];
        
        UIView *imageBG = [[UIView alloc]initWithFrame:CGRectMake(148, 198, 80, 80)];
        imageBG.layer.cornerRadius = 45;
        imageBG.clipsToBounds = YES;
        [boardBG addSubview:imageBG];
        
        UIImageView *defaultImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
        defaultImage.layer.cornerRadius = 45;
        defaultImage.image = [UIImage imageNamed:@"record_save_camera"];
        [imageBG addSubview:defaultImage];
        
        self.musicImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
        self.musicImageView.layer.cornerRadius = 45;
        [imageBG addSubview:self.musicImageView];
        
        UIButton *selectImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        selectImageBtn.frame = imageBG.frame;
        [selectImageBtn addTarget:self action:@selector(selectImage:) forControlEvents:UIControlEventTouchUpInside];
        [boardBG addSubview:selectImageBtn];
        
        UILabel *selectTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 310, 288, 17)];
        selectTitle.textAlignment = NSTextAlignmentCenter;
        selectTitle.textColor = HexRGB(0xB1B1B1);
        selectTitle.font = [UIFont fontWithName:@"DFPYuanW5" size:12];
        selectTitle.text = @"选择默认";
        [boardBG addSubview:selectTitle];
        
        
        
        UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        saveBtn.frame = CGRectMake(0, 426, 288, 64);
        [saveBtn setTitle:@"保 存" forState:UIControlStateNormal];
        [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [saveBtn.titleLabel setFont:[UIFont fontWithName:@"DFPYuanW5" size:20]];
        saveBtn.backgroundColor = HexRGB(0xFF918C);
        [saveBtn addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];
        [boardBG addSubview:saveBtn];
    }
    
    return self;
}

- (void)configureWith:(MusicData *)data
{
    self.musicData = data;
    
    self.musicImageView.image = [UIImage imageNamed:self.musicData.imageName];
}

- (void)cancelAction:(id)sender
{
    [self removeFromSuperview];
}

- (void)saveAction:(id)sender
{
    if (self.textField.text.length != 0) {
        self.musicData.musicName = self.textField.text;
    }
    
    self.musicData.userData = YES;
    
    [self saveImage];
    [self saveData];
    
    self.EndSaveMusic();
    
    [self removeFromSuperview];
}

- (void)saveData
{
    NSMutableArray *array = [NSMutableArray new];
    if ([WMUserDefault arrayForKey:@"UserData"]) {
        [array addObjectsFromArray:[WMUserDefault arrayForKey:@"UserData"]];
    }
    
    [array addObject:self.musicData];
    
    [WMUserDefault setArray:array forKey:@"UserData"];
}

- (void)saveImage
{
    if (self.imageChange) {
        NSString  *pngPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@.png",self.musicData.musicName]];
        [UIImagePNGRepresentation(self.musicImageView.image) writeToFile:pngPath atomically:YES];
        
        self.musicData.imageName = [NSString stringWithFormat:@"%@.png",self.musicData.musicName];
    }
}

- (void)selectImage:(id)sender
{
    UIActionSheet *choosePhotoActionSheet;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        choosePhotoActionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedString(@"取消", nil)
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:NSLocalizedString(@"拍照", nil), NSLocalizedString(@"从相册选择", nil), nil];
    } else {
        choosePhotoActionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedString(@"取消", nil)
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:NSLocalizedString(@"从相册选择", nil), nil];
    }
    
    choosePhotoActionSheet.tag = 200;
    [choosePhotoActionSheet showInView:self];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"buttonIndex:%ld",(long)buttonIndex);
    NSUInteger sourceType = 0;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        switch (buttonIndex) {
            case 0:
                sourceType = UIImagePickerControllerSourceTypeCamera;
                break;
            case 1:
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                break;
            case 2:
                
                break;
        }
        
    } else {
        if (buttonIndex == 1) {
            return;
        } else {
            sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        }
    }
    if (buttonIndex == 0) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = sourceType;
        
        [self.fatherVC presentViewController:imagePickerController animated:YES completion:^{
            
        }];
    }else if (buttonIndex == 1){
        ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] init];
        elcPicker.maximumImagesCount = 1;
        elcPicker.imagePickerDelegate = self;
        
        [self.fatherVC presentViewController:elcPicker animated:YES completion:^{
            
        }];
        
    }else{

    }
    
}

#pragma mark ELCImagePickerControllerDelegate Methods

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:YES];
    }];

    NSMutableArray *images = [NSMutableArray arrayWithCapacity:[info count]];
    
    for (NSDictionary *dict in info) {
        self.imageChange = YES;
        
        UIImage *image = [dict objectForKey:UIImagePickerControllerOriginalImage];
        [images addObject:image];
        
        self.musicImageView.image = image;
        self.musicImageView.layer.cornerRadius = 45;
    }
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker
{
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:YES];
    }];

    self.imageChange = YES;
    
    UIImage *image= [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    self.musicImageView.image = image;
    self.musicImageView.layer.cornerRadius = 45;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

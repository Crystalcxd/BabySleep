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

@interface RecordListCell ()

@property (nonatomic , strong) UIView *recordContentView;

@property (nonatomic , strong) UIImageView *iconImageView;

@property (nonatomic , strong) UILabel *titleName;

@property (nonatomic , strong) UIButton *shareBtn;

@property (nonatomic , strong) UISlider *slider;

@end

@implementation RecordListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.recordContentView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, SCREENWIDTH - 20, 115)];
        [self addSubview:self.recordContentView];
        
        UIView *iconBG = [[UIView alloc] initWithFrame:CGRectMake(0, 33, 45, 45)];
        iconBG.layer.cornerRadius = 45 * 0.5;
        iconBG.layer.borderWidth = 1.0;
        iconBG.layer.borderColor = HexRGB(0xE3E3E3).CGColor;
        iconBG.clipsToBounds = YES;
        [self.recordContentView addSubview:iconBG];
        
        self.iconImageView = [[UIImageView alloc] initWithFrame:iconBG.bounds];
        [iconBG addSubview:self.iconImageView];
        
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
        [self addSubview:self.slider];

        self.shareBtn = [TFLargerHitButton buttonWithType:UIButtonTypeCustom];
        self.shareBtn.frame = CGRectMake(SCREENWIDTH - 20 - 40, 40, 16, 25);
        [self.shareBtn setImage:[UIImage imageNamed:@"home_shareoff"] forState:UIControlStateNormal];
        [self.recordContentView addSubview:self.shareBtn];
        
        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 114, SCREENWIDTH - 20, 1)];
        bottomLine.backgroundColor = HexRGB(0xF1F1F1);
        [self.recordContentView addSubview:bottomLine];
    }
    
    return self;
}

- (void)slideValueChange:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    
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

@end

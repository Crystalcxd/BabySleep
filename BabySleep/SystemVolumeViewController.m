//
//  SystemVolumeViewController.m
//  BabySleep
//
//  Created by medica_mac on 16/9/14.
//  Copyright © 2016年 Michael. All rights reserved.
//

#import "SystemVolumeViewController.h"

#import "Utility.h"

#import "TFLargerHitButton.h"

#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface SystemVolumeViewController ()

@end

@implementation SystemVolumeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = HexRGB(0xffffff);
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 70)];
    topView.backgroundColor = HexRGB(0xffffff);
    topView.layer.borderColor = RGBA(208, 208, 208, 0.3).CGColor;
    topView.layer.borderWidth = 1.5;
    [self.view addSubview:topView];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 29, SCREENWIDTH, 25)];
    title.textColor = HexRGB(0xFF756F);
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"初始音量";
    title.font = [UIFont fontWithName:@"DFPYuanW5" size:18];
    [self.view addSubview:title];
    
    TFLargerHitButton *backBtn = [[TFLargerHitButton alloc] initWithFrame:CGRectMake(22, 35, 14, 14)];
    [backBtn setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:backBtn];

    UILabel *subTitle = [[UILabel alloc] initWithFrame:CGRectMake(31, 64, 200, 72)];
    subTitle.textColor = HexRGB(0x9E9E9E);
    subTitle.text = @"初始音量";
    subTitle.font = [UIFont fontWithName:@"DFPYuanW5" size:18];
    [self.view addSubview:subTitle];
    
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(149, 92, SCREENWIDTH - 42 - 149, 30)];
    [slider setMinimumTrackTintColor:HexRGB(0xFF756F)];
    [slider setMaximumTrackTintColor:HexRGB(0xE3E3E3)];
    [slider setThumbImage:[UIImage imageNamed:@"slide_enable"] forState:UIControlStateNormal];
    [slider setThumbImage:[UIImage imageNamed:@"slide_disable"] forState:UIControlStateDisabled];
    [slider addTarget:self action:@selector(slideValueChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:slider];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 136, SCREENWIDTH, 1)];
    line.backgroundColor = HexRGB(0xF1F1F1);
    [self.view addSubview:line];
    
    // 获取当前手机音量
    float volume = [[AVAudioSession sharedInstance] outputVolume];
    
    NSLog(@"%f",volume);

    slider.value = volume;
}

- (void)viewDidAppear:(BOOL)animated
{
    
}

- (void)slideValueChange:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    
    MPMusicPlayerController *mpc = [MPMusicPlayerController applicationMusicPlayer];
    mpc.volume = slider.value;
}

- (void)goBack
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

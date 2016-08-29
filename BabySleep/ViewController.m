//
//  ViewController.m
//  BabySleep
//
//  Created by Michael on 16/6/26.
//  Copyright © 2016年 Michael. All rights reserved.
//

#import "ViewController.h"

#import "SliderViewController.h"

#import "TFLargerHitButton.h"

#import "TouchAnimationView.h"
#import "TouchInsideAnimationView.h"
#import "EditMusicView.h"
#import "RecordView.h"

#import "AudioTask.h"

#import "WMUserDefault.h"

#import <AVFoundation/AVFoundation.h>

@interface ViewController ()
{
    AVAudioPlayer *player;
}

@property (nonatomic , strong) EditMusicView *editMusicView;

@property (nonatomic , strong) RecordView *recordView;

@property (nonatomic , strong) UIButton *recordBtn;

@property (nonatomic , strong) UIView *progressView;

@property (nonatomic , strong) NSMutableArray *picArray;

@property (nonatomic , strong) NSMutableArray *titleImgArray;

@property (nonatomic , strong) NSMutableArray *musicArray;

@property (nonatomic , assign) NSInteger playTime;

@property (nonatomic , assign) NSInteger currentPlayTime;

@property (nonatomic , strong) UILabel *currentTime;

@property (nonatomic , strong) UILabel *totalTime;

@property (nonatomic , assign) NSInteger musicIndex;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = HexRGB(0xffffff);
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 65)];
    topView.backgroundColor = [UIColor clearColor];
    topView.layer.borderColor = RGBA(208, 208, 208, 0.3).CGColor;
    topView.layer.borderWidth = 1.5;
    [self.view addSubview:topView];

    self.picArray = [NSMutableArray arrayWithObjects:@"baby",@"cleaner",@"girl",@"hairdryer",@"radio", nil];
    self.titleImgArray = [NSMutableArray arrayWithObjects:@"whitenoisetitle",@"cleanertitle",@"canontitle",@"hairdryertitle",@"radiotitle", nil];
    self.musicArray = [NSMutableArray arrayWithObjects:@"audio",@"cleaner",@"girl",@"hairdryer",@"whitenoise", nil];

    TFLargerHitButton *leftBtn = [[TFLargerHitButton alloc] initWithFrame:CGRectMake(16, 37, 15, 14)];
    [leftBtn setImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(goMenuView:) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setAdjustsImageWhenHighlighted:NO];
    [self.view addSubview:leftBtn];
    
    UIImageView *titleView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREENWIDTH - 71.35) * 0.5, 40, 71.35, 19.39)];
    titleView.image = [UIImage imageNamed:@"babysleep"];
    [self.view addSubview:titleView];
    
    CGFloat scrollViewY = 98;
    if (SCREENWIDTH == 414) {
        scrollViewY = 123;
    }
    
    scrollViewY = 84;
    if (SCREENWIDTH == 375) {
        scrollViewY = 118;
    }else if (SCREENWIDTH == 414) {
        scrollViewY = 157;
    }
    
    self.editMusicView = [[EditMusicView alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT - 52, SCREENWIDTH, 52)];
    [self.view addSubview:self.editMusicView];
    
    self.recordView = [[RecordView alloc] initWithFrame:self.view.bounds];
    
    self.recordBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH * 0.5 - 26, CGRectGetMinY(self.editMusicView.frame) - 26, 52, 52)];
    [self.recordBtn setImage:[UIImage imageNamed:@"home_record"] forState:UIControlStateNormal];
    [self.recordBtn setAdjustsImageWhenHighlighted:NO];
    [self.recordBtn addTarget:self action:@selector(showRecordView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.recordBtn];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playBtnAction:) name:@"pauseMusic" object:nil];
}

#pragma mark - ButtonAction

- (void)showRecordView:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    
    btn.enabled = NO;
    
    if (btn.selected) {
        [self.recordView fadeRecordView];
        
        [self performSelector:@selector(enableRecordView) withObject:nil afterDelay:1.0];
    }else{
        [self.view addSubview:self.recordView];
        [self.view bringSubviewToFront:self.recordBtn];
        
        [self.recordView showRecordView];
        
        [self performSelector:@selector(enableRecordView) withObject:nil afterDelay:1.0];
    }
}

- (void)enableRecordView
{
    if (self.recordBtn.selected) {
        [self.recordBtn setImage:[UIImage imageNamed:@"home_record"] forState:UIControlStateNormal];
    }else{
        [self.recordBtn setImage:[UIImage imageNamed:@"record_stop"] forState:UIControlStateNormal];
    }
    self.recordBtn.selected = !self.recordBtn.selected;
    self.recordBtn.enabled = YES;
}

-(void)goMenuView:(id)sender
{
    [[SliderViewController sharedSliderController] leftItemClick];
}

-(void)playBtnAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    
    if ([btn isKindOfClass:[UIButton class]]) {
        [self touchAnimationWithBtn:btn];
    }
    
    BOOL fromNotification = NO;
    
    if (![btn isKindOfClass:[UIButton class]]) {
//        btn = self.playBtn;
        fromNotification = YES;
    }
    
    if (btn.selected) {
        [self pauseMusic];
    }else{
        if (fromNotification) {
            return;
        }
        if (player) {
            [player play];
        }else{
            self.currentPlayTime = 0;
            [self playMusicWithIndex:self.musicIndex];
        }
    }
    
    btn.selected = !btn.selected;
}

- (void)touchAnimationWithBtn:(UIButton *)button
{
    TouchAnimationView *view = [[TouchAnimationView alloc] initWithFrame:CGRectMake(button.center.x - 22, button.center.y - 22, 44, 44)];
    [self.view addSubview:view];
    
    TouchInsideAnimationView *insideView = [[TouchInsideAnimationView alloc] initWithFrame:CGRectMake(button.center.x - 4, button.center.y - 4, 8, 8)];
    [self.view addSubview:insideView];
    
    [view disappearAnimation];
    [insideView disappearAnimation];
}

- (void)playMusicWithIndex:(NSInteger)index
{
    NSString *musicName = self.musicArray[index];
    
    //1.音频文件的url路径
    NSString *musicFilePath= [[NSBundle mainBundle] pathForResource:musicName ofType:@"mp3"];
    
    [self audioPlayWithPath:[[NSURL alloc] initFileURLWithPath:musicFilePath]];
}

-(void)audioPlayWithPath:(NSURL *)url
{
    NSString *playMins = [WMUserDefault objectValueForKey:@"playtime"];
    
    self.playTime = playMins.integerValue * 60;
    
    [[AudioTask shareAudioTask] setUrl:url];
    [[AudioTask shareAudioTask] startTaskWithTyep:backgroundTask];
    
//    //设置锁屏仍能继续播放
//    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:nil];
//    [[AVAudioSession sharedInstance] setActive: YES error: nil];
//    
//    player=[[AVAudioPlayer alloc] initWithContentsOfURL:url error:Nil];
//    player.numberOfLoops = -1;
//    [player prepareToPlay];
//    [player play];
}

- (void)stopMusic
{
    [[AudioTask shareAudioTask] stopTaskWithType:backgroundTask];
}

- (void)pauseMusic
{
    [[AudioTask shareAudioTask] stopTaskWithType:backgroundTask];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

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

#import "MptTableHeadView.h"

#import "CartoonHeadView.h"
#import "ShareAlertView.h"
#import "TouchAnimationView.h"
#import "TouchInsideAnimationView.h"

#import "AudioTask.h"

#import "WMUserDefault.h"

#import <AVFoundation/AVFoundation.h>

@interface ViewController ()<HeadViewDelegate,HeadViewDataSource>
{
    AVAudioPlayer *player;
}

@property (nonatomic , strong) UIButton *playBtn;

@property (nonatomic , strong) MptTableHeadView *tableheadView;

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
    
    self.view.backgroundColor = HexRGB(0xDBF4FF);
    
    UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg"]];
    bgView.frame = self.view.bounds;
    [self.view addSubview:bgView];
    
    self.picArray = [NSMutableArray arrayWithObjects:@"baby",@"cleaner",@"girl",@"hairdryer",@"radio", nil];
    self.titleImgArray = [NSMutableArray arrayWithObjects:@"whitenoisetitle",@"cleanertitle",@"canontitle",@"hairdryertitle",@"radiotitle", nil];
    self.musicArray = [NSMutableArray arrayWithObjects:@"audio",@"cleaner",@"girl",@"hairdryer",@"whitenoise", nil];

    TFLargerHitButton *leftBtn = [[TFLargerHitButton alloc] initWithFrame:CGRectMake(22, 43, 15, 14)];
    [leftBtn setImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(goMenuView:) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setAdjustsImageWhenHighlighted:NO];
    [self.view addSubview:leftBtn];
    
    NSString *playMins = [WMUserDefault objectValueForKey:@"playtime"];

    if (playMins.integerValue != 60) {
        TFLargerHitButton *rightBtn = [[TFLargerHitButton alloc] initWithFrame:CGRectMake(SCREENWIDTH - 23 - 15, 39, 20, 21)];
        [rightBtn setImage:[UIImage imageNamed:@"strawberry"] forState:UIControlStateNormal];
        [rightBtn addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
        [rightBtn setAdjustsImageWhenHighlighted:NO];
        rightBtn.tag = TABLEVIEW_BEGIN_TAG * 10;
        [self.view addSubview:rightBtn];
    }

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
    
    self.tableheadView = [[MptTableHeadView alloc] initWithFrame:CGRectMake(0, scrollViewY, SCREENWIDTH, SCREENWIDTH == 320 ? 278 : 297) Type:MptTableHeadViewOther];
    self.tableheadView.dataSource = self;
    self.tableheadView.delegate = self;
    
    [self.view addSubview:self.tableheadView];

    
    scrollViewY = 372;
    if (SCREENWIDTH == 375) {
        scrollViewY = 465;
    }else if (SCREENWIDTH == 414) {
        scrollViewY = 518;
    }
    
    self.playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.playBtn.frame = CGRectMake(SCREENWIDTH * 0.5 - 39, scrollViewY, 78, 78);
    [self.playBtn setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    [self.playBtn setAdjustsImageWhenHighlighted:NO];
    [self.playBtn setImage:[UIImage imageNamed:@"stop"] forState:UIControlStateSelected];
    [self.playBtn addTarget:self action:@selector(playBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.playBtn];
    
    UIButton *previousBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    previousBtn.frame = CGRectMake(CGRectGetMinX(self.playBtn.frame) - 50 - 51, CGRectGetMidY(self.playBtn.frame) - 17, 51, 34);
    [previousBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [previousBtn setAdjustsImageWhenHighlighted:NO];
    previousBtn.tag = TABLEVIEW_BEGIN_TAG;
    [previousBtn addTarget:self action:@selector(jumpBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:previousBtn];
    
    UIButton *latterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    latterBtn.frame = CGRectMake(CGRectGetMaxX(self.playBtn.frame) + 50, CGRectGetMidY(self.playBtn.frame) - 17, 51, 34);
    [latterBtn setImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
    [latterBtn setAdjustsImageWhenHighlighted:NO];
    latterBtn.tag = TABLEVIEW_BEGIN_TAG + 1;
    [latterBtn addTarget:self action:@selector(jumpBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:latterBtn];
    
    scrollViewY = 460;
    if (SCREENHEIGHT == 568) {
        scrollViewY = 477;
    }
    if (SCREENWIDTH == 375) {
        scrollViewY = 578;
    }else if (SCREENWIDTH == 414) {
        scrollViewY = 631;
    }
    
    UIView *progressBG = [[UIView alloc] initWithFrame:CGRectMake(0, scrollViewY, SCREENWIDTH, 20)];
    progressBG.backgroundColor = RGBA(236, 228, 242, 1);
    [self.view addSubview:progressBG];
    
    self.progressView = [[UIView alloc] initWithFrame:CGRectMake(0, scrollViewY, 1, 20)];
    self.progressView.backgroundColor = RGBA(254, 211, 227, 1);
    [self.view addSubview:self.progressView];
    
    self.currentTime = [[UILabel alloc] initWithFrame:CGRectMake(0, scrollViewY, 52, 20)];
    self.currentTime.textAlignment = NSTextAlignmentRight;
    self.currentTime.font = [UIFont fontWithName:@"PingFangSC-Light" size:14];
    self.currentTime.textColor = HexRGB(0x1688D2);
    self.currentTime.text = @"00:00";
    [self.view addSubview:self.currentTime];
    
    self.totalTime = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH - 52, scrollViewY, 52, 20)];
    self.totalTime.textAlignment = NSTextAlignmentLeft;
    self.totalTime.font = [UIFont fontWithName:@"PingFangSC-Light" size:14];
    self.totalTime.textColor = HexRGB(0x1688D2);
    self.totalTime.text = @"00:00";
    [self.view addSubview:self.totalTime];
    
    scrollViewY = 506;
    if (SCREENWIDTH == 375) {
        scrollViewY = 605;
    }else if (SCREENWIDTH == 414) {
        scrollViewY = 674;
    }

    UIButton *adBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [adBtn setImage:[UIImage imageNamed:@"adx2"] forState:UIControlStateNormal];
    adBtn.frame = CGRectMake(SCREENWIDTH * 0.5 - 139, scrollViewY, 278, 62);
    [adBtn addTarget:self action:@selector(goOtherAppDownload) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:adBtn];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playBtnAction:) name:@"pauseMusic" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fadeShareBtn) name:@"fadeShareBtn" object:nil];
}

-(void)fadeShareBtn
{
    UIButton *btn = (UIButton *)[self.view viewWithTag:TABLEVIEW_BEGIN_TAG * 10];
    
    if (btn) {
        btn.hidden = YES;
    }
}

-(void)goMenuView:(id)sender
{    
    [[SliderViewController sharedSliderController] leftItemClick];
}

- (void)goOtherAppDownload
{
    //跳妈咪好睡
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/id1141414335?mt=8"]];
}

-(void)share:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    [self touchAnimationWithBtn:button];
    
    ShareAlertView *alertView = [[ShareAlertView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:alertView];
    
    [alertView showView];
}

-(void)playBtnAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    
    if ([btn isKindOfClass:[UIButton class]]) {
        [self touchAnimationWithBtn:btn];
    }
    
    BOOL fromNotification = NO;
    
    if (![btn isKindOfClass:[UIButton class]]) {
        btn = self.playBtn;
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
        
        [self playMusicInstall];
    }
    
    btn.selected = !btn.selected;
}

-(void)jumpBtnAction:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    [self touchAnimationWithBtn:button];
    
    UIButton *btn = (UIButton *)sender;
    
    [self.tableheadView scrollWithType:btn.tag - TABLEVIEW_BEGIN_TAG];
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

#pragma mark
#pragma mark headview datasource delegate
- (NSUInteger)numberOfItemFor:(MptTableHeadView *)scrollView {
    return [self.picArray count];
}

- (MptTableHeadCell *)cellViewForScrollView:(MptTableHeadView *)scrollView frame:(CGRect)frame AtIndex:(NSUInteger)index {
    static NSString *indentif = @"headCell";
    CartoonHeadView *cell = (CartoonHeadView *)[scrollView dequeueCellWithIdentifier:indentif];
    if (!cell) {
        cell = [[CartoonHeadView alloc] initWithFrame:frame withIdentifier:indentif];
    }
    id objc = nil;
    if (self.picArray.count > index) {
        objc = [self.picArray objectAtIndex:index];
    } else {
        return cell;
    }
    
    if ([objc isKindOfClass:[NSString class]]) {
        NSString *imgUrl = (NSString *)objc;
        cell.imageView.image = [UIImage imageNamed:imgUrl];
        cell.titleView.image = [UIImage imageNamed:self.titleImgArray[index]];
    }
    
    return cell;
}

- (void)tableHeadView:(MptTableHeadView *)headView didSelectIndex:(NSUInteger)index {
    return;
}

- (void)tableHeadView:(MptTableHeadView *)headView didScrollToIndex:(NSUInteger)index
{
    NSLog(@"page ==== %ld",(unsigned long)index);
    
    self.musicIndex = index;
    
    [self stopMusic];
    
    self.currentPlayTime = 0;

    [self playMusicWithIndex:index];

    [self playMusicInstall];
    
    self.playBtn.selected = YES;
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
}

- (void)playMusicInstall
{
    self.totalTime.text = [self timeStringWith:self.playTime];
    
    [self updateProgressView];
    
    [self performSelector:@selector(playMusicTimer) withObject:nil afterDelay:1.0];
}

-(void)playMusicTimer
{
    self.currentPlayTime ++;
    
    if (self.currentPlayTime >= self.playTime) {
        [self stopMusic];
        
        self.currentPlayTime = 0;
    }else{
        
        [self performSelector:@selector(playMusicTimer) withObject:nil afterDelay:1.0];
    }
    
    [self updateProgressView];
}

- (void)stopMusic
{
    [[AudioTask shareAudioTask] stopTaskWithType:backgroundTask];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(playMusicTimer) object:nil];
}

- (void)pauseMusic
{
    [[AudioTask shareAudioTask] stopTaskWithType:backgroundTask];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(playMusicTimer) object:nil];
}

- (void)updateProgressView
{
    CGFloat percent = self.currentPlayTime * 1.0 / self.playTime;
    
    CGRect frame = self.progressView.frame;
    frame.size.width = percent * SCREENWIDTH;
    self.progressView.frame = frame;
    
    self.currentTime.text = [self timeStringWith:self.currentPlayTime];
}

- (NSString *)timeStringWith:(NSInteger)time
{
    return [NSString stringWithFormat:@"%@%ld:%@%ld",time/60 > 9 ? @"" : @"0",time/60,time%60 > 9 ? @"" : @"0",time%60];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

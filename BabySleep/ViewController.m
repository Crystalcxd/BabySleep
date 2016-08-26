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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playBtnAction:) name:@"pauseMusic" object:nil];
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
    
//    //设置锁屏仍能继续播放
//    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:nil];
//    [[AVAudioSession sharedInstance] setActive: YES error: nil];
//    
//    player=[[AVAudioPlayer alloc] initWithContentsOfURL:url error:Nil];
//    player.numberOfLoops = -1;
//    [player prepareToPlay];
//    [player play];
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

//    [player stop];
//    player = nil;
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(playMusicTimer) object:nil];
}

- (void)pauseMusic
{
    [[AudioTask shareAudioTask] stopTaskWithType:backgroundTask];

//    [player pause];
    
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

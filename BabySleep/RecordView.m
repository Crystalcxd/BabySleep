//
//  RecordView.m
//  BabySleep
//
//  Created by Michael on 2016/8/29.
//  Copyright © 2016年 Michael. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

#import "RecordView.h"
#import "SaveMusicView.h"
#import "TFLargerHitButton.h"

#import "MusicData.h"

#import "Utility.h"

@interface RecordView ()<AVAudioRecorderDelegate>

@property (nonatomic , strong) UIView *circleBG;

@property (nonatomic , strong) UIView *contentView;

@property (nonatomic , strong) UILabel *timeLabel;

@property (nonatomic , strong) AVAudioRecorder *audioRecorder;//音频录音机

@property (nonatomic , assign) NSInteger time;

@property (nonatomic , strong) NSTimer *timer;                 //监控音频播放进度

@property (nonatomic , strong) MusicData *data;

@end

@implementation RecordView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.circleBG = [[UIView alloc] initWithFrame:CGRectMake(SCREENWIDTH * 0.5 - 26, SCREENHEIGHT - 52 - 26, 52, 52)];
        self.circleBG.backgroundColor = HexRGB(0xFFE7EF);
        self.circleBG.layer.cornerRadius = CGRectGetWidth(self.circleBG.frame) * 0.5;
        [self addSubview:self.circleBG];
        
        self.contentView = [[UIView alloc] initWithFrame:self.bounds];
        [self addSubview:self.contentView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 215, SCREENWIDTH, 24)];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont fontWithName:@"DFPYuanW3" size:24];
        label.textColor = HexRGB(0x9E9E9E);
        label.text = @"时间";
        [self.contentView addSubview:label];
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 234, SCREENWIDTH, 95)];
        self.timeLabel.textAlignment = NSTextAlignmentCenter;
        self.timeLabel.font = [UIFont fontWithName:@"PingFangSC-Thin" size:68];
        self.timeLabel.textColor = HexRGB(0xFF756F);
        self.timeLabel.text = @"00:00:00";
        [self.contentView addSubview:self.timeLabel];
        
        TFLargerHitButton *cancelbtn = [TFLargerHitButton buttonWithType:UIButtonTypeCustom];
        cancelbtn.frame = CGRectMake(56, SCREENHEIGHT - 52 - 9, 18, 18);
        [cancelbtn setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
        [cancelbtn setAdjustsImageWhenHighlighted:NO];
        [cancelbtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:cancelbtn];
        
        TFLargerHitButton *saveBtn = [TFLargerHitButton buttonWithType:UIButtonTypeCustom];
        saveBtn.frame = CGRectMake(SCREENWIDTH - 56 - 20, SCREENHEIGHT - 52 - 9, 20, 18);
        [saveBtn setImage:[UIImage imageNamed:@"record_ok"] forState:UIControlStateNormal];
        [saveBtn setAdjustsImageWhenHighlighted:NO];
        [saveBtn addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:saveBtn];
        
        self.contentView.alpha = 0;
    }
    
    return self;
}

- (NSString *)currentMusicName
{
    NSDateFormatter *defaultMatter = nil;
    
    defaultMatter = [[NSDateFormatter alloc] init];
    [defaultMatter setDateFormat:@"yyyy_MMdd_HH点mm分ss秒"];
    
    NSDate *timeDate = [NSDate date];
    
    NSString *timeString = [defaultMatter stringFromDate:timeDate];

    return timeString;
}

- (void)startRecoder
{
    if (![self.audioRecorder isRecording]) {
        [self.audioRecorder record];//首次使用应用时如果调用record方法会询问用户是否允许使用麦克风
        self.timer.fireDate=[NSDate distantPast];
    }
}

#pragma mark - ButtonAction

- (void)cancelAction:(id)sender
{
    [_audioRecorder stop];
    [self.timer invalidate];
    self.timer = nil;
    
    [self deleteRecord];
    [self fadeRecordView];
}

- (void)confirmAction:(id)sender
{
    [_audioRecorder stop];
    [self.timer invalidate];
    self.timer = nil;

    SaveMusicView *saveMusicView = [[SaveMusicView alloc] initWithFrame:self.bounds];
    
    saveMusicView.fatherVC = self.fatherVC;
    
    [saveMusicView configureWith:self.data];
    
    __weak typeof(self) weakSelf = self;
 
    saveMusicView.EndSaveMusic = ^{
        [weakSelf.fatherVC reloadUserData];
        [weakSelf performSelector:@selector(fadeRecordView) withObject:nil afterDelay:0.5];
//        [weakSelf showClearAllMusicAlert];
    };

    [self addSubview:saveMusicView];
}

- (void)deleteRecord
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSString *MapLayerDataPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.caf",self.data.indexName]];
    BOOL bRet = [fileMgr fileExistsAtPath:MapLayerDataPath];
    if (bRet) {
        //
        NSError *err;
        [fileMgr removeItemAtPath:MapLayerDataPath error:&err];
    }
}

- (void)showRecordView
{
    self.data = [[MusicData alloc] init];
    
    NSString *index = [self currentMusicName];
    
    self.data.indexName = index;
    self.data.musicName = index;
    self.data.imageName = @"record_save_head.png";
    self.data.volum = 0.5;
    
    [self setAudioSession];
    
    [self installAudioRecorder];
    
    __weak typeof(self) weakSelf = self;

    [UIView animateWithDuration:1.0 animations:^{
        weakSelf.circleBG.transform = CGAffineTransformScale(self.circleBG.transform, 30, 30);
        weakSelf.contentView.alpha = 1;
    } completion:^(BOOL finished) {
        weakSelf.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(audioPowerChange)userInfo:nil repeats:YES];
        if (![weakSelf.audioRecorder isRecording]) {
            [weakSelf.audioRecorder record];//首次使用应用时如果调用record方法会询问用户是否允许使用麦克风
            weakSelf.timer.fireDate=[NSDate distantPast];
        }
    }];
}

- (void)pauseRecord
{
    [self.timer invalidate];
    self.timer = nil;
    [_audioRecorder pause];
}

- (void)fadeRecordView
{
    self.data = nil;
    _audioRecorder = nil;
    
    UInt32 doChangeDefaultRoute = 1;
    AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryDefaultToSpeaker,sizeof(doChangeDefaultRoute), &doChangeDefaultRoute);

    __weak typeof(self) weakSelf = self;

    [UIView animateWithDuration:1.0 animations:^{
        weakSelf.circleBG.transform = CGAffineTransformScale(self.circleBG.transform, 1 / 30.0, 1 / 30.0);
        weakSelf.contentView.alpha = 0;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"enableRecordView" object:nil];
    }];
}

-(void)audioPowerChange{
    self.time ++;
    self.timeLabel.text = [NSString stringWithFormat:@"%@%ld:%@%ld:%@%ld",self.time/3600 >= 10 ? @"" : @"0",self.time/3600,self.time%3600/60 >= 10 ? @"" : @"0",self.time%3600/60,self.time%3600%60 >= 10 ? @"" : @"0",self.time%3600%60];
}

/**
 *  设置音频会话
 */
-(void)setAudioSession{
    AVAudioSession *audioSession=[AVAudioSession sharedInstance];
    //设置为播放和录音状态，以便可以在录制完之后播放录音
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [audioSession setActive:YES error:nil];
}

- (void)installAudioRecorder
{
    if (!_audioRecorder) {
        //创建录音文件保存路径
        NSURL *url=[self getSavePath];
        //创建录音格式设置
        NSDictionary *setting=[self getAudioSetting];
        //创建录音机
        NSError *error=nil;
        _audioRecorder=[[AVAudioRecorder alloc]initWithURL:url settings:setting error:&error];
        _audioRecorder.delegate=self;
        _audioRecorder.meteringEnabled=YES;//如果要监控声波则必须设置为YES
        if (error) {
            NSLog(@"创建录音机对象时发生错误，错误信息：%@",error.localizedDescription);
            //            return nil;
        }
    }
}

/**
 *  取得录音文件保存路径
 *
 *  @return 录音文件路径
 */
-(NSURL *)getSavePath{
    NSString *urlStr=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    urlStr=[urlStr stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.caf",self.data.indexName]];
    NSLog(@"file path:%@",urlStr);
    NSURL *url=[NSURL fileURLWithPath:urlStr];
    return url;
}

/**
 *  取得录音文件设置
 *
 *  @return 录音设置
 */
-(NSDictionary *)getAudioSetting{
    NSMutableDictionary *dicM=[NSMutableDictionary dictionary];
    //设置录音格式
    [dicM setObject:@(kAudioFormatLinearPCM) forKey:AVFormatIDKey];
    //设置录音采样率，8000是电话采样率，对于一般录音已经够了
    [dicM setObject:@(8000) forKey:AVSampleRateKey];
    //设置通道,这里采用单声道
    [dicM setObject:@(1) forKey:AVNumberOfChannelsKey];
    //每个采样点位数,分为8、16、24、32
    [dicM setObject:@(8) forKey:AVLinearPCMBitDepthKey];
    //是否使用浮点数采样
    [dicM setObject:@(YES) forKey:AVLinearPCMIsFloatKey];
    //....其他设置等
    return dicM;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

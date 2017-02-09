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
#import "MptTableHeadView.h"
#import "HomeHeadView.h"

#import "RecordListCell.h"

#import "AudioTask.h"

#import "WMUserDefault.h"

#import <AVFoundation/AVFoundation.h>

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,HeadViewDelegate,HeadViewDataSource>
{
    AVAudioPlayer *player;
}

@property (nonatomic , strong) EditMusicView *editMusicView;
@property (nonatomic , strong) MptTableHeadView *tableheadView;
@property (nonatomic , strong) RecordView *recordView;

@property (nonatomic , strong) UITableView *tableView;

@property (nonatomic , strong) UIButton *recordBtn;

@property (nonatomic , strong) UIView *progressView;

@property (nonatomic , strong) NSMutableArray *urlArray;

@property (nonatomic , strong) NSMutableArray *defaultArr;

@property (nonatomic , strong) NSMutableArray *userArr;

@property (nonatomic , strong) NSMutableArray *deleteArr;

@property (nonatomic , assign) NSInteger musicIndex;

@property (nonatomic , strong) NSIndexPath *selectIndexPath;

@property (nonatomic , assign) BOOL editMode;

@end

static NSString * const musicIdentifier = @"music";

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

    self.deleteArr = [NSMutableArray array];
    
    self.urlArray = [NSMutableArray arrayWithObjects:@"https://itunes.apple.com/cn/app/id1141414335?mt=8",@"https://itunes.apple.com/cn/app/id1128178648?mt=8",@"https://itunes.apple.com/cn/app/id949737354?mt=8", nil];
    
    self.defaultArr = [NSMutableArray new];
    if ([WMUserDefault arrayForKey:@"DefaultData"]) {
        [self.defaultArr addObjectsFromArray:[WMUserDefault arrayForKey:@"DefaultData"]];
    }

    self.userArr = [NSMutableArray new];
    if ([WMUserDefault arrayForKey:@"UserData"]) {
        [self.userArr addObjectsFromArray:[WMUserDefault arrayForKey:@"UserData"]];
    }

    TFLargerHitButton *leftBtn = [[TFLargerHitButton alloc] initWithFrame:CGRectMake(13, 32, 15, 14)];
    [leftBtn setImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(goMenuView:) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setAdjustsImageWhenHighlighted:NO];
    [self.view addSubview:leftBtn];
    
    UIImageView *titleView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREENWIDTH - 58) * 0.5, 35, 58, 22)];
    titleView.image = [UIImage imageNamed:@"home_Story"];
    [self.view addSubview:titleView];
    
    UIImageView *homeBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 65, SCREENWIDTH, 13)];
    homeBar.image = [UIImage imageNamed:@"home_bar"];
    [self.view addSubview:homeBar];
    
    NSInteger scrollViewHeight = 0;
    
    if (SCREENWIDTH == 320) {
        scrollViewHeight = 50;
    }else if (SCREENWIDTH == 375) {
        scrollViewHeight = 75;
    }else{
        scrollViewHeight = 80;
    }
    
    scrollViewHeight ++;
    
    self.tableheadView = [[MptTableHeadView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, scrollViewHeight) Type:MptTableHeadViewOther];
    self.tableheadView.dataSource = self;
    self.tableheadView.delegate = self;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(homeBar.frame), SCREENWIDTH, SCREENHEIGHT - CGRectGetMaxY(topView.frame) - 52)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    self.tableView.tableHeaderView = self.tableheadView;
    
    self.editMusicView = [[EditMusicView alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT - 52, SCREENWIDTH, 52)];
    
    __weak typeof(self) weakSelf = self;
    self.editMusicView.StartEdit = ^{
        weakSelf.editMode = YES;
        weakSelf.recordBtn.alpha = 0.0;
        weakSelf.recordBtn.hidden = YES;
        weakSelf.recordBtn.enabled = NO;
        [weakSelf.tableView reloadData];
    };
    
    self.editMusicView.EndEdit = ^{
        weakSelf.editMode = NO;
        [UIView animateWithDuration:0.5 delay:0.5 options:UIViewAnimationOptionLayoutSubviews animations:^{
            weakSelf.recordBtn.alpha = 1.0;
        } completion:^(BOOL finished) {
            weakSelf.recordBtn.hidden = NO;
            weakSelf.recordBtn.enabled = YES;
        }];
        [weakSelf.tableView reloadData];
    };
    
    self.editMusicView.ClearMusicData = ^{
        [weakSelf showClearAllMusicAlert];
    };

    self.editMusicView.DeleteMusicData = ^{
        [weakSelf showClearSeleteMusicAlert];
    };

    [self.view addSubview:self.editMusicView];
    
    self.recordView = [[RecordView alloc] initWithFrame:self.view.bounds];
    self.recordView.fatherVC = self;
    
    self.recordBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH * 0.5 - 26, CGRectGetMinY(self.editMusicView.frame) - 26, 52, 52)];
    [self.recordBtn setImage:[UIImage imageNamed:@"home_record"] forState:UIControlStateNormal];
    [self.recordBtn setAdjustsImageWhenHighlighted:NO];
    [self.recordBtn addTarget:self action:@selector(showRecordView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.recordBtn];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enableRecordView) name:@"enableRecordView" object:nil];
    
    [[AVAudioSession sharedInstance] setActive:YES error:nil];//创建单例对象并且使其设置为活跃状态.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioRouteChangeListenerCallback:)   name:AVAudioSessionRouteChangeNotification object:nil];//设置通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioRouteChangeListenerCallback:)   name:AVAudioSessionInterruptionNotification object:nil];//设置通知
}

//通知方法的实现
- (void)audioRouteChangeListenerCallback:(NSNotification*)notification
{
    NSDictionary *interuptionDict = notification.userInfo;
    NSInteger routeChangeReason = [[interuptionDict valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
    switch (routeChangeReason) {
        case AVAudioSessionRouteChangeReasonNewDeviceAvailable:
            NSLog(@"AVAudioSessionRouteChangeReasonNewDeviceAvailable");
            //            tipWithMessage(@"耳机插入");
            break;
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:{
            NSLog(@"AVAudioSessionRouteChangeReasonOldDeviceUnavailable");
            [self stopMusic];
            MusicData *data = [self currentMusicDataWith:self.selectIndexPath];
            data.selected = NO;
            self.selectIndexPath = nil;
            [self.tableView reloadData];
        }
            //            tipWithMessage(@"耳机拔出，停止播放操作");
            break;
        case AVAudioSessionRouteChangeReasonCategoryChange:
            // called at start - also when other audio wants to play
            //            tipWithMessage(@"AVAudioSessionRouteChangeReasonCategoryChange");
            break;
    }
}

- (MusicData *)currentMusicDataWith:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return self.defaultArr[indexPath.row];
    }else{
        return self.userArr[indexPath.row];
    }
}

- (BOOL)deleteStatusWith:(NSIndexPath *)indexPath
{
    for (NSIndexPath *index in self.deleteArr) {
        if (index == indexPath) {
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)deleteWith:(NSIndexPath *)indexPath
{
    for (NSIndexPath *index in self.deleteArr) {
        if (index == indexPath) {
            [self.deleteArr removeObject:index];
            return NO;
        }
    }
    
    [self.deleteArr addObject:indexPath];
    return YES;
}

- (void)reloadDefaultData
{
    self.defaultArr = [NSMutableArray new];
    if ([WMUserDefault arrayForKey:@"DefaultData"]) {
        [self.defaultArr addObjectsFromArray:[WMUserDefault arrayForKey:@"DefaultData"]];
    }
    
    [self.tableView reloadData];
}

- (void)showRecordBtnWith:(BOOL)show
{
    self.recordBtn.hidden = !show;
}

- (void)reloadUserData
{
    self.userArr = [NSMutableArray new];
    if ([WMUserDefault arrayForKey:@"UserData"]) {
        [self.userArr addObjectsFromArray:[WMUserDefault arrayForKey:@"UserData"]];
    }
    
    [self.tableView reloadData];
}
#pragma mark headview datasource delegate
- (NSUInteger)numberOfItemFor:(MptTableHeadView *)scrollView {
    return 3;
}

- (MptTableHeadCell *)cellViewForScrollView:(MptTableHeadView *)scrollView frame:(CGRect)frame AtIndex:(NSUInteger)index {
    static NSString *indentif = @"headCell";
    HomeHeadView *cell = (HomeHeadView *)[scrollView dequeueCellWithIdentifier:indentif];
    if (!cell) {
        cell = [[HomeHeadView alloc] initWithFrame:frame withIdentifier:indentif];
    }
//    id objc = nil;
    if (3 > index) {
//        objc = [self.array objectAtIndex:index];
    } else {
        return cell;
    }
    
    NSString *imageIcon = [NSString stringWithFormat:@"ad%ld_%ld.png",index + 1, (NSInteger)SCREENWIDTH * 2];
    
    cell.imageView.image = [UIImage imageNamed:imageIcon];
    
    return cell;
}

- (void)tableHeadView:(MptTableHeadView *)headView didSelectIndex:(NSUInteger)index {
    if (self.urlArray.count <= index) {
        return;
    }
    
    NSString *url = [self.urlArray objectAtIndex:index];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.defaultArr.count;
    }else{
        return self.userArr.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 115;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecordListCell *cell = (RecordListCell *)[tableView dequeueReusableCellWithIdentifier:musicIdentifier];
    if (cell == nil) {
        cell = [[RecordListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:musicIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.indexPath = indexPath;
//    cell.delegate = self;
    
    cell.VolumValueChange = ^(CGFloat volume){
        [[AudioTask shareAudioTask] setPlayVolume:volume];
    };

    if (indexPath.section == 1) {
        if (indexPath.row < self.userArr.count) {
            MusicData *musicData = [self.userArr objectAtIndex:indexPath.row];
            
            [cell configureWithMusic:musicData volum:@"0.5" selected:musicData.selected editMode:self.editMode];
            
            if (self.editMode) {
                [cell deleteSelect:[self deleteStatusWith:indexPath]];
            }
        }
    }else{
        if (indexPath.row < self.defaultArr.count) {
            MusicData *musicData = [self.defaultArr objectAtIndex:indexPath.row];
            
            [cell configureWithMusic:musicData volum:@"0.5" selected:musicData.selected editMode:self.editMode];
            
            if (self.editMode) {
                [cell deleteSelect:[self deleteStatusWith:indexPath]];
            }
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.editMode) {
        BOOL select = [self deleteWith:indexPath];
        
        RecordListCell *cell = (RecordListCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        
        [cell deleteSelect:select];
    }else{
        if (self.selectIndexPath == indexPath) {
            MusicData *data = [self currentMusicDataWith:self.selectIndexPath];
            data.selected = NO;
            
            self.selectIndexPath = nil;
            
            [self.tableView reloadData];
            
            [self stopMusic];
            
            return;
        }
        
        MusicData *data = [self currentMusicDataWith:self.selectIndexPath];
        data.selected = NO;
        
        MusicData *currentData = [self currentMusicDataWith:indexPath];
        currentData.selected = YES;
        
        self.selectIndexPath = indexPath;
        
        [self.tableView reloadData];
        
        [[AudioTask shareAudioTask] setVolum:data.volum];

        if (indexPath.section == 0) {
            [self playDefaultMusicWithIndex:indexPath.row];
        }else{
            [self playUserMusicWithIndex:indexPath.row];
        }
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100) {
        if (buttonIndex == 0) {
            [WMUserDefault setArray:[NSMutableArray array] forKey:@"DefaultData"];
            
            for (MusicData *music in self.userArr) {
                [self removeDocumentFileWith:music];
            }
            [WMUserDefault setArray:[NSMutableArray array] forKey:@"UserData"];
            
            [self reloadDefaultData];
            
            [self reloadUserData];
        }
    }else if (alertView.tag == 101) {
        if (buttonIndex == 0) {
            NSMutableArray *currentDefaultArr = [NSMutableArray arrayWithArray:self.defaultArr];
            NSMutableArray *currentUserArr = [NSMutableArray arrayWithArray:self.userArr];
            
            for (NSIndexPath *indexPath in self.deleteArr) {
                if (indexPath.section == 0) {
                    MusicData *music = [self.defaultArr objectAtIndex:indexPath.row];
                    [currentDefaultArr removeObject:music];
                    
                    
                }
                if (indexPath.section == 1) {
                    MusicData *music = [self.userArr objectAtIndex:indexPath.row];
                    [self removeDocumentFileWith:music];
                    
                    [currentUserArr removeObject:music];
                }
            }
            [WMUserDefault setArray:currentDefaultArr forKey:@"DefaultData"];
            [WMUserDefault setArray:currentUserArr forKey:@"UserData"];
            
            [self reloadDefaultData];
            
            [self reloadUserData];
        }
    }
}

- (void)removeDocumentFileWith:(MusicData *)musicData
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSString *MapLayerDataPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.caf",musicData.indexName]];
    BOOL bRet = [fileMgr fileExistsAtPath:MapLayerDataPath];
    if (bRet) {
        //
        NSError *err;
        [fileMgr removeItemAtPath:MapLayerDataPath error:&err];
    }
    
    if (![musicData.imageName isEqualToString:@"record_save_head.png"]) {
        NSString *imageDataPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",musicData.indexName]];
        BOOL bRet = [fileMgr fileExistsAtPath:imageDataPath];
        if (bRet) {
            //
            NSError *err;
            [fileMgr removeItemAtPath:imageDataPath error:&err];
        }
    }
}

#pragma mark - ButtonAction

- (void)showClearAllMusicAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"确定清空所有音乐？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    alert.tag = 100;
    [alert show];
}

- (void)showClearSeleteMusicAlert
{
    if (self.deleteArr.count == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请至少选择一首歌" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"确定删除所选音乐？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    alert.tag = 101;
    [alert show];
}

- (void)showRecordView:(id)sender
{
    MusicData *data = [self currentMusicDataWith:self.selectIndexPath];
    data.selected = NO;
    
    self.selectIndexPath = nil;
    
    [self.tableView reloadData];
    
    [self stopMusic];

    UIButton *btn = (UIButton *)sender;
    
    btn.enabled = NO;
    
    if (btn.selected) {
        [self.recordView pauseRecord];        
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

- (void)touchAnimationWithBtn:(UIButton *)button
{
    TouchAnimationView *view = [[TouchAnimationView alloc] initWithFrame:CGRectMake(button.center.x - 22, button.center.y - 22, 44, 44)];
    [self.view addSubview:view];
    
    TouchInsideAnimationView *insideView = [[TouchInsideAnimationView alloc] initWithFrame:CGRectMake(button.center.x - 4, button.center.y - 4, 8, 8)];
    [self.view addSubview:insideView];
    
    [view disappearAnimation];
    [insideView disappearAnimation];
}

- (void)playDefaultMusicWithIndex:(NSInteger)index
{
    MusicData *music = self.defaultArr[index];
    
    //1.音频文件的url路径
    NSString *musicFilePath= [[NSBundle mainBundle] pathForResource:music.indexName ofType:@"m4a"];
    
    [self audioPlayWithPath:[[NSURL alloc] initFileURLWithPath:musicFilePath]];
}

- (void)playUserMusicWithIndex:(NSInteger)index
{
    MusicData *music = self.userArr[index];
    
    //1.音频文件的url路径
    NSString *urlStr=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    urlStr=[urlStr stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.caf",music.indexName]];
    
    [self audioPlayWithPath:[[NSURL alloc] initFileURLWithPath:urlStr]];
}

-(void)audioPlayWithPath:(NSURL *)url
{
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

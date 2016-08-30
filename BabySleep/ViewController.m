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

#import "RecordListCell.h"

#import "AudioTask.h"

#import "WMUserDefault.h"

#import <AVFoundation/AVFoundation.h>

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    AVAudioPlayer *player;
}

@property (nonatomic , strong) EditMusicView *editMusicView;

@property (nonatomic , strong) RecordView *recordView;

@property (nonatomic , strong) UITableView *tableView;

@property (nonatomic , strong) UIButton *recordBtn;

@property (nonatomic , strong) UIView *progressView;

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
    
    self.defaultArr = [NSMutableArray new];
    if ([WMUserDefault arrayForKey:@"DefaultData"]) {
        [self.defaultArr addObjectsFromArray:[WMUserDefault arrayForKey:@"DefaultData"]];
    }

    self.userArr = [NSMutableArray new];
    if ([WMUserDefault arrayForKey:@"UserData"]) {
        [self.userArr addObjectsFromArray:[WMUserDefault arrayForKey:@"UserData"]];
    }

    TFLargerHitButton *leftBtn = [[TFLargerHitButton alloc] initWithFrame:CGRectMake(16, 37, 15, 14)];
    [leftBtn setImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(goMenuView:) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setAdjustsImageWhenHighlighted:NO];
    [self.view addSubview:leftBtn];
    
    UIImageView *titleView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREENWIDTH - 71.35) * 0.5, 40, 71.35, 19.39)];
    titleView.image = [UIImage imageNamed:@"babysleep"];
    [self.view addSubview:titleView];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topView.frame), SCREENWIDTH, SCREENHEIGHT - CGRectGetMaxY(topView.frame) - 52)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    self.editMusicView = [[EditMusicView alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT - 52, SCREENWIDTH, 52)];
    
    __weak typeof(self) weakSelf = self;
    self.editMusicView.StartEdit = ^{
        weakSelf.editMode = YES;
        weakSelf.recordBtn.hidden = YES;
        weakSelf.recordBtn.enabled = NO;
        [weakSelf.tableView reloadData];
    };
    
    self.editMusicView.EndEdit = ^{
        weakSelf.editMode = NO;
        weakSelf.recordBtn.hidden = NO;
        weakSelf.recordBtn.enabled = YES;
        [weakSelf.tableView reloadData];
    };
    
    [self.view addSubview:self.editMusicView];
    
    self.recordView = [[RecordView alloc] initWithFrame:self.view.bounds];
    
    self.recordBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH * 0.5 - 26, CGRectGetMinY(self.editMusicView.frame) - 26, 52, 52)];
    [self.recordBtn setImage:[UIImage imageNamed:@"home_record"] forState:UIControlStateNormal];
    [self.recordBtn setAdjustsImageWhenHighlighted:NO];
    [self.recordBtn addTarget:self action:@selector(showRecordView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.recordBtn];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playBtnAction:) name:@"pauseMusic" object:nil];
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
    
    __weak typeof(self) weakSelf = self;
    cell.VolumValueChange = ^(CGFloat volume){
        
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
            return;
        }
        
        MusicData *data = [self currentMusicDataWith:self.selectIndexPath];
        data.selected = NO;
        
        MusicData *currentData = [self currentMusicDataWith:indexPath];
        currentData.selected = YES;
        
        self.selectIndexPath = indexPath;
        
        [self.tableView reloadData];
        
        if (indexPath.section == 0) {
            [self playDefaultMusicWithIndex:indexPath.row];
        }
    }
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
//            [self playMusicWithIndex:self.musicIndex];
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

- (void)playDefaultMusicWithIndex:(NSInteger)index
{
    MusicData *music = self.defaultArr[index];
    
    //1.音频文件的url路径
    NSString *musicFilePath= [[NSBundle mainBundle] pathForResource:music.indexName ofType:@"m4a"];
    
    [self audioPlayWithPath:[[NSURL alloc] initFileURLWithPath:musicFilePath]];
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

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

@interface ViewController ()<HeadViewDelegate,HeadViewDataSource>

@property (nonatomic , strong) UIButton *playBtn;

@property (nonatomic , strong) MptTableHeadView *tableheadView;

@property (nonatomic , strong) UIView *progressView;

@property (nonatomic , strong) NSMutableArray *picArray;

@property (nonatomic , strong) NSMutableArray *musicArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = HexRGB(0xDBF4FF);
    
    self.picArray = [NSMutableArray arrayWithObjects:@"baby",@"cleaner",@"girl",@"hairdryer",@"radio", nil];
    self.musicArray = [NSMutableArray arrayWithObjects:@"whitenoise",@"cleaner",@"girl",@"hairdryer",@"audio", nil];

    TFLargerHitButton *leftBtn = [[TFLargerHitButton alloc] initWithFrame:CGRectMake(22, 33, 15, 14)];
    [leftBtn setImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(goMenuView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftBtn];
    
    TFLargerHitButton *rightBtn = [[TFLargerHitButton alloc] initWithFrame:CGRectMake(SCREENWIDTH - 22 - 15, 33, 15, 14)];
    [rightBtn setImage:[UIImage imageNamed:@"strawberry"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightBtn];

    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 27, SCREENWIDTH, 25)];
    title.textColor = HexRGB(0x1688D2);
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"宝贝快睡";
    title.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:title];
    
    CGFloat scrollViewY = 84;
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
    [self.view addSubview:self.playBtn];
    
    UIButton *previousBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    previousBtn.frame = CGRectMake(CGRectGetMinX(self.playBtn.frame) - 50 - 51, CGRectGetMidY(self.playBtn.frame) - 17, 51, 34);
    [self.view addSubview:previousBtn];
    
    UIButton *latterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    latterBtn.frame = CGRectMake(CGRectGetMaxX(self.playBtn.frame) + 50, CGRectGetMidY(self.playBtn.frame) - 17, 51, 34);
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
    
    self.progressView = [[UIView alloc] initWithFrame:CGRectMake(0, scrollViewY, 100, 20)];
    self.progressView.backgroundColor = RGBA(254, 211, 227, 1);
    [self.view addSubview:self.progressView];
    
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
}

-(void)goMenuView
{
    [[SliderViewController sharedSliderController] leftItemClick];
}

- (void)goOtherAppDownload
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/le-yi-le-you-hui-quan/id1004844450?mt=8"]];
}

-(void)share
{
    
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
    }
    
    return cell;
}

- (void)tableHeadView:(MptTableHeadView *)headView didSelectIndex:(NSUInteger)index {
//    [self goWebView];
    return;
    
    //    if (self.array.count == 0) {
    //        return;
    //    }
    //
    //    id objc = nil;
    //    if (self.array.count > index) {
    //        objc = [self.array objectAtIndex:index];
    //    } else {
    //        return;
    //    }
    //
    //    if ([objc isKindOfClass:[NSString class]]) {
    //        return;
    //    }
    //    else if ([objc isKindOfClass:[AVObject class]]) {
    //        AVObject *object = (AVObject *)objc;
    //
    //        NSString *str = [Utility safeStringWith:[object objectForKey:@"jumpUrl"]];
    //        if ([str isEqualToString:@""] || [str isEqualToString:@" "]) {
    //            return;
    //        }
    //        
    //        [self goWebViewWith:str];
    //    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

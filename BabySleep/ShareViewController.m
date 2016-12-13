//
//  ShareViewController.m
//  BabySleep
//
//  Created by medica_mac on 16/7/6.
//  Copyright © 2016年 Michael. All rights reserved.
//

#import "ShareViewController.h"

#import "Utility.h"

#import "TFLargerHitButton.h"

#import "ShareView.h"

#import "WXApi.h"

#import <ShareSDK/ShareSDK.h>
#import <CoreLocation/CoreLocation.h>

@interface ShareViewController ()<ShareViewDelegate,CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    double latitude;
    double longitude;
}

@end

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (![Utility ifChinese]) {
        [self initializeLocationService];
    }
    
    self.view.backgroundColor = HexRGB(0xDBF4FF);
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 70)];
    topView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
    [self.view addSubview:topView];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 29, SCREENWIDTH, 25)];
    title.textColor = HexRGB(0x1688D2);
    title.textAlignment = NSTextAlignmentCenter;
    title.text = NSLocalizedString(@"YourAdvice",nil);
    title.font = [UIFont fontWithName:@"DFPYuanW5" size:18];
    [self.view addSubview:title];
    
    TFLargerHitButton *backBtn = [[TFLargerHitButton alloc] initWithFrame:CGRectMake(22, 35, 14, 14)];
    [backBtn setImage:[UIImage imageNamed:@"cancel2"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:backBtn];

    if ([Utility ifChinese]) {
        ShareView *weixin = [[ShareView alloc] initWithFrame:CGRectMake(SCREENWIDTH * 0.5 - 70, 156, 140, 140) Name:@"微信" Color:HexRGB(0xC2EC7D) selectColor:HexRGB(0xD1EEA1)];
        weixin.tag = TABLEVIEW_BEGIN_TAG;
        weixin.delagate = self;
        [self.view addSubview:weixin];
        
        ShareView *pengyouquan = [[ShareView alloc] initWithFrame:CGRectMake(SCREENWIDTH * 0.5 - 70, 350, 140, 140) Name:@"朋友圈" Color:HexRGB(0x9CD6F6) selectColor:HexRGB(0xB1DCF3)];
        pengyouquan.tag = TABLEVIEW_BEGIN_TAG + 1;
        pengyouquan.delagate = self;
        [self.view addSubview:pengyouquan];
    }else{
        UIButton *facebook = [UIButton buttonWithType:UIButtonTypeCustom];
        facebook.frame = CGRectMake(SCREENWIDTH * 0.5 - 70, 156, 140, 140);
        facebook.tag = TABLEVIEW_BEGIN_TAG;
        [facebook setImage:[UIImage imageNamed:@"facebook"] forState:UIControlStateNormal];
        [facebook addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:facebook];
        
        UIButton *twitter = [UIButton buttonWithType:UIButtonTypeCustom];
        twitter.frame = CGRectMake(SCREENWIDTH * 0.5 - 70, 350, 140, 140);
        twitter.tag = TABLEVIEW_BEGIN_TAG + 1;
        [twitter setImage:[UIImage imageNamed:@"twitter"] forState:UIControlStateNormal];
        [twitter addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:twitter];
    }
}

- (void)initializeLocationService {
    // 初始化定位管理器
    locationManager = [[CLLocationManager alloc] init];
    // 设置代理
    locationManager.delegate = self;
    // 设置定位精确度到米
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    // 设置过滤器为无
    locationManager.distanceFilter = kCLDistanceFilterNone;
    // 判断的手机的定位功能是否开启
    // 开启定位:设置 > 隐私 > 位置 > 定位服务
    if ([CLLocationManager locationServicesEnabled]) {
        // 启动位置更新
        // 开启位置更新需要与服务器进行轮询所以会比较耗电，在不需要时用stopUpdatingLocation方法关闭;
        [locationManager startUpdatingLocation];
    }
    else {
        NSLog(@"请开启定位功能！");
    }
}

- (void)clickBtn:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    
    [self clickAction:btn.tag];
}

- (void)clickAction:(NSInteger)tag
{
    SSDKPlatformType type = 0;
    NSString *icon = @"icon120.png";
    NSString *title = NSLocalizedString(@"Baby's fast sleep", nil);
    NSString *text = NSLocalizedString(@"BabySleepAds", nil);
    NSString *shareUrl = @"https://itunes.apple.com/cn/app/id1128178648?mt=8";

    if ([Utility ifChinese]) {
        
        //1、创建分享参数（必要）
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        
        
        switch (tag - TABLEVIEW_BEGIN_TAG) {
            case 0:
                [shareParams SSDKSetupWeChatParamsByText:text title:title url:[NSURL URLWithString:shareUrl] thumbImage:[UIImage imageNamed:icon] image:[UIImage imageNamed:icon] musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeWebPage forPlatformSubType:SSDKPlatformSubTypeWechatSession];// 微信好友子平台
                type = SSDKPlatformSubTypeWechatSession;
                break;
            case 1:
                [shareParams SSDKSetupWeChatParamsByText:title title:title url:[NSURL URLWithString:shareUrl] thumbImage:[UIImage imageNamed:icon] image:[UIImage imageNamed:icon] musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeWebPage forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];// 微信好友子平台
                type = SSDKPlatformSubTypeWechatTimeline;
                break;
            default:
                break;
        }
        
        //2、分享
        [ShareSDK share:type parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
            if (state == SSDKResponseStateSuccess) {
                
            }else{
                
            }
        }];
    }else{
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        
        switch (tag - TABLEVIEW_BEGIN_TAG) {
            case 0:
                [shareParams SSDKSetupFacebookParamsByText:NSLocalizedString(@"BabySleepAds", nil) image:nil url:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/id1128178648?mt=8"] urlTitle:NSLocalizedString(@"Baby's fast sleep", nil) urlName:NSLocalizedString(@"Baby's fast sleep", nil) attachementUrl:nil type:SSDKContentTypeWebPage];
                type = SSDKPlatformTypeFacebook;
                break;
            case 1:
                [shareParams SSDKSetupTwitterParamsByText:[NSString stringWithFormat:@"%@ %@ %@",text,shareUrl,[Utility chatTimeStringWith:[[NSDate date] timeIntervalSince1970]]] images:[UIImage imageNamed:icon] latitude:latitude longitude:longitude type:SSDKContentTypeText];
                type = SSDKPlatformTypeTwitter;
                break;
            default:
                break;
        }
        
        [ShareSDK share:type parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
            NSLog(@"%@",error);
        }];
    }
}

#pragma mark - 微信分享
- (WXMediaMessage *)wxShareSiglMessageScene:(UIImage *)image
{
    WXMediaMessage *message = [WXMediaMessage message];
    
    WXWebpageObject *pageObject = [WXWebpageObject object];
    pageObject.webpageUrl = @"https://itunes.apple.com/cn/app/id1128178648?mt=8";
    
    message.mediaObject = pageObject;
    
//    WXFileObject *object = [WXFileObject object];
//    object.fileExtension = @"mp3";
//    
//    NSString*filePath = [[NSBundle mainBundle] pathForResource:@"girl" ofType:@"mp3"];
//    NSData* data= [NSData dataWithContentsOfFile:filePath];
//    
//    object.fileData = data;
//    
//    message.mediaObject = object;
    
    [message setThumbData:UIImageJPEGRepresentation(image,1)];

    return message;
}

- (void)ShareWeixinLinkContent:(WXMediaMessage *)message WXType:(NSInteger)scene {
    if ([WXApi isWXAppInstalled]) {
        SendMessageToWXReq *wxRequest = [[SendMessageToWXReq alloc] init];
        
        if ([message.mediaObject isKindOfClass:[WXWebpageObject class]]) {
            WXWebpageObject *webpageObject = message.mediaObject;
            if (webpageObject.webpageUrl.length == 0) {
                wxRequest.text = message.title;
                wxRequest.bText = YES;
            } else {
                wxRequest.message = message;
            }
        } else if ([message.mediaObject isKindOfClass:[WXImageObject class]]) {
            wxRequest.bText = NO;
            wxRequest.message = message;
        } else if ([message.mediaObject isKindOfClass:[WXVideoObject class]]) {
            wxRequest.bText = NO;
            wxRequest.message = message;
        } else if ([message.mediaObject isKindOfClass:[WXFileObject class]]) {
            wxRequest.bText = NO;
            wxRequest.message = message;
        }
        
        wxRequest.bText = NO;
        wxRequest.scene = (int)scene;
        
        [WXApi sendReq:wxRequest];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败" message:@"请使用其它分享途径。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
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

#pragma mark - CLLocationManagerDelegate
// 地理位置发生改变时触发
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    // 获取经纬度
    NSLog(@"纬度:%f",newLocation.coordinate.latitude);
    latitude = newLocation.coordinate.latitude;
    NSLog(@"经度:%f",newLocation.coordinate.longitude);
    longitude = newLocation.coordinate.longitude;
    // 停止位置更新
    [manager stopUpdatingLocation];
}

// 定位失误时触发
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"error:%@",error);
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

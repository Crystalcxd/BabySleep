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

@interface ShareViewController ()<ShareViewDelegate>

@end

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = HexRGB(0xDBF4FF);
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 70)];
    topView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
    [self.view addSubview:topView];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 27, SCREENWIDTH, 25)];
    title.textColor = HexRGB(0x1688D2);
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"分享给好友";
    title.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:title];
    
    TFLargerHitButton *backBtn = [[TFLargerHitButton alloc] initWithFrame:CGRectMake(22, 33, 14, 14)];
    [backBtn setImage:[UIImage imageNamed:@"cancel2"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:backBtn];

    ShareView *weixin = [[ShareView alloc] initWithFrame:CGRectMake(SCREENWIDTH * 0.5 - 70, 156, 140, 140) Name:@"微信" Color:HexRGB(0xD1EEA1)];
    weixin.tag = TABLEVIEW_BEGIN_TAG;
    weixin.delagate = self;
    [self.view addSubview:weixin];
    
    ShareView *pengyouquan = [[ShareView alloc] initWithFrame:CGRectMake(SCREENWIDTH * 0.5 - 70, 350, 140, 140) Name:@"朋友圈" Color:HexRGB(0xB1DCF3)];
    pengyouquan.tag = TABLEVIEW_BEGIN_TAG + 1;
    pengyouquan.delagate = self;
    [self.view addSubview:pengyouquan];
}

- (void)clickAction:(NSInteger)tag
{
    switch (tag) {
        case TABLEVIEW_BEGIN_TAG:
            
            break;
            
        default:
            break;
    }
    WXMediaMessage *message = [self wxShareSiglMessageScene:[UIImage imageNamed:@"icon120.png"]];
    message.title = @"宝贝快睡";
    message.description = @"宝贝快睡";
    
    [self ShareWeixinLinkContent:message WXType:tag - TABLEVIEW_BEGIN_TAG];
}

#pragma mark - 微信分享
- (WXMediaMessage *)wxShareSiglMessageScene:(UIImage *)image
{
    WXMediaMessage *message = [WXMediaMessage message];
    
    WXWebpageObject *pageObject = [WXWebpageObject object];
    pageObject.webpageUrl = @"https://itunes.apple.com/cn/app/id1128178648?mt=8";
    
    message.mediaObject = pageObject;
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

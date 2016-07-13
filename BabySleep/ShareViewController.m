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
    
//    ShareView *weibo = [[ShareView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(weixin.frame) + 85 - 140, 334, 140, 140) Name:@"微博" Color:HexRGB(0xFAD4B2)];
//    weibo.tag = TABLEVIEW_BEGIN_TAG + 2;
//    weibo.delagate = self;
//    [self.view addSubview:weibo];
}

- (void)clickAction:(NSInteger)tag
{
    switch (tag) {
        case TABLEVIEW_BEGIN_TAG:
            
            break;
            
        default:
            break;
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

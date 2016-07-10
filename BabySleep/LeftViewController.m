//
//  LeftViewController.m
//  Dictation
//
//  Created by Michael on 16/1/4.
//  Copyright © 2016年 Michael. All rights reserved.
//

#import "LeftViewController.h"
//#import "LeadViewController.h"
#import "SliderViewController.h"

#import "NoiseViewController.h"
#import "ShareViewController.h"

#import "Utility.h"
#import "WMUserDefault.h"

#import "TFLargerHitButton.h"

#import <MessageUI/MessageUI.h>

@interface LeftViewController ()<MFMailComposeViewControllerDelegate>

@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = HexRGB(0x7AC6F6);
    
    CGFloat width = [[SliderViewController sharedSliderController] LeftSContentOffset];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(37, 27, 80, 25)];
    title.font = [UIFont systemFontOfSize:18];
    title.textColor = HexRGB(0xDBF7FF);
    title.text = @"宝贝快睡";
    [self.view addSubview:title];
    
    NSArray *imageArr = [NSArray arrayWithObjects:@"noise",@"share",@"advice", nil];
    NSArray *titleArr = [NSArray arrayWithObjects:@"白噪音",@"分享给好友",@"您的建议", nil];
    
    for (int i = 0; i < imageArr.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(39, 159 + i * 93, 15, 15)];
        NSString *imgStr = imageArr[i];
        imageView.image = [UIImage imageNamed:imgStr];
        [self.view addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 13, CGRectGetMinY(imageView.frame) - 8, 200, 28)];
        label.font = [UIFont systemFontOfSize:20];
        label.textColor = HexRGB(0xFFFFFF);
        label.text = titleArr[i];
        [self.view addSubview:label];
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(imageView.frame) + 47, 232, 1.5)];
        line.backgroundColor = HexRGB(0xB1CBFC);
        [self.view addSubview:line];
        
        UIButton *clickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        clickBtn.frame = CGRectMake(0, 113 + i * 93, 232, 90);
        clickBtn.tag = TABLEVIEW_BEGIN_TAG + i;
        [clickBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:clickBtn];
    }
    
    TFLargerHitButton *btn = [[TFLargerHitButton alloc] initWithFrame:CGRectMake(37, SCREENHEIGHT - 42, 56, 20)];
    [btn setTitle:@"其他应用" forState:UIControlStateNormal];
    [btn setTitleColor:HexRGB(0x1688D2) forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [btn addTarget:self action:@selector(goOtherAppDownload) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)btnAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    
    if (btn.tag == TABLEVIEW_BEGIN_TAG) {
        [self goNoiseView];
    }else if (btn.tag == TABLEVIEW_BEGIN_TAG + 1){
        [self goShareView];
    }else{
        [self sendMail];
    }
}

- (void)goNoiseView
{
    NoiseViewController *noiseVC = [[NoiseViewController alloc] initWithNibName:nil bundle:nil];
    [self presentViewController:noiseVC animated:YES completion:^{
        
    }];
}

- (void)goShareView
{
    ShareViewController *shareVC = [[ShareViewController alloc] initWithNibName:nil bundle:nil];
    [self presentViewController:shareVC animated:YES completion:^{
        
    }];
}

- (void)sendMail
{
    MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
    [mailComposer setToRecipients:[NSArray arrayWithObject:@"1259959450@qq.com"]];
    mailComposer.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    mailComposer.modalPresentationStyle = UIModalPresentationFormSheet;
    
    mailComposer.mailComposeDelegate = self; // Set the delegate
    
    [self presentViewController:mailComposer animated:YES completion:NULL];
}

- (void)goOtherAppDownload
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/le-yi-le-you-hui-quan/id1004844450?mt=8"]];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    NSString *msg;
    switch (result)
    {
        case MFMailComposeResultCancelled:
            msg = NSLocalizedString(@"Cancel the email", nil);
//            [self shareResult:msg];
            break;
        case MFMailComposeResultSaved:
            msg = NSLocalizedString(@"Save the email successfully", nil);
//            [self shareResult:msg];
            break;
        case MFMailComposeResultSent:
            msg = NSLocalizedString(@"Email has been sent", nil);
//            [self shareCountServe];
//            [self shareResult:msg];
            break;
        case MFMailComposeResultFailed:
            msg = NSLocalizedString(@"Failed to send email", nil);
//            [self shareResult:msg];
            break;
        default:
            break;
    }
    
    NSLog(@"%@",msg);
    
//    NSLog(@"%ld",(long)[ShareData defaultShareData].shareType);
//    NSLog(@"%ld",(long)[ShareData defaultShareData].shareObjectType);
    [self dismissViewControllerAnimated:YES completion:^(){
        
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

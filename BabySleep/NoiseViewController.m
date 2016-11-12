//
//  NoiseViewController.m
//  BabySleep
//
//  Created by medica_mac on 16/7/5.
//  Copyright © 2016年 Michael. All rights reserved.
//

#import "NoiseViewController.h"

#import "Utility.h"

#import "TFLargerHitButton.h"

@interface NoiseViewController ()

@end

@implementation NoiseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = HexRGB(0xDBF4FF);
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 70)];
    topView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
    [self.view addSubview:topView];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 29, SCREENWIDTH, 25)];
    title.textColor = HexRGB(0x1688D2);
    title.textAlignment = NSTextAlignmentCenter;
    title.text = NSLocalizedString(@"noise", nil);
    title.font = [UIFont fontWithName:@"DFPYuanW5" size:18];
    [self.view addSubview:title];
    
    TFLargerHitButton *backBtn = [[TFLargerHitButton alloc] initWithFrame:CGRectMake(22, 35, 14, 14)];
    [backBtn setImage:[UIImage imageNamed:@"cancel2"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:backBtn];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(22, 106, SCREENWIDTH - 22 * 2, SCREENHEIGHT - 106)];
    textView.editable = NO;
    textView.backgroundColor = [UIColor clearColor];
    textView.showsVerticalScrollIndicator = NO;
    textView.showsHorizontalScrollIndicator = NO;
    textView.textColor = HexRGB(0x5B7B90);
    textView.font = [UIFont fontWithName:@"DFPYuanW5" size:14];
    textView.text = NSLocalizedString(@"noisetip", nil);
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 14;// 字体的行间距
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName:textView.font,
                                 NSParagraphStyleAttributeName:paragraphStyle,
                                 NSForegroundColorAttributeName:textView.textColor
                                 };
    textView.attributedText = [[NSAttributedString alloc] initWithString:textView.text attributes:attributes];
    
    [self.view addSubview:textView];
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

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
    title.text = @"白噪音";
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
    textView.text = @"宝宝刚刚离开妈妈的子宫，来到一个陌生的环境，这对他们来说是一个需要适应的过程。而人世中的一些陌生声音会时常另他们感到不安、烦躁，他们更喜欢子宫里的嘈杂声。\n\n神奇的“白噪音”有令人惊叹的特性，它们听上去像下雨的声音，或者像海浪拍打岩石的声音，再或者像是风吹过树叶的沙沙声。这些声音与宝宝熟悉的子宫环境音有着类似之处。因此，在很多宝宝感到不安的时候，听到这种声音都会安静下来，安心入睡。这里精选数首白噪音为新生儿父母提供一个科学，高效的方法来引导小宝宝的睡眠，亦可作为安抚小宝宝情绪之辅助工具。";
    
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

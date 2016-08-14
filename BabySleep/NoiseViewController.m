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
    
    self.view.backgroundColor = HexRGB(0xffffff);
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 70)];
    topView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
    [self.view addSubview:topView];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 29, SCREENWIDTH, 25)];
    title.textColor = HexRGB(0xFF756F);
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"妈咪说故事";
    title.font = [UIFont fontWithName:@"DFPYuanW5" size:18];
    [self.view addSubview:title];
    
    TFLargerHitButton *backBtn = [[TFLargerHitButton alloc] initWithFrame:CGRectMake(22, 35, 14, 14)];
    [backBtn setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:backBtn];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(22, 106, SCREENWIDTH - 22 * 2, SCREENHEIGHT - 106)];
    textView.editable = NO;
    textView.backgroundColor = [UIColor clearColor];
    textView.showsVerticalScrollIndicator = NO;
    textView.showsHorizontalScrollIndicator = NO;
    textView.textColor = HexRGB(0x9E9E9E);
    textView.font = [UIFont fontWithName:@"DFPYuanW5" size:14];
    textView.text = @"心理学研究表明，幼儿对外在事物的认识是感性的。宝宝相信，树叶会说话，小草会唱歌，小动物和自己一样有时高兴，有时难过，有时困惑，有时惊奇。从这些有关小生灵的故事中，可以和宝宝的情感产生共鸣。宝宝是泛灵论的，他们同时生活在想像和现实的世界中。\n\n童话的故事，宝宝总是百听不厌。与成人不同，在宝宝的心中，每次都能在相同的故事中找到不同于以前的体验。乐此不疲听着同一个故事，对于宝宝来说，不是单调的反复，而是每次都有新发现！\n\n<妈咪说故事>可以录下故事，重复播放给宝宝听，帮助妈咪们在纷繁复杂的育儿过程中提高效率，时时刻刻与宝宝分享温馨的情感交流。";
    
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

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
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 27, SCREENWIDTH, 25)];
    title.textColor = HexRGB(0x1688D2);
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"白噪音";
    title.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:title];
    
    TFLargerHitButton *backBtn = [[TFLargerHitButton alloc] initWithFrame:CGRectMake(22, 33, 14, 14)];
    [backBtn setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:backBtn];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(22, 106, SCREENWIDTH - 22 * 2, SCREENHEIGHT - 106)];
    textView.editable = NO;
    textView.showsVerticalScrollIndicator = NO;
    textView.showsHorizontalScrollIndicator = NO;
    textView.textColor = HexRGB(0x5B7B90);
    textView.font = [UIFont systemFontOfSize:14];
    textView.text = @"魔术的“白噪音”有令人惊叹的特性，它们听上去像下雨的声音，或者像海浪拍打岩石的声音，再或者像是风吹过树叶的沙沙声。\n\n对于新生儿的父母来说，利用白噪音来停止婴儿的哭泣是一个很有效的声音治疗方法。宝宝刚刚离开妈妈的子宫，来到一个陌生的环境，这对他们来说是需要一个适应过程。而我们生活环境中一些陌生的声音对它们来说有时会另他们感到不安，以及烦躁。他们更喜欢子宫里的嘈杂声，而白噪音与他们熟悉的这种声音有着类似之处。因此，在很多宝宝感到不安的时候，听到这种声音都会安静下来。";
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

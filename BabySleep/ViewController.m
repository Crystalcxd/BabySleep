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

@interface ViewController ()

@property (nonatomic , strong) UIButton *playBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = HexRGB(0xDBF4FF);
    
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
    
    self.playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.playBtn.frame = CGRectMake(SCREENWIDTH * 0.5 - 39, SCREENHEIGHT - , <#CGFloat width#>, <#CGFloat height#>)
}

-(void)goMenuView
{
    [[SliderViewController sharedSliderController] leftItemClick];
}

-(void)share
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

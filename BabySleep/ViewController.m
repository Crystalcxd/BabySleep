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

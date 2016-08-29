//
//  RecordView.m
//  BabySleep
//
//  Created by Michael on 2016/8/29.
//  Copyright © 2016年 Michael. All rights reserved.
//

#import "RecordView.h"

#import "Utility.h"

@interface RecordView ()

@property (nonatomic , strong) UIView *circleBG;

@end

@implementation RecordView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.circleBG = [[UIView alloc] initWithFrame:CGRectMake(SCREENWIDTH * 0.5 - 26, SCREENHEIGHT - 52 - 26, 52, 52)];
        self.circleBG.backgroundColor = HexRGB(0xFFE7EF);
        self.circleBG.layer.cornerRadius = CGRectGetWidth(self.circleBG.frame) * 0.5;
        [self addSubview:self.circleBG];
    }
    
    return self;
}

- (void)showRecordView
{
    [UIView animateWithDuration:1.0 animations:^{
        self.circleBG.transform = CGAffineTransformScale(self.circleBG.transform, 30, 30);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)fadeRecordView
{
    [UIView animateWithDuration:1.0 animations:^{
        self.circleBG.transform = CGAffineTransformScale(self.circleBG.transform, 1 / 30.0, 1 / 30.0);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

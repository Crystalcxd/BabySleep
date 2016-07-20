//
//  ShareView.m
//  BabySleep
//
//  Created by medica_mac on 16/7/6.
//  Copyright © 2016年 Michael. All rights reserved.
//

#import "ShareView.h"

#import "Utility.h"

@implementation ShareView

- (instancetype)initWithFrame:(CGRect)frame Name:(NSString *)name Color:(UIColor *)color
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = CGRectGetWidth(frame) * 0.5;
        self.backgroundColor = color;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
        label.font = [UIFont fontWithName:@"DFPYuanW3" size:24];
        label.textColor = HexRGB(0x1688D2);
        label.textAlignment = NSTextAlignmentCenter;
        label.text = name;
        [self addSubview:label];
        
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click:)];
        [self addGestureRecognizer:recognizer];
    }
    
    return self;
}

- (void)click:(UITapGestureRecognizer *)recognizer
{
    if (self.delagate && [self.delagate respondsToSelector:@selector(clickAction:)]) {
        [self.delagate clickAction:self.tag];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

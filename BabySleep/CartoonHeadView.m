//
//  CartoonHeadView.m
//  Coupons
//
//  Created by Michael on 15/7/8.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import "CartoonHeadView.h"

#import "Utility.h"

@implementation CartoonHeadView

- (void)dealloc
{
    self.imageView = nil;
}

- (id)initWithFrame:(CGRect)frame withIdentifier:(NSString *)identfier
{
    self = [super initWithFrame:frame withIdentifier:identfier];
    if (self) {
        self.titleView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, SCREENWIDTH, 30.43)];
        [self addSubview:self.titleView];
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREENWIDTH * 0.5 - 142, CGRectGetHeight(frame) - 230, 284, 230)];
        [self addSubview:self.imageView];
    }
    return self;
}

- (void)setTitleImage:(NSString *)imageStr
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageStr]];
    
    self.titleView.image = [UIImage imageNamed:imageStr];
    
    CGRect frame = self.titleView.frame;
    
    frame.origin.x = (SCREENWIDTH - imageView.frame.size.width) *0.5;
    frame.size.width = imageView.frame.size.width;
    frame.size.height  = imageView.frame.size.height;
    
    self.titleView.frame = frame;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

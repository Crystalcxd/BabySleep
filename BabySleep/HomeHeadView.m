//
//  HomeHeadView.m
//  BabySleep
//
//  Created by Michael on 2016/12/17.
//  Copyright © 2016年 Michael. All rights reserved.
//

#import "HomeHeadView.h"

#import "Utility.h"

@implementation HomeHeadView

- (void)dealloc
{
    self.imageView = nil;
}

- (id)initWithFrame:(CGRect)frame withIdentifier:(NSString *)identfier
{
    self = [super initWithFrame:frame withIdentifier:identfier];
    if (self) {        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
        //        self.imageView.userInteractionEnabled = YES;
        [self addSubview:self.imageView];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

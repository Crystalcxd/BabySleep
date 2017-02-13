//
//  AppDelegate.h
//  BabySleep
//
//  Created by Michael on 16/6/26.
//  Copyright © 2016年 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WXApi.h"

#define WXAppId @"wxd1a58dbebec2a73a"
#define WXAppSecret @"5da65f2d9da635fc4b6dd2591d7de573"

@interface AppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate>

@property (strong, nonatomic) UIWindow *window;


@end


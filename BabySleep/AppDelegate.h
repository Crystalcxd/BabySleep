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

@interface AppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate>

@property (strong, nonatomic) UIWindow *window;


@end


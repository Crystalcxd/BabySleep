//
//  AppDelegate.h
//  BabySleep
//
//  Created by Michael on 16/6/26.
//  Copyright © 2016年 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WXApi.h"

#define WXAppId @"wxd8553922d3b91b66"
#define WXAppSecret @"fb631455c7c86e6307b9817b86e0df66"

@interface AppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate>

@property (strong, nonatomic) UIWindow *window;


@end


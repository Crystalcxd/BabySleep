//
//  AppDelegate.m
//  BabySleep
//
//  Created by Michael on 16/6/26.
//  Copyright © 2016年 Michael. All rights reserved.
//

#import "AppDelegate.h"

#import "SliderViewController.h"

#import "LeftViewController.h"

#import "WMUserDefault.h"

#import "MMPDeepSleepPreventer.h"

#import "MusicData.h"

@interface AppDelegate ()

@property (nonatomic, unsafe_unretained) UIBackgroundTaskIdentifier backgroundIdentifier;
@property (nonatomic)UIBackgroundTaskIdentifier taskID;

@end

@implementation AppDelegate

static void displayStatusChanged(CFNotificationCenterRef center,
                                void *observer,
                                CFStringRef name,
                                const void *object,
                                CFDictionaryRef userInfo) {
    if (name ==CFSTR("com.apple.springboard.lockcomplete")) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kDisplayStatusLocked"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    if (![WMUserDefault objectValueForKey:@"playtime"]) {
        [WMUserDefault setObjectValue:@"5" forKey:@"playtime"];
    }
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    displayStatusChanged,
                                    CFSTR("com.apple.springboard.lockcomplete"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorDeliverImmediately);
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    [SliderViewController sharedSliderController].mainVCClassName = @"ViewController";
    
    [SliderViewController sharedSliderController].LeftVC=[[LeftViewController alloc] init];
    [SliderViewController sharedSliderController].RightVC=[[UIViewController alloc] init];
    
    UINavigationController *controller = [[UINavigationController alloc] initWithRootViewController:[SliderViewController sharedSliderController]];
    
    self.window.rootViewController = controller;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    [WXApi registerApp:WXAppId];

    //增强后台运行
    MMPDeepSleepPreventer *niceSleep = [MMPDeepSleepPreventer sharedSingleton];
    [niceSleep startPreventSleep];

    
    if (![WMUserDefault arrayForKey:@"DefaultData"]) {
        NSMutableArray *array = [NSMutableArray array];
        
        MusicData *musicData = [[MusicData alloc] init];
        musicData.musicName = @"故事1";
        musicData.indexName = @"1";
        musicData.imageName = @"home_m4a_1.png";
        musicData.volum = 0.5;
        
        [array addObject:musicData];
        
        MusicData *musicDataTwo = [[MusicData alloc] init];
        musicDataTwo.musicName = @"故事2";
        musicDataTwo.indexName = @"2";
        musicDataTwo.imageName = @"home_m4a_2.png";
        musicDataTwo.volum = 0.5;

        [array addObject:musicDataTwo];
        
        MusicData *musicDataThree = [[MusicData alloc] init];
        musicDataThree.musicName = @"故事3";
        musicDataThree.indexName = @"3";
        musicDataThree.imageName = @"home_m4a_3.png";
        musicDataThree.volum = 0.5;

        [array addObject:musicDataThree];

        [WMUserDefault setArray:array forKey:@"DefaultData"];
    }

    //调用方法
    if (![self isFileExistWith:@"record_save_head.png"]) {
        UIImage *savedImage = [UIImage imageNamed:@"record_save_head.png"];
        NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        NSString *filePath = [[paths objectAtIndex:0]stringByAppendingPathComponent:[NSString stringWithFormat:@"record_save_head.png"]];  // 保存文件的名称
        BOOL result =[UIImagePNGRepresentation(savedImage) writeToFile:filePath atomically:YES]; // 保存成功会返回YES
        
        NSString *msg = nil ;
        if(result){
            msg = @"保存图片成功" ;
        }else{
            msg = @"保存图片失败" ;
        }
        
        NSLog(@"%@",msg);
    }

    return YES;
}

- (BOOL)isFileExistWith:(NSString *)str
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //Get documents directory
    NSArray *directoryPaths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [directoryPaths objectAtIndex:0];
    if ([fileManager fileExistsAtPath:[NSString stringWithFormat:@"%@/%@",documentsDirectoryPath,str]]==YES) {
        NSLog(@"File exists");
        return YES;
    }
    
    return NO;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if([[url absoluteString] rangeOfString:WXAppId].location != NSNotFound){
        return [WXApi handleOpenURL:url delegate:self];
    }
    else{
        return YES;
    }
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    //#if __QQAPI_ENABLE__
    //    [QQApiInterface handleOpenURL:url delegate:(id)[QQAPIDemoEntry class]];
    //#endif
    if([[url absoluteString] rangeOfString:WXAppId].location != NSNotFound){
        return [WXApi handleOpenURL:url delegate:self];
    }
    else{
        return YES;
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents]; // 让后台可以处理多媒体的事件
    [[MMPDeepSleepPreventer sharedSingleton] mmp_playPreventSleepSound];
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
//    self.isInBackground = YES;
    UIApplication *app = [UIApplication sharedApplication];
    self.taskID = [app beginBackgroundTaskWithExpirationHandler:^{ //如果系统觉得我们运行时间太长，将执行这个程序块，并停止运行应用程序
        
        [app endBackgroundTask:self.taskID];
    }];
    
    if (self.taskID == UIBackgroundTaskInvalid) {//UIBackgroundTaskInvalid表示系统没有为我们提供额外的时间
        
        return;
    }

    UIApplicationState state = [[UIApplication sharedApplication] applicationState];
    if (state ==UIApplicationStateInactive) {
        NSLog(@"按了锁屏键");
    }
    else if (state == UIApplicationStateBackground) {
        if (![[NSUserDefaults standardUserDefaults] boolForKey:@"kDisplayStatusLocked"]) {
            NSLog(@"按了home键，或者跳转到另一个app");
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"pauseMusic" object:nil];
        }
        else {
            NSLog(@"按了锁屏键");
        }
    }
//    [self performSelector:@selector(checkBright) withObject:nil afterDelay:3.0];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kDisplayStatusLocked"];
    [[NSUserDefaults standardUserDefaults] synchronize];    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - 微信分享
-(void)onReq:(BaseReq*)req
{
    if([req isKindOfClass:[GetMessageFromWXReq class]])
    {
        // 微信请求App提供内容， 需要app提供内容后使用sendRsp返回
        NSString *strTitle = [NSString stringWithFormat:@"微信请求App提供内容"];
        NSString *strMsg = @"微信请求App提供内容，App要调用sendResp:GetMessageFromWXResp返回给微信";
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag = 1000;
        [alert show];
    }
    else if([req isKindOfClass:[ShowMessageFromWXReq class]])
    {
        ShowMessageFromWXReq* temp = (ShowMessageFromWXReq*)req;
        WXMediaMessage *msg = temp.message;
        
        //显示微信传过来的内容
        WXAppExtendObject *obj = msg.mediaObject;
        
        NSString *strTitle = [NSString stringWithFormat:@"微信请求App显示内容"];
        NSString *strMsg = [NSString stringWithFormat:@"标题：%@ \n内容：%@ \n附带信息：%@ \n缩略图:%lu bytes\n\n", msg.title, msg.description, obj.extInfo, (unsigned long)msg.thumbData.length];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if([req isKindOfClass:[LaunchFromWXReq class]])
    {
        //从微信启动App
        NSString *strTitle = [NSString stringWithFormat:@"从微信启动"];
        NSString *strMsg = @"这是从微信启动的消息";
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(void)onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        NSString *strMsg = resp.errCode == 0 ? @"分享成功" : @"分享取消";
        [self alertWithTitle:@"" msg:strMsg];
        
        if (resp.errCode == 0) {
            [WMUserDefault setObjectValue:@"60" forKey:@"playtime"];
        }
    }
}

- (void) alertWithTitle:(NSString *)title msg:(NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                          otherButtonTitles:nil];
    [alert show];
}

//实现该方法
- (void)saveImageToPhotos:(UIImage*)savedImage
{
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    //因为需要知道该操作的完成情况，即保存成功与否，所以此处需要一个回调方法image:didFinishSavingWithError:contextInfo:
}

//回调方法
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存图片失败" ;
    }else{
        msg = @"保存图片成功" ;
    }
    
    NSLog(@"%@",msg);
}



@end

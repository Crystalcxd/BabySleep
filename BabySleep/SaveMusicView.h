//
//  SaveMusicView.h
//  BabySleep
//
//  Created by Michael on 2016/9/1.
//  Copyright © 2016年 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MusicData.h"

@interface SaveMusicView : UIView

@property (nonatomic , assign) UIViewController *fatherVC;

@property (nonatomic , strong) MusicData *musicData;

@end

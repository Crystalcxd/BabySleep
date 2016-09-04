//
//  SaveMusicView.h
//  BabySleep
//
//  Created by Michael on 2016/9/1.
//  Copyright © 2016年 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MusicData.h"

typedef void(^endSaveMusic)();

@interface SaveMusicView : UIView

@property (nonatomic , assign) UIViewController *fatherVC;

@property (nonatomic , strong) MusicData *musicData;

@property (nonatomic , copy) endSaveMusic EndSaveMusic;

- (void)configureWith:(MusicData *)data;

@end

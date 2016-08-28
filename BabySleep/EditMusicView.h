//
//  EditMusicView.h
//  BabySleep
//
//  Created by Michael on 2016/8/28.
//  Copyright © 2016年 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    EditMusicViewTypeNormal = 0,
    EditMusicViewTypeEdit,
} EditMusicViewType;

@interface EditMusicView : UIView

- (void)configureWithType:(EditMusicViewType)type;

@end

//
//  EditMusicView.h
//  BabySleep
//
//  Created by Michael on 2016/8/28.
//  Copyright © 2016年 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^startEdit)();
typedef void(^endEdit)();

typedef enum : NSUInteger {
    EditMusicViewTypeNormal = 0,
    EditMusicViewTypeEdit,
} EditMusicViewType;

@interface EditMusicView : UIView

@property (nonatomic , copy) startEdit StartEdit;
@property (nonatomic , copy) endEdit EndEdit;

- (void)configureWithType:(EditMusicViewType)type;

@end

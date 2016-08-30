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
typedef void(^clearMusicData)();
typedef void(^deleteMusicData)();

typedef enum : NSUInteger {
    EditMusicViewTypeNormal = 0,
    EditMusicViewTypeEdit,
} EditMusicViewType;

@interface EditMusicView : UIView

@property (nonatomic , copy) startEdit StartEdit;
@property (nonatomic , copy) endEdit EndEdit;
@property (nonatomic , copy) clearMusicData ClearMusicData;
@property (nonatomic , copy) deleteMusicData DeleteMusicData;

- (void)configureWithType:(EditMusicViewType)type;

@end

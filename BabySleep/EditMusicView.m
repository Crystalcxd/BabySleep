//
//  EditMusicView.m
//  BabySleep
//
//  Created by Michael on 2016/8/28.
//  Copyright © 2016年 Michael. All rights reserved.
//

#import "EditMusicView.h"
#import "AudioTask.h"
#import "Utility.h"

@interface EditMusicView ()

@property (nonatomic , strong) UIView *contentView;

@end

@implementation EditMusicView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HexRGB(0xFFE7EF);
        
        UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 1)];
        topLine.backgroundColor = HexRGB(0xFF756F);
        [self addSubview:topLine];
        
        self.contentView = [[UIView alloc] initWithFrame:self.bounds];
        [self addSubview:self.contentView];
        
        [self configureWithType:EditMusicViewTypeNormal];
    }
    
    return self;
}

- (void)configureWithType:(EditMusicViewType)type
{
    typeof(self)weakSelf = self;
    
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.contentView.alpha = 0;
    } completion:^(BOOL finished) {
        for (UIView *view in weakSelf.contentView.subviews) {
            [view removeFromSuperview];
        }
        if (type == EditMusicViewTypeNormal) {
            UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            editBtn.frame = CGRectMake(0, 0, SCREENWIDTH / 3.0, CGRectGetHeight(weakSelf.frame));
            [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
            [editBtn setTitleColor:HexRGB(0xFF564F) forState:UIControlStateNormal];
            [editBtn setTitleColor:HexRGB(0xCDA09E) forState:UIControlStateHighlighted];
            [editBtn.titleLabel setFont:[UIFont fontWithName:@"DFPYuanW5" size:17]];
            [editBtn addTarget:weakSelf action:@selector(editBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [weakSelf.contentView addSubview:editBtn];
            
            UIButton *loopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            loopBtn.frame = CGRectMake(SCREENWIDTH / 3.0 * 2, 0, SCREENWIDTH / 3.0, CGRectGetHeight(weakSelf.frame));
            loopBtn.tag = TABLEVIEW_BEGIN_TAG * 10;
            [weakSelf.contentView addSubview:loopBtn];
            [loopBtn addTarget:weakSelf action:@selector(loopStatusAction:) forControlEvents:UIControlEventTouchUpInside];
            [weakSelf updateLoopStatusBtn];
        }else{
            UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            cancelBtn.frame = CGRectMake(0, 0, SCREENWIDTH / 3.0, CGRectGetHeight(weakSelf.frame));
            [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
            [cancelBtn setTitleColor:HexRGB(0xFF564F) forState:UIControlStateNormal];
            [cancelBtn setTitleColor:HexRGB(0xCDA09E) forState:UIControlStateHighlighted];
            [cancelBtn.titleLabel setFont:[UIFont fontWithName:@"DFPYuanW5" size:17]];
            [cancelBtn addTarget:weakSelf action:@selector(cancelBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [weakSelf.contentView addSubview:cancelBtn];
            
            UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            clearBtn.frame = CGRectMake(SCREENWIDTH / 3.0, 0, SCREENWIDTH / 3.0, CGRectGetHeight(weakSelf.frame));
            [clearBtn setTitle:@"清空" forState:UIControlStateNormal];
            [clearBtn setTitleColor:HexRGB(0xFF564F) forState:UIControlStateNormal];
            [clearBtn setTitleColor:HexRGB(0xcca09f) forState:UIControlStateHighlighted];
            [clearBtn.titleLabel setFont:[UIFont fontWithName:@"DFPYuanW5" size:17]];
            [clearBtn addTarget:weakSelf action:@selector(clearBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [weakSelf.contentView addSubview:clearBtn];
            
            UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            deleteBtn.frame = CGRectMake(SCREENWIDTH / 3.0 * 2, 0, SCREENWIDTH / 3.0, CGRectGetHeight(weakSelf.frame));
            [deleteBtn setImage:[UIImage imageNamed:@"edit_garbage"] forState:UIControlStateNormal];
            [deleteBtn setImage:[UIImage imageNamed:@"edit_garbage_down"] forState:UIControlStateHighlighted];
            [deleteBtn addTarget:weakSelf action:@selector(deleteBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [weakSelf.contentView addSubview:deleteBtn];
        }
        
        [UIView animateWithDuration:0.5 animations:^{
            weakSelf.contentView.alpha = 1.0;
        } completion:^(BOOL finished) {
            
        }];
    }];
}

- (void)editBtnAction:(id)sender
{
    [self configureWithType:EditMusicViewTypeEdit];
    
    self.StartEdit();
}

- (void)loopStatusAction:(id)sender
{
    BOOL isPlayCircle = [[AudioTask shareAudioTask] isPlayCircle];
    [[AudioTask shareAudioTask] setIsPlayCircle:!isPlayCircle];
    
    [self updateLoopStatusBtn];
}

- (void)updateLoopStatusBtn
{
    for (UIButton *btn in self.contentView.subviews) {
        if (btn.tag == TABLEVIEW_BEGIN_TAG * 10) {
            if (![[AudioTask shareAudioTask] isPlayCircle]) {
                [btn setImage:[UIImage imageNamed:@"home_loop_down"] forState:UIControlStateNormal];
            }else{
                [btn setImage:[UIImage imageNamed:@"home_loop"] forState:UIControlStateNormal];
            }
        }
    }
}

- (void)cancelBtnAction:(id)sender
{
    [self configureWithType:EditMusicViewTypeNormal];
    
    self.EndEdit();
}

- (void)clearBtnAction:(id)sender
{
    self.ClearMusicData();
}

- (void)deleteBtnAction:(id)sender
{
    self.DeleteMusicData();
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

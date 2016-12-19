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
    for (UIView *view in self.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    if (type == EditMusicViewTypeNormal) {
        UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        editBtn.frame = CGRectMake(0, 0, SCREENWIDTH * 0.5, CGRectGetHeight(self.frame));
        [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [editBtn setTitleColor:HexRGB(0xFF564F) forState:UIControlStateNormal];
        [editBtn setTitleColor:HexRGB(0xCDA09E) forState:UIControlStateHighlighted];
        [editBtn.titleLabel setFont:[UIFont fontWithName:@"DFPYuanW5" size:17]];
        [editBtn addTarget:self action:@selector(editBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:editBtn];
        
        UIButton *loopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        loopBtn.frame = CGRectMake(SCREENWIDTH * 0.5, 0, SCREENWIDTH * 0.5, CGRectGetHeight(self.frame));
        [loopBtn setImage:[UIImage imageNamed:@"home_loop"] forState:UIControlStateNormal];
        [loopBtn setImage:[UIImage imageNamed:@"home_loop_down"] forState:UIControlStateHighlighted];
        [self.contentView addSubview:loopBtn];
    }else{
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame = CGRectMake(0, 0, SCREENWIDTH / 3.0, CGRectGetHeight(self.frame));
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:HexRGB(0xFF564F) forState:UIControlStateNormal];
        [cancelBtn setTitleColor:HexRGB(0xCDA09E) forState:UIControlStateHighlighted];
        [cancelBtn.titleLabel setFont:[UIFont fontWithName:@"DFPYuanW5" size:17]];
        [cancelBtn addTarget:self action:@selector(cancelBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:cancelBtn];
        
        UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        clearBtn.frame = CGRectMake(SCREENWIDTH / 3.0, 0, SCREENWIDTH / 3.0, CGRectGetHeight(self.frame));
        [clearBtn setTitle:@"清空" forState:UIControlStateNormal];
        [clearBtn setTitleColor:HexRGB(0xFF564F) forState:UIControlStateNormal];
        [clearBtn setTitleColor:HexRGB(0xcca09f) forState:UIControlStateHighlighted];
        [clearBtn.titleLabel setFont:[UIFont fontWithName:@"DFPYuanW5" size:17]];
        [clearBtn addTarget:self action:@selector(clearBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:clearBtn];

        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteBtn.frame = CGRectMake(SCREENWIDTH / 3.0 * 2, 0, SCREENWIDTH / 3.0, CGRectGetHeight(self.frame));
        [deleteBtn setImage:[UIImage imageNamed:@"edit_garbage"] forState:UIControlStateNormal];
        [deleteBtn setImage:[UIImage imageNamed:@"edit_garbage_down"] forState:UIControlStateHighlighted];
        [deleteBtn addTarget:self action:@selector(deleteBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:deleteBtn];
    }
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

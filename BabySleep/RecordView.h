//
//  RecordView.h
//  BabySleep
//
//  Created by Michael on 2016/8/29.
//  Copyright © 2016年 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordView : UIView

@property (nonatomic , assign) UIViewController *fatherVC;

- (void)showRecordView;

- (void)fadeRecordView;

- (void)pauseRecord;

@end

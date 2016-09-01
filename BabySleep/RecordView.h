//
//  RecordView.h
//  BabySleep
//
//  Created by Michael on 2016/8/29.
//  Copyright © 2016年 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ViewController.h"

@interface RecordView : UIView

@property (nonatomic , assign) ViewController *fatherVC;

- (void)showRecordView;

- (void)fadeRecordView;

- (void)pauseRecord;

@end

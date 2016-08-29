//
//  RecordListCell.h
//  BabySleep
//
//  Created by Michael on 2016/8/29.
//  Copyright © 2016年 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^volumValueChange)(CGFloat);

@interface RecordListCell : UITableViewCell

@property (nonatomic , copy) volumValueChange VolumValueChange;

@end

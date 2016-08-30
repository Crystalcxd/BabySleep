//
//  RecordListCell.h
//  BabySleep
//
//  Created by Michael on 2016/8/29.
//  Copyright © 2016年 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MusicData.h"

typedef void(^volumValueChange)(CGFloat);

@interface RecordListCell : UITableViewCell

@property (nonatomic , strong) NSIndexPath *indexPath;

@property (nonatomic , copy) volumValueChange VolumValueChange;

- (void)configureWithMusic:(MusicData *)music volum:(NSString *)volum selected:(BOOL)selected editMode:(BOOL)editMode;

- (void)deleteSelect:(BOOL)select;

@end

//
//  NoticeCell.h
//  BaojiWeather
//
//  Created by Tcy on 2017/6/2.
//  Copyright © 2017年 Tcy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeModel.h"

@interface NoticeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *pushPerLab;
@property (weak, nonatomic) IBOutlet UILabel *timeAndAount;
@property (weak, nonatomic) IBOutlet UIImageView *readSignal;
@property (weak, nonatomic) IBOutlet UIImageView *outSignal;
@property (weak, nonatomic) IBOutlet UIView *bgView;
- (void)setDataWith:(NoticeModel *)model;
@end

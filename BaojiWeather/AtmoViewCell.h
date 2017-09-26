//
//  AtmoViewCell.h
//  BaojiWeather
//
//  Created by Tcy on 2017/6/7.
//  Copyright © 2017年 Tcy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AtmoModel.h"

@interface AtmoViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *titLab;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
- (void)setData:(AtmoModel *)model;
@end

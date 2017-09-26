//
//  ParkRealCell.m
//  BaojiWeather
//
//  Created by Tcy on 2017/6/9.
//  Copyright © 2017年 Tcy. All rights reserved.
//

#import "ParkRealCell.h"

@implementation ParkRealCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)sIconImage:(NSString *)imageName{
    
    [_iconImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"Im%@",imageName]]];
 }
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

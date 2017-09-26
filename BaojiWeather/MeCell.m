//
//  MeCell.m
//  BaojiWeather
//
//  Created by Tcy on 2017/6/16.
//  Copyright © 2017年 Tcy. All rights reserved.
//

#import "MeCell.h"

@implementation MeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _iconImage.layer.masksToBounds=YES;
    _iconImage.layer.cornerRadius=4;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end

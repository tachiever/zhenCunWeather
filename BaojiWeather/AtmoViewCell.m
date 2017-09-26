//
//  AtmoViewCell.m
//  BaojiWeather
//
//  Created by Tcy on 2017/6/7.
//  Copyright © 2017年 Tcy. All rights reserved.
//

#import "AtmoViewCell.h"

@implementation AtmoViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setData:(AtmoModel *)model{

    self.titLab.text=model.title;
    self.dateLab.text=model.up_time;
    [self.iconImage setImage:[UIImage imageNamed:[self imageName:model.type]]];

}

- (NSString *)imageName:(NSString *)str{
    if ([str isEqualToString:@"决策"]) {
        return @"jc";
        
    }    if ([str isEqualToString:@"农业气象"]) {
        return @"nyqx";
        
    }    if ([str isEqualToString:@"旅游"]) {
        return @"ly";
        
    }    if ([str isEqualToString:@"环境"]) {
        return @"hj";
        
    }    if ([str isEqualToString:@"森林防火"]) {
        return @"slfh";
        
    }if ([str isEqualToString:@"气象词典"]) {
        return @"qxcd";
        
    }if ([str isEqualToString:@"气象百科"]) {
        return @"qxbk";
        
    }if ([str isEqualToString:@"灾害防御"]) {
        return @"zhfy";
        
    }else{
    
        return @"nt";

    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

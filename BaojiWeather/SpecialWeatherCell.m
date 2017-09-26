//
//  SpecialWeatherCell.m
//  BaojiWeather
//
//  Created by Tcy on 2017/6/13.
//  Copyright © 2017年 Tcy. All rights reserved.
//

#import "SpecialWeatherCell.h"

@implementation SpecialWeatherCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setDataWithDic:(NSDictionary *)dic{
    
    _titLba.text=dic[@"title"];
    _dateLab.text=dic[@"time"];
    _detailText.text=dic[@"detailed"];
    NSString *st=[NSString stringWithFormat:@"http://61.150.127.155:8081/bjserver/%@", dic[@"imgPath"]];
   // NSLog(@"-s-s-s-%@",st);
    [_iconImage sd_setImageWithURL:[NSURL URLWithString:st] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    


}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

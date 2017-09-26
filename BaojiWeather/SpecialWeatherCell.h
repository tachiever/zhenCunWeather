//
//  SpecialWeatherCell.h
//  BaojiWeather
//
//  Created by Tcy on 2017/6/13.
//  Copyright © 2017年 Tcy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpecialWeatherCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titLba;
@property (weak, nonatomic) IBOutlet UITextView *detailText;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
- (void)setDataWithDic:(NSDictionary *)dic;
@end

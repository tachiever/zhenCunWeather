//
//  DayWeatherView.h
//  BaojiWeather
//
//  Created by Tcy on 2017/6/5.
//  Copyright © 2017年 Tcy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DayWeatherView : UIView

@property (nonatomic)UILabel *dateLab;
@property (nonatomic)UILabel *temLab;
@property (nonatomic)UILabel *weaLab;
@property (nonatomic)UIImageView *weathIcon;

- (void)setImage:(NSString *)image date:(NSString *)date tem:(NSString *)temp  wea:(NSString *)wea;
- (void)updateWithDic:(NSDictionary *)dic;
@end

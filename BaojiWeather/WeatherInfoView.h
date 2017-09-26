//
//  WeatherInfoView.h
//  BaojiWeather
//
//  Created by Tcy on 2017/5/31.
//  Copyright © 2017年 Tcy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherInfoView : UIView

- (void)updateHighWithFrame:(CGFloat)hig;
- (void)downloadDataWithDic:(NSDictionary *)dic;
@property (copy,nonatomic) void (^actionYujingDetail)();
@property (copy,nonatomic) void (^actionMoreCity)();
@property (copy,nonatomic) void (^actionPage)(NSInteger num);
@property (copy,nonatomic) void (^actionSharePage)(NSInteger num,NSString *shareStr);

@end

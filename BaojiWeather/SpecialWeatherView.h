//
//  SpecialWeatherView.h
//  BaojiWeather
//
//  Created by Tcy on 2017/6/13.
//  Copyright © 2017年 Tcy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpecialWeatherView : UIView
- (void)updateHighWithFrame;
- (void)downloadDataWith:(NSDictionary *)dic;
@property (copy,nonatomic) void (^actionUploadeNotice)();

@end

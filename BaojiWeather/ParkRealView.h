//
//  ParkRealView.h
//  BaojiWeather
//
//  Created by Tcy on 2017/6/8.
//  Copyright © 2017年 Tcy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ParkRealView : UIView
- (void)updateHighWithFrame;
- (void)downloadDataWith:(NSDictionary *)dic;
@end

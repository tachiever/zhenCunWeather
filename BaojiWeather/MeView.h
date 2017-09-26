//
//  MeView.h
//  BaojiWeather
//
//  Created by Tcy on 2017/6/16.
//  Copyright © 2017年 Tcy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeView : UIView
- (void)updateHighWithFrame;
- (void)setInfor:(NSDictionary *)dic;
@property (copy,nonatomic) void (^actionShowMessPage)();
@end

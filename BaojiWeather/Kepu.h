//
//  Kepu.h
//  BaojiWeather
//
//  Created by Tcy on 2017/6/8.
//  Copyright © 2017年 Tcy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Kepu : UIView
- (void)updateHighWithFrame;
- (void)downloadDataWith:(NSDictionary *)dic;
@property (copy,nonatomic) void (^actionDataDetail)(NSString *detId);

@end

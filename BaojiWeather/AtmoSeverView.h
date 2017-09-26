//
//  AtmoSeverView.h
//  BaojiWeather
//
//  Created by Tcy on 2017/6/6.
//  Copyright © 2017年 Tcy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AtmoSeverView : UIView
- (void)updateHighWithFrame;
- (void)downloadDataWith:(NSDictionary *)dic;
@property (copy,nonatomic) void (^actionDataDetail)(NSString *detId);

@end

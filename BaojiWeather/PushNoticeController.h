//
//  PushNoticeController.h
//  BaojiWeather
//
//  Created by Tcy on 2017/6/2.
//  Copyright © 2017年 Tcy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PushNoticeController : UIViewController
@property (nonatomic) NSDictionary *dic;
@property (copy,nonatomic) void (^actionPushSuccess)();

@end

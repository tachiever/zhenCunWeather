//
//  NoticeView.h
//  BaojiWeather
//
//  Created by Tcy on 2017/6/1.
//  Copyright © 2017年 Tcy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoticeView : UIView
- (void)updateHighWithFrame;
- (void)downloadDataWith:(NSDictionary *)dic;
- (void)refreshData;
@property (copy,nonatomic) void (^actionShowDetail)(NSString *notId);
@property (copy,nonatomic) void (^actionPushNotice)();

@end

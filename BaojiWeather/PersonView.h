//
//  PersonView.h
//  BaojiWeather
//
//  Created by Tcy on 2017/6/15.
//  Copyright © 2017年 Tcy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonView : UIView
- (void)updateHighWithFrame;
- (void)downlaodData;
@property (copy,nonatomic) void (^actionMakeCell)(NSString *phoneNum);
@property (copy,nonatomic) void (^actionSendMess)(NSString *phoneNum);

@end

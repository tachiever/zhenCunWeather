//
//  SincePointView.h
//  BaojiWeather
//
//  Created by Tcy on 2017/6/9.
//  Copyright © 2017年 Tcy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SincePointView : UIView
- (void)updateHighWithFrame;
- (void)downloadDataWith:(NSDictionary *)dic;
@end

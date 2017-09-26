//
//  EcomicView.h
//  BaojiWeather
//
//  Created by Tcy on 2017/6/12.
//  Copyright © 2017年 Tcy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EcomicView : UIView
- (void)updateHighWithFrame;
@property (copy,nonatomic) void (^actionNewsDetail)(NSInteger newsKind);

@end

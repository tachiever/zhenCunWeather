//
//  MainPageView.h
//  BaojiWeather
//
//  Created by Tcy on 2017/2/21.
//  Copyright © 2017年 Tcy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IconAndLabView.h"

@interface MainPageView : UIView
@property(nonatomic)IconAndLabView *rainLab;
@property(nonatomic)IconAndLabView *humLab;
@property(nonatomic)IconAndLabView *windLab;
@property(nonatomic)UILabel *weatherLab;
@property(nonatomic)UILabel *temLab;
@property(nonatomic)UILabel *posiLab;
@property(nonatomic)UILabel *timeLab;
@property(nonatomic)UIButton *bkBtn;
- (void)updateViewdata:(NSDictionary *)dic;

@property (copy,nonatomic) void (^actionRead)();
@property (copy,nonatomic) void (^actionShowPage)(NSInteger num);

@end

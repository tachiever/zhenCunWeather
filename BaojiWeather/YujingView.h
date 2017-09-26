//
//  YujingView.h
//  BaojiWeather
//
//  Created by Tcy on 2017/6/6.
//  Copyright © 2017年 Tcy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMJScrollTextView.h"



@interface YujingView : UIView
@property (nonatomic ) UILabel *titLab;
@property (nonatomic ) LMJScrollTextView *detailLab;

- (void)updateView:(NSString *)tit st:(NSString *)dit;
@property (copy,nonatomic) void (^actionReadMind)();
@property (copy,nonatomic) void (^actionShowMindDetail)();

@end

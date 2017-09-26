
//
//  YujingView.m
//  BaojiWeather
//
//  Created by Tcy on 2017/6/6.
//  Copyright © 2017年 Tcy. All rights reserved.
//

#import "YujingView.h"

@implementation YujingView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 初始化设置
        [self setup];
    }
    return self;
}

- (void)setup {
    UIButton *surBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    surBtn.frame=CGRectMake(10,10,50*Rat,50*Rat);
    [surBtn setBackgroundImage:[UIImage imageNamed:@"load"] forState:UIControlStateNormal];
    [surBtn addTarget:self action:@selector(readText) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:surBtn];
    
    _titLab=[[UILabel alloc]initWithFrame:CGRectMake(50*Rat+15, 8+10*Rat,55,30)];
    _titLab.font=[UIFont fontWithName:@"ArialMT" size:18];
    _titLab.textAlignment=NSTextAlignmentCenter;
    _titLab.text=@"";
    _titLab.textColor=[UIColor whiteColor];
    [self addSubview:_titLab];
    
    _detailLab=[[LMJScrollTextView alloc] initWithFrame:CGRectMake(50*Rat+75, 8+10*Rat, self.frame.size.width-37-50*Rat-70, 30) textScrollModel:LMJTextScrollContinuous direction:LMJTextScrollMoveLeft];
    _detailLab.backgroundColor = [UIColor clearColor];
    [_detailLab startScrollWithText:@"" textColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:16]];
    [self addSubview:_detailLab];
    
    UIButton * detBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    detBtn.frame=CGRectMake(self.frame.size.width-37, 8+12*Rat, 27, 27);
    [detBtn setImage:[UIImage imageNamed:@"Imageleft_rod"] forState:UIControlStateNormal];
    [detBtn addTarget:self action:@selector(tapGesturer) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:detBtn];
}
- (void)readText{
    if (self.actionReadMind) {
        self.actionReadMind();
    }

}

- (void)tapGesturer{
    if (self.actionShowMindDetail) {
        self.actionShowMindDetail();
    }
}

- (void)updateView:(NSString *)tit st:(NSString *)dit{
    _titLab.text=tit;
    [_detailLab updateText:dit];
    
}
@end

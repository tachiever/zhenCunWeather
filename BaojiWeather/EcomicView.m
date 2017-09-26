//
//  EcomicView.m
//  BaojiWeather
//
//  Created by Tcy on 2017/6/12.
//  Copyright © 2017年 Tcy. All rights reserved.
//

#import "EcomicView.h"
@interface EcomicView ()<UIScrollViewDelegate>{
    UIScrollView *scroller;

}


@end
@implementation EcomicView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self createUI];
    }
    return self;
}

- (void)createUI{
    CGFloat h1=SCREEN_HEIGHT<500 ?500:(SCREEN_HEIGHT<700 ?500:SCREEN_HEIGHT-100);
    scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.frame.size.height)];
    scroller.directionalLockEnabled = YES; //只能一个方向滑动
    scroller.pagingEnabled = NO; //是否翻页
    scroller.backgroundColor = [UIColor whiteColor];
    scroller.showsVerticalScrollIndicator =NO; //垂直方向的滚动指示
    scroller.showsHorizontalScrollIndicator =NO; //垂直方向的滚动指示
    scroller.bounces = YES;
    scroller.delegate = self;
    scroller.contentSize = CGSizeMake(0,h1);
    scroller.contentOffset=CGPointMake(0,0);
    [self addSubview:scroller];
    
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, -2, SCREEN_WIDTH, SCREEN_WIDTH*0.5)];
    [imageView setImage:[UIImage imageNamed:@"headerBg"]];
    [scroller addSubview:imageView];
    UILabel *view=[[UILabel alloc]initWithFrame:CGRectMake(0, SCREEN_WIDTH*0.5-30, SCREEN_WIDTH, 30)];
    view.backgroundColor=RGBACOLOR(45, 45, 45, 0.5);
    view.textColor=[UIColor whiteColor];
    view.text=@"汇聚三农";
    view.font=[UIFont systemFontOfSize:16];
    view.textAlignment=NSTextAlignmentCenter;
    [imageView addSubview:view];
    
    
    for (int i=0; i<6; i++) {
        NSArray *arr=@[@"宝鸡市农产品产业信息",@"宝鸡畜牧业",@"宝鸡市环境保护",@"宝鸡市农业电商发展",@"网红经济的商业模式",@"宝鸡市经济呈现的六大亮点"];
        UIButton * searchBtn=[[UIButton alloc]initWithFrame:CGRectMake(10,SCREEN_WIDTH*0.5+20+((self.frame.size.width-20)/7+8)*i,self.frame.size.width-20,(self.frame.size.width-20)/7)];
        searchBtn.tag=i+11;
        [searchBtn setTitleColor:RGBACOLOR(4, 4, 4, 1) forState:UIControlStateNormal];
        [searchBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        searchBtn.titleLabel.font=[UIFont systemFontOfSize:16];
        [searchBtn setTitle:arr[i] forState:UIControlStateNormal];
        [searchBtn setBackgroundColor:RGBCOLOR(193, 218, 249)];
        [searchBtn addTarget:self action:@selector(upLoadNotice:) forControlEvents:UIControlEventTouchUpInside];
        [scroller addSubview:searchBtn];
    }
}

- (void)upLoadNotice:(UIButton *)btn{
    if (_actionNewsDetail) {
        _actionNewsDetail(btn.tag);
    }

}

- (void)updateHighWithFrame{
    CGRect frame0=CGRectMake(0, 0, SCREEN_WIDTH, self.frame.size.height);
    
    [UIView animateWithDuration:0.3 animations:^{
        scroller.frame=frame0;
        
    }];
}
@end

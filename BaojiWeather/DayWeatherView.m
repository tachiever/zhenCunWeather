//
//  DayWeatherView.m
//  BaojiWeather
//
//  Created by Tcy on 2017/6/5.
//  Copyright © 2017年 Tcy. All rights reserved.
//

#import "DayWeatherView.h"

@implementation DayWeatherView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 初始化设置
        [self setup];
    }
    return self;
}

- (void)setup {
    CGFloat f;
    f=SCREEN_HEIGHT>600?(SCREEN_HEIGHT>700?12.5:12):12.5;
    
    UIView *lin1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1)];
    lin1.backgroundColor=RGBACOLOR(250, 250, 250, 0.9);
    [self addSubview:lin1];
    
    UIView *lin2=[[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-1, self.frame.size.width, 1)];
    lin2.backgroundColor=RGBACOLOR(250, 250, 250, 0.9);
    [self addSubview:lin2];
    
    
    UIView *lin3=[[UIView alloc]initWithFrame:CGRectMake(self.frame.size.width,0,0.5, self.frame.size.width)];
    lin3.backgroundColor=RGBACOLOR(250, 250, 250, 0.9);
    [self addSubview:lin3];
    
    UIView *lin4=[[UIView alloc]initWithFrame:CGRectMake(0,0,0.5, self.frame.size.width)];
    lin4.backgroundColor=RGBACOLOR(250, 250, 250, 0.9);
    [self addSubview:lin4];
    
    _dateLab=[[UILabel alloc]initWithFrame:CGRectMake(5, 15,self.frame.size.width/2-10,15)];
    _dateLab.font=[UIFont fontWithName:@"ArialMT" size:f];
   // _dateLab.textAlignment=NSTextAlignmentLeft;
    _dateLab.textColor=[UIColor whiteColor];
    [self addSubview:_dateLab];
    
    
    _temLab=[[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width/2-5, 15,self.frame.size.width/2+2,15)];
    _temLab.textAlignment=NSTextAlignmentRight;
    _temLab.font=[UIFont fontWithName:@"ArialMT" size:f];
    _temLab.textColor=[UIColor whiteColor];
    [self addSubview:_temLab];
    
    _weaLab=[[UILabel alloc]initWithFrame:CGRectMake(15,40,self.frame.size.width/2,self.frame.size.height-50)];
    _weaLab.font=[UIFont fontWithName:@"ArialMT" size:f];
    _weaLab.textColor=[UIColor whiteColor];
    [self addSubview:_weaLab];
    
    
    
    _weathIcon=[[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width-self.frame.size.height+50-20,35, self.frame.size.height-45, self.frame.size.height-45)];
    _weathIcon.contentMode = UIViewContentModeScaleToFill;
    
    [self addSubview:_weathIcon];

}

- (void)setImage:(NSString *)image date:(NSString *)date tem:(NSString *)temp  wea:(NSString *)wea{
    [_weathIcon setImage:[UIImage imageNamed:[self dayWeatherChangeImage:image]]];
    [_dateLab setText:date];
    [_temLab setText:temp];
    [_weaLab setText:wea];
    
}

- (void)updateWithDic:(NSDictionary *)dic{
    [_weathIcon setImage:[UIImage imageNamed:[self dayWeatherChangeImage:dic[@"image"]]]];
    [_dateLab setText:dic[@"date"]];
    [_temLab setText:dic[@"temp"]];
    [_weaLab setText:dic[@"wea"]];
    
}
- (NSString *)dayWeatherChangeImage:(NSString *)weather{
    
    NSString *dayIconstr;
    NSInteger dayIcon=[weather integerValue];
    if (0==dayIcon){
        dayIconstr=@"d_qing";
    }
    else if (1==dayIcon){
        dayIconstr=@"d_duoyun";
    }
    else if (2==dayIcon){
        dayIconstr=@"d_yin";
        
    }
    else if (3==dayIcon){
        dayIconstr=@"d_zhenyu";
    }
    else if (4==dayIcon){
        dayIconstr=@"d_leizhenyu";
    }
    else if (5==dayIcon){
        dayIconstr=@"d_leizhengyubanyoubingbao";
    }
    else if (6==dayIcon){
        dayIconstr=@"d_yujiaxue";
    }
    else if (7==dayIcon){
        dayIconstr=@"d_xiaoyu";
    }
    else if (8==dayIcon){
        dayIconstr=@"d_zhongyu";
    }
    else if (9==dayIcon){
        dayIconstr=@"d_dayu";
    }
    else if (10==dayIcon){
        dayIconstr=@"d_baoyu";
    }
    else if (11==dayIcon){
        dayIconstr=@"d_dabaoyu";
    }
    else if (12==dayIcon){
        dayIconstr=@"d_tedabaoyu";
    }
    else if (13==dayIcon){
        dayIconstr=@"d_zhenxue";
    }
    else if (14==dayIcon){
        dayIconstr=@"d_xiaoxue";
    }
    else if (15==dayIcon){
        dayIconstr=@"d_zhongxue";
    }
    else if (16==dayIcon){
        dayIconstr=@"d_daxue";
    }
    else if (17==dayIcon){
        dayIconstr=@"d_baoxue";
    }
    else if (18==dayIcon){
        dayIconstr=@"d_wu";
    }
    else if (19==dayIcon){
        dayIconstr=@"d_dongyu";
    }
    else if (20==dayIcon){
        dayIconstr=@"d_shachenbao";
    }
    else if (21==dayIcon){
        dayIconstr=@"d_xiaoyu_zhongyu";
    }
    else if (22==dayIcon){
        dayIconstr=@"d_zhongyu_dayu";
    }
    else if (23==dayIcon){
        dayIconstr=@"d_dayu_baoyu";
    }
    else if (24==dayIcon){
        dayIconstr=@"d_baoyu_dabaoyu";
    }
    else if (25==dayIcon){
        dayIconstr=@"d_dabaoyu_tedabaoyu";
    }
    else if (26==dayIcon){
        dayIconstr=@"d_xiaoxue_zhongxue";
    }
    else if (27==dayIcon){
        dayIconstr=@"d_zhongxue_daxue";
    }
    else if (28==dayIcon){
        dayIconstr=@"d_daxue_baoxue";
    }
    else if (29==dayIcon){
        dayIconstr=@"d_fuchen";
    }
    else if (30==dayIcon){
        dayIconstr=@"d_yangsha";
    }
    else if (31==dayIcon){
        dayIconstr=@"d_qiangshachenbao";
    }
    else if (32==dayIcon){
        dayIconstr=@"d_mai";
    }
    
    return dayIconstr;
}
@end

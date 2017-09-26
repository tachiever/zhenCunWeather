//
//  MainPageView.m
//  BaojiWeather
//
//  Created by Tcy on 2017/2/21.
//  Copyright © 2017年 Tcy. All rights reserved.
//

#import "MainPageView.h"


@implementation MainPageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 初始化设置
        [self setup];
        
    }
    return self;
}

- (void)setup {
    CGFloat f1,f2,f3,w,w1,w2;
    f1=SCREEN_HEIGHT>600 ?26:23;
    f2=SCREEN_HEIGHT>600 ?38:34;
    f3=SCREEN_HEIGHT>600 ?(SCREEN_WIDTH>400?70:68):55;
    w=SCREEN_HEIGHT>600 ?30.0:33.0;
    w1=SCREEN_HEIGHT>600 ?125.0:115.0;
    w2=SCREEN_HEIGHT>600 ?116.0:100.0;
    _posiLab=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 140, 35)];
    _posiLab.text=@"";
    _posiLab.textColor=[UIColor whiteColor];
    _posiLab.font=[UIFont systemFontOfSize:f1];
    [self addSubview:_posiLab];
    
    _bkBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _bkBtn.frame=CGRectMake(150, 3, 27, 27);
    [_bkBtn setImage:[UIImage imageNamed:@"Imageleft_rod"] forState:UIControlStateNormal];
   // [_bkBtn setBackgroundColor:[UIColor redColor]];
    [_bkBtn addTarget:self action:@selector(tapGesturer) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_bkBtn];
    
    
    
    _weatherLab=[[UILabel alloc]initWithFrame:CGRectMake(14, 50, 130, 55)];
    _weatherLab.text=@"晴";
    _weatherLab.textColor=[UIColor whiteColor];
    _weatherLab.font=[UIFont systemFontOfSize:f2];
    [self addSubview:_weatherLab];
    
    _temLab=[[UILabel alloc]initWithFrame:CGRectMake(10, 110, 180, 80)];
    _temLab.text=@"℃";
    _temLab.textColor=[UIColor whiteColor];
    _temLab.font=[UIFont fontWithName:@"GeezaPro" size:f3];
    [self addSubview:_temLab];
    
    
    UIButton *surBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    surBtn.frame=CGRectMake(self.frame.size.width-80*Rat,0,50*Rat,50*Rat);
    //[surBtn setImage:[UIImage imageNamed:@"load"] forState:UIControlStateNormal];
    [surBtn setBackgroundImage:[UIImage imageNamed:@"load"] forState:UIControlStateNormal];
    [surBtn addTarget:self action:@selector(readText) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:surBtn];
    
    
    
    _timeLab=[[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width/2.0-w+3,60 ,self.frame.size.width/2.0, 25)];
    _timeLab.text=@"分钟前更新";
    _timeLab.textColor=[UIColor whiteColor];
    _timeLab.font=[UIFont fontWithName:@"GeezaPro" size:16];
    [self addSubview:_timeLab];

    
    _rainLab=[[IconAndLabView alloc]initWithFrame:CGRectMake(self.frame.size.width/2.0-w,90 ,w1, 25)];
    [_rainLab setImage:[UIImage imageNamed:@"sk_rain"] text:@"降水:"];
    [self addSubview:_rainLab];
    
    
    _humLab=[[IconAndLabView alloc]initWithFrame:CGRectMake(self.frame.size.width/2.0-w+w2-10,90 , self.frame.size.width/2.0+10, 25)];
    [_humLab setImage:[UIImage imageNamed:@"sk_temp"] text:@"湿度:"];
    [self addSubview:_humLab];
    
    
    
    _windLab=[[IconAndLabView alloc]initWithFrame:CGRectMake(self.frame.size.width/2.0-w,120 , self.frame.size.width/2.0+10, 25)];
    [_windLab setImage:[UIImage imageNamed:@"sk_wind"] text:@"风:"];
    [self addSubview:_windLab];
    
    UIButton *btn1=[UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame=CGRectMake(self.frame.size.width/2.0-w+5,150 ,32, 25);
    [btn1 setTitle:@"统计" forState:UIControlStateNormal];
    btn1.titleLabel.font=[UIFont fontWithName:@"ArialMT" size:14];
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    btn1.layer.borderWidth=1;
    btn1.layer.borderColor=RGBCOLOR(50, 155,200).CGColor;
    [btn1 setBackgroundColor:[UIColor clearColor]];
    btn1.tag=1;
    [btn1 addTarget:self action:@selector(moreInfo:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn1];
    
    UIButton *btn2=[UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame=CGRectMake(self.frame.size.width/2.0-w+42,150 ,32, 25);
    [btn2 setTitle:@"附近" forState:UIControlStateNormal];
    btn2.titleLabel.font=[UIFont fontWithName:@"ArialMT" size:14];
    [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    btn2.layer.borderWidth=1;
    btn2.layer.borderColor=RGBCOLOR(50, 155,200).CGColor;
    [btn2 setBackgroundColor:[UIColor clearColor]];
    btn2.tag=2;
    [btn2 addTarget:self action:@selector(moreInfo:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn2];
    
    
    UIButton *btn3=[UIButton buttonWithType:UIButtonTypeCustom];
    btn3.frame=CGRectMake(self.frame.size.width/2.0-w+79,150 ,62, 25);
    [btn3 setTitle:@"预报查询" forState:UIControlStateNormal];
    btn3.titleLabel.font=[UIFont fontWithName:@"ArialMT" size:14];
    [btn3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn3 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    btn3.layer.borderWidth=1;
    btn3.layer.borderColor=RGBCOLOR(50, 155,200).CGColor;
    [btn3 setBackgroundColor:[UIColor clearColor]];
    btn3.tag=3;
    [btn3 addTarget:self action:@selector(moreInfo:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn3];
    
    
    
    UIButton *btn4=[UIButton buttonWithType:UIButtonTypeCustom];
    btn4.frame=CGRectMake(self.frame.size.width/2.0-w+146,150 ,45, 25);
    [btn4 setTitle:@"日雨量" forState:UIControlStateNormal];
    btn4.titleLabel.font=[UIFont fontWithName:@"ArialMT" size:14];
    [btn4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn4 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    btn4.layer.borderWidth=1;
    btn4.layer.borderColor=RGBCOLOR(50, 155,200).CGColor;
    [btn4 setBackgroundColor:[UIColor clearColor]];
    btn4.tag=4;
    [btn4 addTarget:self action:@selector(moreInfo:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn4];
}

- (void)moreInfo:(UIButton *)btn{
    
    if(self.actionShowPage)
    {
        self.actionShowPage(btn.tag);
    }
    
}

//show bai ke
- (void)tapGesturer{
    
    NSString *st=[NSString stringWithFormat:baikeUrl,_posiLab.text];
    st = [st  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url=[NSURL URLWithString:st];

    [[UIApplication sharedApplication] openURL:url];
}

- (void)readText{
    if(self.actionRead)
    {
        self.actionRead();
    }
}

- (void)updateViewdata:(NSDictionary *)dic{
    _timeLab.text=dic[@"updata_time"];
    [_posiLab setText:dic[@"user_town"]];
    [self updateUIwithString];
    [_weatherLab setText:dic[@"weather"]];
    [_temLab setText:dic[@"temp"]];
    
    
    [_windLab updateText:dic[@"wind_direct"]];
    [_humLab updateText:dic[@"hum"]];
    [_rainLab updateText:dic[@"rain"]];

    
//    [_windLab updateText:[NSString stringWithFormat:@"风:%@风 %@ %@m/s",[self windDirection:dic[@"wind_direction"]],[self windSpeed:dic[@"wind_lv"]],dic[@"wind_lv"]]];
//    [_humLab updateText:[NSString stringWithFormat:@"湿度:%@",dic[@"hum"]]];
//    [_rainLab updateText:[NSString stringWithFormat:@"降水:%@",dic[@"rain"]]];
    
    
    
    
    
}
- (void)updateUIwithString{
    CGFloat f1=SCREEN_HEIGHT>600 ?26:23;
    NSDictionary *attrs = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:f1]};
    CGSize size=[_posiLab.text sizeWithAttributes:attrs];
    CGRect fr=_posiLab.frame;
    fr.size=size;
    _posiLab.frame=fr;
    
    CGRect fr1=_bkBtn.frame;
    fr1.origin.x=size.width+20;
    _bkBtn.frame=fr1;
    

    
}

- (NSString *)timelenth:(NSString *)str{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.s"];

    NSDate *date1 = [dateFormatter dateFromString:str];
    NSDate *date = [NSDate date];


    NSTimeInterval time = [date timeIntervalSinceDate:date1];
    NSString *dateContent;
    if ((int)time>3600) {
        int minutes = ((int)time)/3600;

        dateContent = [[NSString alloc] initWithFormat:@"%i小时",minutes];

    }else{
        int minutes = ((int)time)/60;

        dateContent = [[NSString alloc] initWithFormat:@"%i分钟",minutes];

    }

    return dateContent;
}

- (NSString *)windSpeed:(NSString *)dic{
    NSString *jb;
    NSInteger val=[dic integerValue];
    if (0.0 <= val && val <= 0.2) {
        jb = @"0级";
    } else if (0.3 <= val && val <= 1.5) {
        jb = @"1级";
    } else if (1.6 <= val && val <= 3.3) {
        jb = @"2级";
    } else if (3.4 <= val && val <= 5.4) {
        jb = @"3级";
    } else if (5.5 <= val && val <= 7.9) {
        jb = @"4级";
    } else if (8.0 <= val && val <= 10.7) {
        jb = @"5级";
    } else if (10.8 <= val && val <= 13.8) {
        jb = @"6级";
    } else if (13.9 <= val && val <= 17.1) {
        jb = @"7级";
    } else if (17.2 <= val && val <= 17.2) {
        jb = @"8级";
    } else if (20.8 <= val && val <= 24.4) {
        jb = @"9级";
    } else if (24.5<= val && val <= 28.4) {
        jb = @"10级";
    } else if (28.5<= val && val <= 32.6) {
        jb = @"11级";
    } else if (32.7<= val && val <= 36.9) {
        jb = @"12级";
    } else if (37.0 <= val && val <= 41.4) {
        jb = @"13级";
    } else if (41.5 <= val && val <= 46.1) {
        jb = @"14级";
    } else if (46.2 <= val && val <= 50.9) {
        jb = @"15级";
    } else if (51.0 <= val && val <= 56.0) {
        jb = @"16集";
    }else if (56.1<= val && val <= 61.2) {
        jb = @"17级";
    }else if(val>=61.3){
        jb = @"18级";
    }
    
    return jb;


}
- (NSString *)windDirection:(NSString *)dic{
    
	   NSString *WindDirection;
    NSInteger val=[dic integerValue];
	   if (0 == val) {
           WindDirection = @"北";
           //		   img_id=R.drawable.trend_wind_1;
       } else if (0 < val && val < 90) {
           WindDirection = @"东北";
           //	    	img_id=R.drawable.trend_wind_2;
       }  else if (90 == val) {
           WindDirection = @"东";
           //	    	img_id=R.drawable.trend_wind_3;
       } else if (90 < val && val <180) {
           WindDirection = @"东南";
           //	    	img_id=R.drawable.trend_wind_4;
       } else if (180 == val) {
           WindDirection = @"南";
           //	    	img_id=R.drawable.trend_wind_5;
       } else if (180 < val && val <270) {
           WindDirection = @"西南";
           //	    	img_id=R.drawable.trend_wind_6;
       } else if (270 == val) {
           WindDirection = @"西";
           //	    	img_id=R.drawable.trend_wind_7;
       } else if (270 < val && val <359.9) {
           WindDirection = @"西北";
           //	    	img_id=R.drawable.trend_wind_8;
       }  else {
           WindDirection = @"静";
           //	    	img_id=R.drawable.main_icon_wind_no;
       }
    return WindDirection;
}

@end

//
//  WeatherInfoView.m
//  BaojiWeather
//
//  Created by Tcy on 2017/5/31.
//  Copyright © 2017年 Tcy. All rights reserved.
//

#import "WeatherInfoView.h"
#import "WeekWeatherView.h"
#import "YujingView.h"
#import "MainPageView.h"
#import "DayWeatherView.h"

#import <AVFoundation/AVSpeechSynthesis.h>

@interface WeatherInfoView ()<UIScrollViewDelegate,AVSpeechSynthesizerDelegate>{
    
    AVSpeechSynthesizer*av;
    
    UIScrollView *scroller;
    UIScrollView *dayAndNight;
    UIView *fristPart;
    WeekWeatherView *section2;
    UIView *section3;
    YujingView *remindView;
    MainPageView *sectionPerView1;
    DayWeatherView *daw1;
    DayWeatherView *daw2;
    DayWeatherView *daw3;
    DayWeatherView *daw4;
    DayWeatherView *daw5;
    DayWeatherView *daw6;
    
}
@property (nonatomic, strong) NSMutableArray *shareArr;
@property (nonatomic) NSDictionary *userDic;
@property (nonatomic) NSMutableDictionary *dicion;

@end

@implementation WeatherInfoView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        av= [[AVSpeechSynthesizer alloc]init];
        av.delegate=self;
        _shareArr=[[NSMutableArray alloc]init];
        [self createHeaderView];
        
    }
    return self;
}
- (void)downloadDataWithDic:(NSDictionary *)dic{
    _userDic=dic;
    // NSLog(@"%@,ppp%@",dic,_userDic);
    
    dispatch_queue_t globalQueue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalQueue, ^{
        [self downloadYujing:dic];
        
    });
    dispatch_async(globalQueue, ^{
        
        [self downloadRealWeather:dic];
        
    });
    dispatch_async(globalQueue, ^{
        
        [self downloadForTown:dic];
        
    });
    dispatch_async(globalQueue, ^{
        [self downloadForCity:dic];
        
        
    });
    
}

- (void)downloadYujing:(NSDictionary *)dic{
    
    
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:dic[@"user_city"] forKey:@"city"];
    
    [manger POST:YujingUrl parameters:dict success:^(AFHTTPRequestOperation * operation, id responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        // NSLog(@"预警——————————%@",dict);
        
        if (dict !=nil) {
            remindView.hidden=NO;
            [remindView updateView:dict[@"name"] st:dict[@"diteals"]];
            
            [remindView setActionReadMind:^{
                
                [self readWeather:dict[@"diteals"]];
            }];
        }else{
            
            remindView.hidden=YES;
            
            
        }
        
        [scroller headerEndRefreshing];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [scroller headerEndRefreshing];
        [SVProgressHUD showErrorWithStatus:error.userInfo[@"NSLocalizedDescription"]];
 
    }];
    
    
    
}
- (void)downloadRealWeather:(NSDictionary *)dic{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:dic[@"user_town"] forKey:@"position"];
    [dict setObject:dic[@"user_country"] forKey:@"county"];
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manger POST:RealWeatherUrl parameters:dict success:^(AFHTTPRequestOperation * operation, id responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if (![dict isEqual:[NSNull null]]) {
            
            _dicion=dict;
            [_dicion setObject:dic[@"user_town"] forKey:@"user_town"];
            
            
            // NSLog(@"实况天气——————————%@",_dicion);
            
            [sectionPerView1 updateViewdata:_dicion];
        }
        [scroller headerEndRefreshing];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [scroller headerEndRefreshing];
        
        [SVProgressHUD showErrorWithStatus:error.userInfo[@"NSLocalizedDescription"]];

        
    }];
    
}

- (void)downloadForTown:(NSDictionary *)dic{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:dic[@"user_town"] forKey:@"position"];
    [dict setObject:dic[@"user_country"] forKey:@"county"];
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manger POST:ForTownUrl parameters:dict success:^(AFHTTPRequestOperation * operation, id responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        if (![dict isEqual:[NSNull null]]) {
            [_shareArr removeAllObjects];
            NSMutableArray *arr=[NSMutableArray new];
            NSMutableDictionary *dic2=[[NSMutableDictionary alloc]init];
            [dic2 setObject:dict[@"timen1"] forKey:@"date"];
            [dic2 setObject:dict[@"tn1"] forKey:@"temp"];
            [dic2 setObject:dict[@"dsn1"] forKey:@"wea"];
            [dic2 setObject:dict[@"imgn1"] forKey:@"image"];
            [arr addObject:dic2];
            NSMutableDictionary *dic1=[[NSMutableDictionary alloc]init];
            [dic1 setObject:dict[@"timed1"] forKey:@"date"];
            [dic1 setObject:dict[@"td1"] forKey:@"temp"];
            [dic1 setObject:dict[@"dsd1"] forKey:@"wea"];
            [dic1 setObject:dict[@"imgd1"] forKey:@"image"];
            [arr addObject:dic1];
            
            NSMutableDictionary *dic4=[[NSMutableDictionary alloc]init];
            [dic4 setObject:dict[@"timen2"] forKey:@"date"];
            [dic4 setObject:dict[@"tn2"] forKey:@"temp"];
            [dic4 setObject:dict[@"dsn2"] forKey:@"wea"];
            [dic4 setObject:dict[@"imgn2"] forKey:@"image"];
            [arr addObject:dic4];
            NSMutableDictionary *dic3=[[NSMutableDictionary alloc]init];
            [dic3 setObject:dict[@"timed2"] forKey:@"date"];
            [dic3 setObject:dict[@"td2"] forKey:@"temp"];
            [dic3 setObject:dict[@"dsd2"] forKey:@"wea"];
            [dic3 setObject:dict[@"imgd2"] forKey:@"image"];
            [arr addObject:dic3];
            NSMutableDictionary *dic6=[[NSMutableDictionary alloc]init];
            [dic6 setObject:dict[@"timen3"] forKey:@"date"];
            [dic6 setObject:dict[@"tn3"] forKey:@"temp"];
            [dic6 setObject:dict[@"dsn3"] forKey:@"wea"];
            [dic6 setObject:dict[@"imgn3"] forKey:@"image"];
            [arr addObject:dic6];
            NSMutableDictionary *dic5=[[NSMutableDictionary alloc]init];
            [dic5 setObject:dict[@"timed3"] forKey:@"date"];
            [dic5 setObject:dict[@"td3"] forKey:@"temp"];
            [dic5 setObject:dict[@"dsd3"] forKey:@"wea"];
            [dic5 setObject:dict[@"imgd3"] forKey:@"image"];
            [arr addObject:dic5];
            _shareArr=[arr mutableCopy];
            [self updateUIWithArray:arr];
            // NSLog(@"乡镇预报——————————%@",dict);
        }
        [scroller headerEndRefreshing];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [scroller headerEndRefreshing];
        [SVProgressHUD showErrorWithStatus:error.userInfo[@"NSLocalizedDescription"]];

    }];
    
}

- (void)downloadForCity:(NSDictionary *)dic{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:dic[@"user_city"] forKey:@"city"];
    
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manger POST:ForCityUrl parameters:dict success:^(AFHTTPRequestOperation * operation, id responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        // NSLog(@"城市预报——————————%@",dict);
        if (![dict isEqual:[NSNull null]]) {
            NSArray *temH=@[dict[@"tmp1d"],dict[@"tmp2d"],dict[@"tmp3d"],dict[@"tmp4d"],dict[@"tmp5d"],dict[@"tmp6d"],dict[@"tmp7d"]];
            NSArray *temL=@[dict[@"tmp1n"],dict[@"tmp2n"],dict[@"tmp3n"],dict[@"tmp4n"],dict[@"tmp5n"],dict[@"tmp6n"],dict[@"tmp7n"]];
            NSArray *weaDay=@[dict[@"wf_1"],dict[@"wf_2"],dict[@"wf_3"],dict[@"wf_4"],dict[@"wf_5"],dict[@"wf_6"],dict[@"wf_7"]];
            NSArray *weaNig=@[dict[@"wf_11"],dict[@"wf_22"],dict[@"wf_33"],dict[@"wf_44"],dict[@"wf_55"],dict[@"wf_66"],dict[@"wf_77"]];
            
            NSArray *imgDay=@[dict[@"img1d"],dict[@"img2d"],dict[@"img3d"],dict[@"img4d"],dict[@"img5d"],dict[@"img6d"],dict[@"img7d"]];
            NSArray *imgNig=@[dict[@"img1n"],dict[@"img2n"],dict[@"img3n"],dict[@"img4n"],dict[@"img5n"],dict[@"img6n"],dict[@"img7n"]];
            
            [section2 updateTemH:temH temL:temL weatherDay:weaDay weatherNig:weaNig imageDay:imgDay imageNig:imgNig];
            
            [section2 updatTitlt:dic[@"user_country"]];
        }
        
        [scroller headerEndRefreshing];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [scroller headerEndRefreshing];
        [SVProgressHUD showErrorWithStatus:error.userInfo[@"NSLocalizedDescription"]];

    }];
}


- (void)readWeather:(NSString *)str{
    AVSpeechUtterance*utterance = [[AVSpeechUtterance alloc]initWithString:str];//需要转换的文字
    utterance.pitchMultiplier=1;
    utterance.rate=0.5;// 设置语速，范围0-1，注意0最慢，1最快；AVSpeechUtteranceMinimumSpeechRate最慢，AVSpeechUtteranceMaximumSpeechRate最快
    AVSpeechSynthesisVoice*voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];//设置发音，这是中文普通话
    utterance.voice= voice;
    [av speakUtterance:utterance];//开始
    
}

- (void)createHeaderView{
    CGFloat f1,h0=0.0,h1=0.0,h2=0.0,w=0.0,h4 = 0.0,h5,h6;
    f1=SCREEN_HEIGHT>600 ?17:15;
    h5=440.0;
    h6=150.0;
    
    if (SCREEN_HEIGHT<600) {
        h1 =34*Rat;
        w=SCREEN_WIDTH/2;
        
        h0= 24.0;
        h2=80.0;
        h4=520.0;
    }
    if (SCREEN_HEIGHT>600&&SCREEN_HEIGHT<700) {
        h1 =34*Rat;
        w=SCREEN_WIDTH/3;
        
        h0= 22.0;
        h2=75.0;
        h4=540.0;
        
    }
    if (SCREEN_HEIGHT<740&&SCREEN_HEIGHT>700) {
        h1 =34;
        w=SCREEN_WIDTH/3;
        
        h0= 20.0;
        h2=80.0;
        h4=550.0;
        
    }
    if (SCREEN_HEIGHT>740) {
        h1 =34;
        w=160.0;
        
        h0= 20.0;
        h2=90.0;
        h4=800.0;
        
    }
    scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.frame.size.height)];
    scroller.directionalLockEnabled = YES; //只能一个方向滑动
    scroller.pagingEnabled = NO; //是否翻页
    scroller.backgroundColor = [UIColor lightGrayColor];
    scroller.showsVerticalScrollIndicator =NO; //垂直方向的滚动指示
    scroller.showsHorizontalScrollIndicator =NO; //垂直方向的滚动指示
    scroller.bounces = YES;
    scroller.delegate = self;
    scroller.contentSize = CGSizeMake(0,SCREEN_HEIGHT-40+h4);
    scroller.contentOffset=CGPointMake(0,0);
    [self addSubview:scroller];
    [scroller addHeaderWithTarget:self action:@selector(loadNewData) dateKey:@"refresh"];
    [scroller setHeaderRefreshingText:@"正在刷新..."];
    
    
    fristPart=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-44)];
    fristPart.backgroundColor=[UIColor grayColor];
    [scroller addSubview:fristPart];
    
    
    
    remindView=[[YujingView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    remindView.backgroundColor=[UIColor greenColor];
    
    [remindView setActionShowMindDetail:^{
        if (self.actionYujingDetail) {
            self.actionYujingDetail();
        }
    }];
    
    [fristPart addSubview:remindView];
    remindView.hidden=YES;
    
    
    sectionPerView1=[[MainPageView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-64-44-270, SCREEN_WIDTH, 200)];
    
    [sectionPerView1 setActionRead:^( ) {
        NSString *readStr=[NSString stringWithFormat:@"实况天气:%@,温度:%@,%@",_dicion[@"weather"],_dicion[@"temp"],_dicion[@"wind_direct"]];
        NSString *st=[readStr stringByReplacingOccurrencesOfString:@"m/s" withString:@"米每秒"];
        [self readWeather:st];
    }];
    
    
    [sectionPerView1 setActionShowPage:^(NSInteger num) {
        if (self.actionPage) {
            self.actionPage(num);
        }
    }];
    

    [fristPart addSubview:sectionPerView1];
    
    
    
    
    dayAndNight = [[UIScrollView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-64-44-h2, SCREEN_WIDTH, h2)];
    dayAndNight.directionalLockEnabled = YES; //只能一个方向滑动
    dayAndNight.pagingEnabled = NO; //是否翻页
    dayAndNight.backgroundColor = [UIColor redColor];
    dayAndNight.showsVerticalScrollIndicator =NO; //垂直方向的滚动指示
    dayAndNight.showsHorizontalScrollIndicator =NO; //垂直方向的滚动指示
    dayAndNight.bounces = YES;
    dayAndNight.delegate = self;
    dayAndNight.contentSize = CGSizeMake(w*6,0);
    dayAndNight.contentOffset=CGPointMake(0,0);
    [scroller addSubview:dayAndNight];
    
    daw1=[[DayWeatherView alloc]initWithFrame:CGRectMake(0, 0, w, h2)];
    //    daw1.layer.borderWidth=0.5;
    //    daw1.layer.borderColor=[UIColor whiteColor].CGColor;
    [daw1 setImage:@"1" date:@"01" tem:@"22" wea:@"晴"];
    [dayAndNight addSubview:daw1];
    
    daw2=[[DayWeatherView alloc]initWithFrame:CGRectMake(w*1, 0, w, h2)];
    //    daw2.layer.borderWidth=0.5;
    //    daw2.layer.borderColor=[UIColor whiteColor].CGColor;
    [daw2 setImage:@"1" date:@"02" tem:@"22" wea:@"晴"];
    [dayAndNight addSubview:daw2];
    
    daw3=[[DayWeatherView alloc]initWithFrame:CGRectMake(w*2, 0, w, h2)];
    //    daw3.layer.borderWidth=0.5;
    //    daw3.layer.borderColor=[UIColor whiteColor].CGColor;
    [daw3 setImage:@"1" date:@"03" tem:@"22" wea:@"晴"];
    [dayAndNight addSubview:daw3];
    
    daw4=[[DayWeatherView alloc]initWithFrame:CGRectMake(w*3, 0, w, h2)];
    //    daw4.layer.borderWidth=0.5;
    //    daw4.layer.borderColor=[UIColor whiteColor].CGColor;
    [daw4 setImage:@"1" date:@"04" tem:@"22" wea:@"晴"];
    [dayAndNight addSubview:daw4];
    
    daw5=[[DayWeatherView alloc]initWithFrame:CGRectMake(w*4, 0, w, h2)];
    //    daw5.layer.borderWidth=0.5;
    //    daw5.layer.borderColor=[UIColor whiteColor].CGColor;
    [daw5 setImage:@"1" date:@"05" tem:@"22" wea:@"晴"];
    [dayAndNight addSubview:daw5];
    
    daw6=[[DayWeatherView alloc]initWithFrame:CGRectMake(w*5, 0, w, h2)];
    //    daw6.layer.borderWidth=0.5;
    //    daw6.layer.borderColor=[UIColor whiteColor].CGColor;
    [daw6 setImage:@"1" date:@"06" tem:@"22" wea:@"晴"];
    [dayAndNight addSubview:daw6];
    
    
    section2=[[WeekWeatherView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-64-44, SCREEN_WIDTH, h4)];
    section2.backgroundColor=HEXACOLOR(0x666666, 0.8);
    //sectionNexView4.backgroundColor=RGBACOLOR(156, 147, 72, 0.9);
    [section2 createWeekWeatherWhihTemH:nil temL:nil ];
    
    [scroller addSubview:section2];
    
    section3=[[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-64-44+h4, SCREEN_WIDTH, 68)];
    section3.backgroundColor=HEXACOLOR(0x666666, 0.8);
    [scroller addSubview:section3];
    
    UIView *linView=[[UIView alloc]initWithFrame:CGRectMake(4, 2, SCREEN_WIDTH-8, 1)];
    linView.backgroundColor=RGBACOLOR(222, 222, 222, 0.9);
    [section3 addSubview:linView];
    
    UIButton *surBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    surBtn.frame=CGRectMake(16,20,80,34);
    [surBtn setTitle:@"更多城市" forState:UIControlStateNormal];
    surBtn.titleLabel.font=[UIFont fontWithName:@"ArialMT" size:16];
    [surBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    surBtn.layer.borderWidth=1;
    surBtn.layer.borderColor=RGBCOLOR(50, 155,200).CGColor;
    [surBtn setBackgroundColor:[UIColor clearColor]];
    [surBtn addTarget:self action:@selector(moreCity:) forControlEvents:UIControlEventTouchUpInside];
    [section3 addSubview:surBtn];
    NSArray *imageArr=@[@"logo_wechat.png",@"logo_qq.png",@"logo_wechatmoments.png",@"logo_qzone.png",@"logo_sinaweibo.png",@"logo_other.png"];
    for (int i=0; i<6; i++) {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake((SCREEN_WIDTH-10.000-(h1+2)*6)+(h1+2)*i,h0,h1,h1);
        btn.tag=i;
        [btn setImage:[UIImage imageNamed:imageArr[i]] forState:UIControlStateNormal];
        //[btn setBackgroundColor:[UIColor yellowColor]];
        [btn addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
        [section3 addSubview:btn];
    }
    
}

- (void)updateUIWithArray:(NSMutableArray *)arr{
    [daw1 updateWithDic:arr[0]];
    [daw2 updateWithDic:arr[1]];
    [daw3 updateWithDic:arr[2]];
    [daw4 updateWithDic:arr[3]];
    [daw5 updateWithDic:arr[4]];
    [daw6 updateWithDic:arr[5]];
}
- (void)share:(UIButton *)btn{
    NSLog(@"%ld",(long)_shareArr.count);

    if (_shareArr.count>0) {
        NSString *relStr=[NSString stringWithFormat:@"实况天气:%@,温度:%@,%@",_dicion[@"weather"],_dicion[@"temp"],_dicion[@"wind_direct"]];
        NSString *forStr0=[NSString stringWithFormat:@"%@,%@,%@",_shareArr[0][@"date"],_shareArr[0][@"wea"],_shareArr[0][@"temp"]];
        NSString *forStr1=[NSString stringWithFormat:@"%@,%@,%@",_shareArr[1][@"date"],_shareArr[1][@"wea"],_shareArr[1][@"temp"]];
        NSString *forStr2=[NSString stringWithFormat:@"%@,%@,%@",_shareArr[2][@"date"],_shareArr[2][@"wea"],_shareArr[2][@"temp"]];
        
        NSString *shareStr=[NSString stringWithFormat:@"%@\n\n\n%@\n%@\n%@\n\n\n以上消息来自镇办智慧气象APP\n下载地址:",relStr,forStr0,forStr1,forStr2];
        if(self.actionSharePage)
        {
            self.actionSharePage(btn.tag,shareStr);
        }
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"分享数据出错，请检查网络连接或者刷新数据再次尝试" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}
- (void)moreCity:(UIButton *)btn{
    if(self.actionMoreCity)
    {
        self.actionMoreCity();
    }
}

- (void)updateHighWithFrame:(CGFloat)hig{
    CGRect frame0=scroller.frame;
    frame0.size.height=hig;
    scroller.frame=frame0;
}
- (void)loadNewData {
    NSLog(@"下拉刷新。。。。");
    
    [self downloadDataWithDic:_userDic];
    
}

@end

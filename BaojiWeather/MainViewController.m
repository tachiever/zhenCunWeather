//
//  MainViewController.m
//  BaojiWeather
//
//  Created by Tcy on 2017/5/27.
//  Copyright © 2017年 Tcy. All rights reserved.
//

#import "MainViewController.h"
#import "WeatherInfoView.h"
#import "UUID.h"
#import "NoticeView.h"

#import "PushNoticeController.h"
#import "NoticeDetailController.h"
#import "CalendaruiViewController.h"

#import "WarSignController.h"
#import "NearLyViewController.h"

#import "AtmoSeverView.h"
#import "Kepu.h"
#import "QXServeDetailController.h"
#import "ParkRealView.h"

#import "SincePointView.h"
#import "EcomicView.h"
#import "SpecialWeatherView.h"
#import "UploadWeatherController.h"
#import "PersonView.h"
#import <MessageUI/MessageUI.h>
#import "MeView.h"

#import "SendMessController.h"
#import "WeiboSDK.h"

@interface MainViewController ()<UIScrollViewDelegate,UITextFieldDelegate,MFMessageComposeViewControllerDelegate,QQApiInterfaceDelegate,TencentSessionDelegate,WeiboSDKDelegate>{
    
    UIScrollView *_headerScr;
    UIScrollView *_bodyScr;
    UIView *_signView;
    
    UIView *_inputView;

}
@property (nonatomic) BOOL isShow;
@property (weak, nonatomic) IBOutlet UILabel *titLab;

@property (nonatomic) WeatherInfoView *view0;
@property (nonatomic) AtmoSeverView *view1;
@property (nonatomic) NoticeView *view2;
@property (nonatomic) ParkRealView *view3;
@property (nonatomic) SincePointView *view4;
@property (nonatomic) SpecialWeatherView *view5;
@property (nonatomic) PersonView *view6;
@property (nonatomic) EcomicView *view7;
@property (nonatomic) Kepu *view8;
@property (nonatomic) MeView *view9;

@property (nonatomic) TencentOAuth *tencentOAuth;

@property(nonatomic)UIView *registerView;
@property(nonatomic)UITextField *accountField;

@property(nonatomic)NSDictionary *userDic;
@property(nonatomic)NSMutableArray *staArr;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    _isShow=NO;
    _staArr=[[NSMutableArray alloc]init];
    [self creatreScrollerview];
    if ([[DataDefault shareInstance]userPhone]==nil ) {
        [self showRegisterView];
    }else{
        [self checkUser:[[DataDefault shareInstance]userPhone]];
    }
}
- (void)viewDidAppear:(BOOL)animated{
    
    self.navigationController.navigationBar.hidden=YES;

}

#pragma mark RegisterView Part
- (void)showRegisterView{
    
    if (_registerView==nil) {
        _registerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _registerView.backgroundColor=RGBACOLOR(1, 1, 1, 0.4);
        [self.view addSubview:_registerView];
        
        _inputView=[[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, 200*Rat, 0, 0)];
        _inputView.layer.masksToBounds=YES;
        _inputView.layer.cornerRadius=7;
        _inputView.backgroundColor=RGBACOLOR(246, 246, 246, 0.8);
        [_registerView addSubview:_inputView];
        
        
        CGRect fram=CGRectMake(SCREEN_WIDTH/2-180*Rat, 200*Rat, 360*Rat, 170*Rat);
        [UIView animateWithDuration:0.7 animations:^{
            _inputView.frame=fram;
        }completion:^(BOOL finished){
            
            UIImageView *sigImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 120*Rat, 150*Rat)];
            [sigImageView setImage:[UIImage imageNamed:@"resIcon"]];
            [_inputView addSubview:sigImageView];
            
            _accountField=[[UITextField alloc]initWithFrame:CGRectMake(120*Rat+20, 85*Rat-30-15*Rat,350*Rat-120*Rat-20*Rat-10-10, 30)];
            _accountField.borderStyle=UITextBorderStyleRoundedRect;
            _accountField.delegate=self;
            _accountField.placeholder=@"请输入手机号";
            [_accountField setValue:[UIColor colorWithRed:65/255.0 green:86/255.0 blue:97/255.0 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
            
            [_accountField setValue:[UIFont systemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
            
            _accountField.keyboardType=UIKeyboardTypeNumberPad;
            _accountField.textColor=RGBACOLOR(4, 40, 4,0.9);
            _accountField.font = [UIFont fontWithName:@"ArialMT" size:15];
            _accountField.clearButtonMode=UITextFieldViewModeAlways;
            [_inputView addSubview:_accountField];
            
            UIButton *surBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            surBtn.frame=CGRectMake(120*Rat+20, 85*Rat+15*Rat,350*Rat-120*Rat-20*Rat-10-10, 30);
            [surBtn setTitle:@"确定" forState:UIControlStateNormal];
            [surBtn setTitleColor:RGBACOLOR(236, 236, 236, 0.9) forState:UIControlStateHighlighted];
            surBtn.layer.masksToBounds=YES;
            surBtn.layer.cornerRadius=4;
            [surBtn setBackgroundColor:RGBACOLOR(7, 100, 177, 0.9)];
            [surBtn addTarget:self action:@selector(registerPhone:) forControlEvents:UIControlEventTouchUpInside];
            [_inputView addSubview:surBtn];
            
            
            UIButton *cusBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            cusBtn.frame=CGRectMake(120*Rat+20, 85*Rat+55*Rat,350*Rat-120*Rat-20*Rat-10-10, 25);
            cusBtn.titleLabel.font=[UIFont systemFontOfSize:14];
            [cusBtn setTitle:@"访客登录" forState:UIControlStateNormal];
            [cusBtn setTitleColor:RGBACOLOR(236, 236, 236, 0.9) forState:UIControlStateHighlighted];
            [cusBtn setTitleColor:RGBACOLOR(7, 100, 177, 0.9) forState:UIControlStateNormal];
            [cusBtn addTarget:self action:@selector(CustomerVist) forControlEvents:UIControlEventTouchUpInside];
            [_inputView addSubview:cusBtn];
            
            
            
        }];
    }
}
- (void)registerViewHidden{
    [UIView animateWithDuration:0.8 animations:^{
        _registerView.alpha=0;
    }completion:^(BOOL finished){
        _registerView.hidden=YES;
    }];
    
}
- (void)registerPhone:(UIButton *)btn{
    [_accountField resignFirstResponder];
    NSString * phone= [_accountField text];
    NSString * uuid= [UUID getUUID];

    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:phone forKey:@"phone"];
    [dict setObject:@"register" forKey:@"registerOrcount"];
    if (phone.length==11) {
        [manger POST:UserRegisterUrl parameters:dict success:^(AFHTTPRequestOperation * operation, id responseObject) {
            NSArray *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];

            if ([dict[0][@"code"] isEqualToString:@"ok"]) {
                [[DataDefault shareInstance]setUserPhone:phone];
                
                

                _userDic=dict[1];
                [_view0 downloadDataWithDic:dict[1]];
                dispatch_queue_t globalQueue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                dispatch_async(globalQueue, ^{
                    [self sendCount:phone uuid:uuid position:[NSString stringWithFormat:@"%@",dict[1][@"user_country"]]];
                });
                
            }else{
            
                [SVProgressHUD showErrorWithStatus:@"请联系后台人员添加"];

            }
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:error.userInfo[@"NSLocalizedDescription"]];
        }];
    }
    else{
        [SVProgressHUD showErrorWithStatus:@"手机号码不正确！"];
    }
    
    
}
- (void)sendCount:(NSString *)phone uuid:(NSString *)uuid position:(NSString *)posi{
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:phone forKey:@"phone"];
    [dict setObject:@"count" forKey:@"registerOrcount"];
    [dict setObject:posi forKey:@"position"];
    [dict setObject:uuid forKey:@"uuid"];
    [dict setObject:@"2" forKey:@"apk_type"];
    [manger POST:UserInforUrl parameters:dict success:^(AFHTTPRequestOperation * operation, id responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        if ([dict[@"msg"] isEqualToString:@"ok"]) {
            [self registerViewHidden];

        }
        
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:error.userInfo[@"NSLocalizedDescription"]];

        
    }];
    
}
- (void)checkUser:(NSString *)phone{
    NSString * uuid= [UUID getUUID];

    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:phone forKey:@"phone"];
        [manger POST:UserRegisterUrl parameters:dict success:^(AFHTTPRequestOperation * operation, id responseObject) {
            NSArray *arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            
            
           // NSLog(@"后台返回用户信息%@",arr);
            

            if ([arr[0][@"code"] isEqualToString:@"ok"]) {
                _userDic=arr[1];
                [_view0 downloadDataWithDic:arr[1]];
                dispatch_queue_t globalQueue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                dispatch_async(globalQueue, ^{
                    [self sendCount:phone uuid:uuid position:[NSString stringWithFormat:@"%@",arr[1][@"user_country"]]];
                });

            }else{
                
                [[DataDefault shareInstance]setUserPhone:nil];
                [self showRegisterView];

            }
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:error.userInfo[@"NSLocalizedDescription"]];
        }];
}

- (void)CustomerVist{
    [self registerViewHidden];
    [_accountField resignFirstResponder];

    NSDictionary *dic=@{@"user_role":@"",@"user_workunits":@"经二路街道",@"user_country":@"渭滨区",@"user_name":@"访客用户",@"user_phone":@"000000",@"user_city":@"宝鸡市",@"user_town":@"经二路街道",@"user_post":@"访客"};
    _userDic=dic;
    [_view0 downloadDataWithDic:_userDic];

}



#pragma mark ScrollerView And Animation Part
- (void)creatreScrollerview{
    NSArray *arr=@[@"天气信息",@"气象服务",@"通知公告",@"园区实况",@"景点预报",@"特殊天气",@"组织人员",@"商业资讯",@"科普",@"个人中心"];
    
    for (int i=0; i<10; i++) {
        [_staArr addObject:@(YES)];
    }
    _headerScr = [[UIScrollView alloc] initWithFrame:CGRectMake(0,64, SCREEN_WIDTH, 44)];
    _headerScr.directionalLockEnabled = YES; //只能一个方向滑动
    _headerScr.pagingEnabled = NO; //是否翻页
    _headerScr.backgroundColor =RGBCOLOR(0, 32, 203);
    _headerScr.showsVerticalScrollIndicator =NO; //垂直方向的滚动指示
    _headerScr.showsHorizontalScrollIndicator =NO; //垂直方向的滚动指示
    _headerScr.bounces = YES;
    _headerScr.delegate = self;
    _headerScr.contentInset=UIEdgeInsetsMake(0,0,0,0);
    _headerScr.contentSize = CGSizeMake(100*arr.count,0);
    [self.view addSubview:_headerScr];
    
    for (int i=0; i<arr.count; i++) {
        UIButton *pubBtn=[[UIButton alloc]initWithFrame:CGRectMake(100*i, 0, 100, 43)];
        pubBtn.tag=i;
        [pubBtn setTitle:[NSString stringWithFormat:@"%@",arr[i]] forState:UIControlStateNormal];
        [pubBtn setTitleColor:RGBCOLOR(145, 145, 145) forState:UIControlStateHighlighted];
        pubBtn.titleLabel.font=[UIFont systemFontOfSize:16];
        [pubBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [pubBtn setBackgroundColor:RGBCOLOR(193, 218, 249)];
        [pubBtn addTarget:self action:@selector(selkind:) forControlEvents:UIControlEventTouchUpInside];
        [_headerScr addSubview:pubBtn];
    }
    _signView=[[UIView alloc]initWithFrame:CGRectMake(0, 41, 100, 3)];
    _signView.backgroundColor=RGBACOLOR(0, 181, 233, 0.9);
    [_headerScr addSubview:_signView];
    
    _bodyScr = [[UIScrollView alloc] initWithFrame:CGRectMake(0,64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    _bodyScr.directionalLockEnabled = YES; //只能一个方向滑动
    _bodyScr.pagingEnabled = YES; //是否翻页
    _bodyScr.backgroundColor = [UIColor whiteColor];
    _bodyScr.showsVerticalScrollIndicator =NO; //垂直方向的滚动指示
    _bodyScr.showsHorizontalScrollIndicator =NO; //垂直方向的滚动指示
    _bodyScr.bounces = YES;
    _bodyScr.delegate = self;
    _bodyScr.contentInset=UIEdgeInsetsMake(0,0,0,0);
    _bodyScr.contentSize = CGSizeMake(SCREEN_WIDTH*arr.count,0);
    [self.view addSubview:_bodyScr];
    
    
    _view0=[[WeatherInfoView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _bodyScr.frame.size.height)];
    [_bodyScr addSubview:_view0];
    
    [_view0 setActionYujingDetail:^{
        WarSignController *urlPage=[[WarSignController alloc]init];
        urlPage.titleStr=@"预警信号地图";
        [self.navigationController pushViewController:urlPage animated:YES];
    }];
    
    [_view0 setActionMoreCity:^{
        CalendaruiViewController *urlPage=[[CalendaruiViewController alloc]init];
        urlPage.title=@"全国天气";
        urlPage.kind=@"webPage";
        urlPage.indexNum=7;
        [self.navigationController pushViewController:urlPage animated:YES];
    }];
    
    [_view0 setActionPage:^(NSInteger num) {
        if (num==1) {
            CalendaruiViewController *urlPage=[[CalendaruiViewController alloc]init];
            urlPage.kind=@"webPage";

            urlPage.titleStr=@"降水统计";
            urlPage.indexNum=8;
            [self.navigationController pushViewController:urlPage animated:YES];

        }
        if (num==2) {

            
            NearLyViewController *urlPage=[[NearLyViewController alloc]init];            
            urlPage.titleStr=@"附近";
            [self.navigationController pushViewController:urlPage animated:YES];
            
        }
        if (num==3) {
            CalendaruiViewController *urlPage=[[CalendaruiViewController alloc]init];
            urlPage.kind=@"webPage";

            urlPage.titleStr=@"预报查询";
            urlPage.indexNum=9;
            [self.navigationController pushViewController:urlPage animated:YES];

        }
        if (num==4) {
            CalendaruiViewController *urlPa=[[CalendaruiViewController alloc]init];
            urlPa.kind=@"webPage";

            urlPa.titleStr=@"日雨量";
            urlPa.indexNum=10;
            [self.navigationController pushViewController:urlPa animated:YES];
        }
    }];
    
    [_view0 setActionSharePage:^(NSInteger inte,NSString *shareStr) {
        
        [self sharePart:inte withStr:shareStr];
        
    }];
    
   
    _view1=[[AtmoSeverView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*1, 0, SCREEN_WIDTH, _bodyScr.frame.size.height)];
    [_bodyScr addSubview:_view1];
    [_view1 setActionDataDetail:^(NSString *detid) {
        QXServeDetailController *dvc=[[QXServeDetailController alloc]init];
        dvc.detailid=detid;
        [self.navigationController pushViewController:dvc animated:YES];
    }];
    
    _view2=[[NoticeView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*2, 0, SCREEN_WIDTH, _bodyScr.frame.size.height)];
    [_bodyScr addSubview:_view2];
    
    [_view2 setActionPushNotice:^{
        
        if ([_userDic[@"user_post"] isEqualToString:@"镇长"]) {
            PushNoticeController *ndvc=[[PushNoticeController alloc]init];
            ndvc.dic=_userDic;
            [ndvc setActionPushSuccess:^{
                [_view2 refreshData];
            }];
            [self.navigationController pushViewController:ndvc animated:YES];
        }else{
        
            [SVProgressHUD showErrorWithStatus:@"权限不够，不能发通知！"];

        }

        
    }];
    [_view2 setActionShowDetail:^(NSString *notid) {
        NoticeDetailController *ndvc=[[NoticeDetailController alloc]init];
        ndvc.notId=notid;
        ndvc.userInf=_userDic;
        [self.navigationController pushViewController:ndvc animated:YES];
        
    }];
    
    _view3=[[ParkRealView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*3, 0, SCREEN_WIDTH, _bodyScr.frame.size.height)];
    [_bodyScr addSubview:_view3];
    
    _view4=[[SincePointView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*4, 0, SCREEN_WIDTH, _bodyScr.frame.size.height)];
    [_bodyScr addSubview:_view4];
    
    
    _view5=[[SpecialWeatherView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*5, 0, SCREEN_WIDTH, _bodyScr.frame.size.height)];
    [_bodyScr addSubview:_view5];
    [_view5 setActionUploadeNotice:^(){
        UploadWeatherController *upvc=[[UploadWeatherController alloc]init];
        upvc.userDic=_userDic;
    [self.navigationController pushViewController:upvc animated:YES];
    }];
    
    _view6=[[PersonView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*6, 0, SCREEN_WIDTH, _bodyScr.frame.size.height)];
    [_bodyScr addSubview:_view6];
    
    [_view6 setActionMakeCell:^(NSString *phone) {
        [self makeCall:phone];
    }];
    [_view6 setActionSendMess:^(NSString *phone) {
        [self showMessageView:phone];

    }];
    
    
    _view7=[[EcomicView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*7, 0, SCREEN_WIDTH, _bodyScr.frame.size.height)];
    [_bodyScr addSubview:_view7];
    [_view7 setActionNewsDetail:^(NSInteger newskind) {
        CalendaruiViewController *urlPa=[[CalendaruiViewController alloc]init];
        urlPa.kind=@"webPage";
        
        urlPa.titleStr=@"商业资讯";
        urlPa.indexNum=newskind;
        [self.navigationController pushViewController:urlPa animated:YES];
        NSLog(@"%d",newskind);
    }];
    
    
    
    _view8=[[Kepu alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*8, 0, SCREEN_WIDTH, _bodyScr.frame.size.height)];
    [_bodyScr addSubview:_view8];
    [_view8 setActionDataDetail:^(NSString * detid) {
        QXServeDetailController *dvc=[[QXServeDetailController alloc]init];
        dvc.detailid=detid;
        [self.navigationController pushViewController:dvc animated:YES];
    }];
    
    
    _view9=[[MeView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*9, 0, SCREEN_WIDTH, _bodyScr.frame.size.height)];
    [_bodyScr addSubview:_view9];
    [_view9 setActionShowMessPage:^{
        SendMessController *urlPa=[[SendMessController alloc]init];

        [self.navigationController pushViewController:urlPa animated:YES];
    }];
    
    
}
- (void)selkind:(UIButton *)btn{
    [self movescreViewTo:btn.tag];
    [self signViewMove:btn.tag];
    [self setTitleStr:btn.tag];
}





- (void)showMessageView:(NSString *)num{
    if( [MFMessageComposeViewController canSendText] )
    {
        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc] init]; //autorelease];
        controller.recipients = [NSArray arrayWithObject:num];
        controller.body = @"";
        controller.messageComposeDelegate = self;
        
        [self presentModalViewController:controller animated:YES];
        //[[[[controller viewControllers] lastObject] navigationItem] setTitle:@""];//修改短信界面标题
    }
    else
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示信息" message:@"该设备不支持短信功能" preferredStyle:  UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alert animated:true completion:nil];
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    [controller dismissModalViewControllerAnimated:NO];//关键的一句   不能为YES
    switch ( result ) {
        case MessageComposeResultCancelled:
        {
            //click cancel button
        }
            break;
        case MessageComposeResultFailed:// send failed
            
            break;
        case MessageComposeResultSent:
        {
            
            //do something
        }
            break;
        default:
            break;
    }
    
}
- (void)makeCall:(NSString *)num{
    NSString *allString = [NSString stringWithFormat:@"tel://%@",num];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:allString]];
}


-(void) scrollViewDidEndDecelerating:(UIScrollView *)scro  {
        if (scro==_bodyScr) {
            
            int pag=scro.contentOffset.x/scro.bounds.size.width;
        [self signViewMove:pag];
            
            [self setTitleStr:pag];
           // NSLog(@"滑动选择子页面 %f",(scro.contentOffset.x/scro.bounds.size.width));
            
            if (pag==1) {
                if ([_staArr[pag] boolValue]) {
                    [_view1 downloadDataWith:_userDic];
                    BOOL state = [_staArr[pag] boolValue];
                    [_staArr replaceObjectAtIndex:pag withObject:@(!state)];
                }
            }
            if (pag==2) {
                if ([_staArr[pag] boolValue]) {
                    [_view2 downloadDataWith:_userDic];
                    BOOL state = [_staArr[pag] boolValue];
                    [_staArr replaceObjectAtIndex:pag withObject:@(!state)];
                }
            }
            if (pag==3) {
                if ([_staArr[pag] boolValue]) {
                    [_view3 downloadDataWith:_userDic];
                    BOOL state = [_staArr[pag] boolValue];
                    [_staArr replaceObjectAtIndex:pag withObject:@(!state)];
                }
            }
            if (pag==4) {
                if ([_staArr[pag] boolValue]) {
                    [_view4 downloadDataWith:_userDic];
                    BOOL state = [_staArr[pag] boolValue];
                    [_staArr replaceObjectAtIndex:pag withObject:@(!state)];
                }
            }
            if (pag==5) {
                if ([_staArr[pag] boolValue]) {
                    [_view5 downloadDataWith:_userDic];
                    BOOL state = [_staArr[pag] boolValue];
                    [_staArr replaceObjectAtIndex:pag withObject:@(!state)];
                }
            }
            if (pag==6) {
                if ([_staArr[pag] boolValue]) {
                    [_view6 downlaodData];
                    BOOL state = [_staArr[pag] boolValue];
                    [_staArr replaceObjectAtIndex:pag withObject:@(!state)];
                }
            }
            
            if (pag==8) {
                if ([_staArr[pag] boolValue]) {
                    [_view8 downloadDataWith:_userDic];
                    BOOL state = [_staArr[pag] boolValue];
                    [_staArr replaceObjectAtIndex:pag withObject:@(!state)];
                }
            }
            if (pag==9) {
                if ([_staArr[pag] boolValue]) {
                    [_view9 setInfor:_userDic];
                    BOOL state = [_staArr[pag] boolValue];
                    [_staArr replaceObjectAtIndex:pag withObject:@(!state)];
                }
            }
            

    }
}

- (void)movescreViewTo:(NSInteger)inte{
    CGPoint poi=CGPointMake(SCREEN_WIDTH*inte,0);
    
    [UIView animateWithDuration:0.2 animations:^(void){
        _bodyScr.contentOffset=poi;
    }completion:^(BOOL finished) {
        if (inte==1) {
            if ([_staArr[inte] boolValue]) {
                [_view1 downloadDataWith:_userDic];
                BOOL state = [_staArr[inte] boolValue];
                [_staArr replaceObjectAtIndex:inte withObject:@(!state)];
            }
        }
        if (inte==2) {
            if ([_staArr[inte] boolValue]) {
                [_view2 downloadDataWith:_userDic];
                BOOL state = [_staArr[inte] boolValue];
                [_staArr replaceObjectAtIndex:inte withObject:@(!state)];
            }
        }
        if (inte==3) {
            if ([_staArr[inte] boolValue]) {
                [_view3 downloadDataWith:_userDic];
                BOOL state = [_staArr[inte] boolValue];
                [_staArr replaceObjectAtIndex:inte withObject:@(!state)];
            }
        }
        if (inte==4) {
            if ([_staArr[inte] boolValue]) {
                [_view4 downloadDataWith:_userDic];
                BOOL state = [_staArr[inte] boolValue];
                [_staArr replaceObjectAtIndex:inte withObject:@(!state)];
            }
        }
        if (inte==5) {
            if ([_staArr[inte] boolValue]) {
                [_view5 downloadDataWith:_userDic];
                BOOL state = [_staArr[inte] boolValue];
                [_staArr replaceObjectAtIndex:inte withObject:@(!state)];
            }
        }        if (inte==6) {
            if ([_staArr[inte] boolValue]) {
                [_view6 downlaodData];
                BOOL state = [_staArr[inte] boolValue];
                [_staArr replaceObjectAtIndex:inte withObject:@(!state)];
            }
        }
        if (inte==8) {
            if ([_staArr[inte] boolValue]) {
                [_view8 downloadDataWith:_userDic];
                BOOL state = [_staArr[inte] boolValue];
                [_staArr replaceObjectAtIndex:inte withObject:@(!state)];
            }
        }
        if (inte==9) {
            if ([_staArr[inte] boolValue]) {
                [_view9 setInfor:_userDic];
                BOOL state = [_staArr[inte] boolValue];
                [_staArr replaceObjectAtIndex:inte withObject:@(!state)];
            }
        }
       // NSLog(@"按钮选择子页面 %ld",inte);
    }];
}

- (void)signViewMove:(NSInteger)inte{
    CGRect fram= CGRectMake(100*inte, 41, 100, 3);
    [UIView animateWithDuration:0.2 animations:^(void){
        _signView.frame=fram;
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^(void){
            if (100*inte<SCREEN_WIDTH/2) {
                _headerScr.contentOffset=CGPointMake(0, 0);
            }else if (100*inte>SCREEN_WIDTH/2&&100*inte<_headerScr.contentSize.width-SCREEN_WIDTH) {
                _headerScr.contentOffset=CGPointMake(100*inte-SCREEN_WIDTH/2+50, 0);
            }else{
                _headerScr.contentOffset=CGPointMake(_headerScr.contentSize.width-SCREEN_WIDTH, 0);
            }
        }completion:^(BOOL finished) {
            
        }];
    }];
}

- (IBAction)showAndHidden:(id)sender {
    CGRect fram;
    if (_isShow) {
        fram= CGRectMake(0, 64, SCREEN_WIDTH,SCREEN_HEIGHT-64);
        [self viewSethight:SCREEN_HEIGHT-64];
        [UIView animateWithDuration:0.2 animations:^(void){
            
            _bodyScr.frame=fram;
        }completion:^(BOOL finished) {
            
        }];
    }else{
        fram= CGRectMake(0, 108, SCREEN_WIDTH,SCREEN_HEIGHT-108);
        [UIView animateWithDuration:0.2 animations:^(void){
            _bodyScr.frame=fram;
        }completion:^(BOOL finished) {
            [self viewSethight:SCREEN_HEIGHT-108];
        }];
    }
    _isShow=!_isShow;
    [self setTitleStr:(_bodyScr.contentOffset.x/_bodyScr.bounds.size.width)];

}
- (void)viewSethight:(CGFloat)h{
    CGRect frame0=_view0.frame;
    frame0.size.height=h;
    _view0.frame=frame0;
    [_view0 updateHighWithFrame:h];

    CGRect frame1=_view1.frame;
    frame1.size.height=h;
    _view1.frame=frame1;
    [_view1 updateHighWithFrame];

    CGRect frame2=_view2.frame;
    frame2.size.height=h;
    _view2.frame=frame2;
    [_view2 updateHighWithFrame];

    CGRect frame3=_view3.frame;
    frame3.size.height=h;
    _view3.frame=frame3;
    [_view3 updateHighWithFrame];

    CGRect frame4=_view4.frame;
    frame4.size.height=h;
    _view4.frame=frame4;
    [_view4 updateHighWithFrame];

    
    CGRect frame5=_view5.frame;
    frame5.size.height=h;
    _view5.frame=frame5;
    [_view5 updateHighWithFrame];

    
    CGRect frame6=_view6.frame;
    frame6.size.height=h;
    _view6.frame=frame6;
    [_view6 updateHighWithFrame];

    CGRect frame7=_view7.frame;
    frame7.size.height=h;
    _view7.frame=frame7;
    [_view7 updateHighWithFrame];

    CGRect frame8=_view8.frame;
    frame8.size.height=h;
    _view8.frame=frame8;
    [_view8 updateHighWithFrame];

    
    CGRect frame9=_view9.frame;
    frame9.size.height=h;
    _view9.frame=frame9;
    [_view9 updateHighWithFrame];

}
- (IBAction)mainPage:(id)sender {
    
    [self movescreViewTo:0];
    [self signViewMove:0];
    [self setTitleStr:0];
}
- (void)setTitleStr:(NSInteger)inte{
    NSArray *arr=@[@"天气信息",@"气象服务",@"通知公告",@"园区实况",@"景点预报",@"特殊天气",@"组织人员",@"商业资讯",@"科普",@"个人中心"];

    if (_isShow) {
        _titLab.text=@"乡镇天气";
    }else{
    
        _titLab.text=arr[inte];

    }

}

#pragma mark -PhoneTextField Editing
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (SCREEN_HEIGHT<500) {
        CGFloat offset=_inputView.frame.origin.y-50;
        [UIView animateWithDuration:0.3 animations:^{
            
            CGRect frame=_inputView.frame;
            frame.origin.y=offset;
            _inputView.frame=frame;
            
        }];
    }
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if (SCREEN_HEIGHT<500) {
        CGFloat offset=_inputView.frame.origin.y+50;
        [UIView animateWithDuration:0.3 animations:^{
            
            CGRect frame=_inputView.frame;
            frame.origin.y=offset;
            _inputView.frame=frame;
            
        }];
    }
    return YES;
}

/******
 
  SharePart
 
 
 *****/


- (void)sharePart:(NSInteger)inte withStr:(NSString *)str{
    if (inte==0) {
        NSLog(@"分享到微信");

    }
    if (inte==1) {
        NSLog(@"分享到qq");
       // [self showMediaNewsWithScene:0 withString:str];
        [self shareWithTextWithScene:0 withString:str];
        NSLog(@"分享到 %@",str);
 
    }
    if (inte==2) {
        NSLog(@"分享到朋友圈");
        
    }
    if (inte==3) {
        NSLog(@"分享到QQ空间");
        //[self showMediaNewsWithScene:1 withString:str];
        [self shareWithTextWithScene:1 withString:str];

    }
    if (inte==4) {
        NSLog(@"分享到新浪微博");
        [self shareToSine:@"www.baidu.com" text:@"测试" description:str image:nil];
        
        
    }
    if (inte==5) {
        NSLog(@"分享到其他");
        
    }
}
// 发送纯文本
- (void)shareWithTextWithScene:(int)scene withString:(NSString *)str{
    
    if (![TencentOAuth iphoneQQInstalled]) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还没有安装QQ客户端" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alert show];
    
    }else {
        // 这里要先授权，QQ的文档里面貌似没写
        self.tencentOAuth = [[TencentOAuth alloc] initWithAppId:qqAppId
                                                    andDelegate:self];
        QQApiTextObject *newsObj = [QQApiTextObject objectWithText:str];
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
        if (scene == 0) {
            NSLog(@"QQ好友列表分享 - %d",[QQApiInterface sendReq:req]);
        }else if (scene == 1){
            NSLog(@"QQ空间分享 - %d",[QQApiInterface SendReqToQZone:req]);
        }    }
}

// 发送图片文字链接
- (void)showMediaNewsWithScene:(int)scene withString:(NSString *)str{
    if (![TencentOAuth iphoneQQInstalled]) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还没有安装QQ客户端" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alert show];
    }else {
        self.tencentOAuth = [[TencentOAuth alloc] initWithAppId:qqAppId
                                                    andDelegate:self];
//        QQApiNewsObject *newsObj = [QQApiNewsObject
//                                    objectWithURL:@"www.baidu.com"
//                                    title:@"李易峰撞车了"
//                                    description:@"李易峰的兰博基尼被撞了李易峰的兰博基尼被撞了李易峰的兰博基尼被撞了"
//                                    previewImageURL:nil];
        
        
        QQApiNewsObject *newsObj=[QQApiNewsObject objectWithURL:[NSURL URLWithString:@"www.baidu.com"] title:@"测试" description:str previewImageData:  UIImagePNGRepresentation([UIImage   imageNamed:@"baoxue_cs.png"])];
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
        if (scene == 0) {
            NSLog(@"QQ好友列表分享 - %d",[QQApiInterface sendReq:req]);
        }else if (scene == 1){
            NSLog(@"QQ空间分享 - %d",[QQApiInterface SendReqToQZone:req]);
        }
    }
}


- (void)shareToSine:(NSString *)url text:(NSString *)text description:(NSString *)description image:(NSString *)imageUrl {
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:wbKey];
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = kRedirectURI;
    request.scope = @"all";
    
    WBMessageObject *message = [WBMessageObject message];
    WBWebpageObject *webpage = [WBWebpageObject object];
    webpage.objectID = @"identifier1";
    webpage.title = NSLocalizedString(text, nil);
    webpage.description = description;
    
    
   // webpage.thumbnailData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
    webpage.thumbnailData = [NSData dataWithData:UIImagePNGRepresentation([UIImage   imageNamed:@"baoxue_cs.png"])];
    
    webpage.webpageUrl = url;
    message.mediaObject = webpage;
    
    WBSendMessageToWeiboRequest *sendMessagerequest = [WBSendMessageToWeiboRequest requestWithMessage:message authInfo:request access_token:nil];
    sendMessagerequest.userInfo = @{@"ShareMessageFrom": @"SendMessageToWeiboViewController",
                                    @"Other_Info_1": [NSNumber numberWithInt:123],
                                    @"Other_Info_2": @[@"obj1", @"obj2"],
                                    @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    //    request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
    [WeiboSDK sendRequest:sendMessagerequest];
}  









- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

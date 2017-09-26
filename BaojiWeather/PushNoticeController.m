//
//  PushNoticeController.m
//  BaojiWeather
//
//  Created by Tcy on 2017/6/2.
//  Copyright © 2017年 Tcy. All rights reserved.
//

#import "PushNoticeController.h"

@interface PushNoticeController ()<UIScrollViewDelegate,UITextFieldDelegate,UITextViewDelegate, UIPickerViewDelegate>{

    UIScrollView *scroller;

}

@property (strong, nonatomic) IBOutlet UIView *titleView;
@property (strong, nonatomic) IBOutlet UIView *dateline;
@property (strong, nonatomic) IBOutlet UIView *detailView;

@property (weak, nonatomic) IBOutlet UITextField *titleText;
@property (weak, nonatomic) IBOutlet UITextField *dateText;
@property (weak, nonatomic) IBOutlet UITextView *countText;

@property (nonatomic) UIDatePicker *datePicker;

@end

@implementation PushNoticeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationController.navigationBar.hidden=NO;
    
    [self stupNav];
    [self createUI];
    [self setUpBirthdayKeyboard];

    
}

- (void)createUI{
    
    CGFloat h=SCREEN_HEIGHT<500 ?600:SCREEN_HEIGHT;
    CGFloat h1=SCREEN_HEIGHT<500 ?800:SCREEN_HEIGHT;
    scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height)];
    scroller.directionalLockEnabled = YES; //只能一个方向滑动
    scroller.pagingEnabled = NO; //是否翻页
    scroller.backgroundColor = [UIColor whiteColor];
    scroller.showsVerticalScrollIndicator =NO; //垂直方向的滚动指示
    scroller.showsHorizontalScrollIndicator =NO; //垂直方向的滚动指示
    scroller.bounces = YES;
    scroller.delegate = self;
    scroller.contentSize = CGSizeMake(0,h1);
    scroller.contentOffset=CGPointMake(0,0);
    [self.view addSubview:scroller];

    
    _titleView.frame=CGRectMake(0, 8, SCREEN_WIDTH, 90);
    _titleView.layer.shadowColor=[UIColor grayColor].CGColor;
    _titleView.layer.shadowOffset=CGSizeMake(0, 2);
    _titleView.layer.shadowOpacity=0.8;
    _titleView.layer.shadowRadius=3.f;
    [scroller addSubview:_titleView];
    
    
    _dateline.frame=CGRectMake(0, 118, SCREEN_WIDTH, 90);
    _dateline.layer.shadowColor=[UIColor grayColor].CGColor;
    _dateline.layer.shadowOffset=CGSizeMake(0, 2);
    _dateline.layer.shadowOpacity=0.8;
    _dateline.layer.shadowRadius=3.f;
    [scroller addSubview:_dateline];
    
    
    _detailView.frame=CGRectMake(0, 228, SCREEN_WIDTH, 180);
    _detailView.layer.shadowColor=[UIColor grayColor].CGColor;
    _detailView.layer.shadowOffset=CGSizeMake(0, 2);
    _detailView.layer.shadowOpacity=0.8;
    _detailView.layer.shadowRadius=3.f;
    [scroller addSubview:_detailView];

    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:40/255.0 green:29/255.0  blue:214/255.0  alpha:1].CGColor, (__bridge id)[UIColor colorWithRed:35/255.0 green:75/255.0  blue:223/255.0  alpha:1].CGColor, (__bridge id)[UIColor colorWithRed:26/255.0 green:128/255.0  blue:237/255.0  alpha:1].CGColor];
    //    gradientLayer.colors = @[(__bridge id)[UIColor redColor].CGColor, (__bridge id)[UIColor yellowColor].CGColor, (__bridge id)[UIColor blueColor].CGColor];
    //    gradientLayer.locations = @[@0.3, @0.5, @1.0];
    gradientLayer.locations = @[@0.2, @0.5,@0.8];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1.0, 0);
    gradientLayer.frame =CGRectMake(0, 0, SCREEN_WIDTH-80*Rat, 52*Rat);
    
    UIButton * searchBtn=[[UIButton alloc]initWithFrame:CGRectMake(40*Rat, h-84-66*Rat, SCREEN_WIDTH-80*Rat, 52*Rat)];
    
    searchBtn.layer.masksToBounds=YES;
    searchBtn.layer.cornerRadius=6;
    
    [searchBtn.layer addSublayer:gradientLayer];
    [searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [searchBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    searchBtn.titleLabel.font=[UIFont systemFontOfSize:18];
    [searchBtn setTitle:@"发 布" forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(pushNotice) forControlEvents:UIControlEventTouchUpInside];
    [scroller addSubview:searchBtn];
    
    
    
    
    _titleText.delegate=self;
    _dateText.delegate=self;
    _countText.delegate=self;
    
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    NSString *date = [dateformatter stringFromDate:[NSDate date]];
    _dateText.text=date;

}

#pragma mark  自定义生日键盘
- (void)setUpBirthdayKeyboard
{
    //创建UIDatePicker
    //注意:UIDatePicker有默认的尺寸，可以不用设置frame
    UIDatePicker *picker = [[UIDatePicker alloc] init];
    
    self.datePicker = picker;
    
    //设置地区
    picker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
    
    //设置日期模式
    picker.datePickerMode = UIDatePickerModeDate;
    
    //监听UIDatePicker的滚动
    [picker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
    _dateText.inputView = picker;
    
    
    
    
    
    
    // 设置键盘上面的工具条
    
    _dateText.inputAccessoryView = [UIButton buttonWithType:UIButtonTypeContactAdd];
    
    UIBarButtonItem *hiddenButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleBordered target:self action:@selector(HiddenKeyBoard)];
    
    UIBarButtonItem *spaceButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIToolbar *accessoryView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    
    accessoryView.barStyle = UIBarStyleDefault;
    accessoryView.items = [NSArray arrayWithObjects:spaceButtonItem,hiddenButtonItem,nil];
    
    _dateText.inputAccessoryView = accessoryView;
    
    
    
}
#pragma mark  监听UIDatePicker的滚动的方法

- (void)dateChange:(UIDatePicker *)datePicker
{
    //日期转字符串
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString *dateString = [fmt stringFromDate:datePicker.date];
    _dateText.text = dateString;
}

- (void)HiddenKeyBoard{
    [_dateText resignFirstResponder];

}

- (void)pushNotice{
    if (_titleText.text.length>1) {
        NSString *strTim=[NSString stringWithFormat:@"%@ 23:59:59",_dateText.text];
        
        if ([self compareDate:strTim]!=-1) {
            
            if (_countText.text.length>5) {
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"请输入权限验证码" message:@"提示\n权限验证码是您的手机号后六位" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
                alertView.tintColor = [UIColor colorWithRed:0.7596 green:0.5249 blue:1.0 alpha:1.0];

                //[[UIView appearance] setTintColor:RGBCOLOR(37, 64, 209)];
                [alertView show];
                
            }else{
            
                [SVProgressHUD showErrorWithStatus:@"内容过短！"];

            }
        }else{
            [SVProgressHUD showErrorWithStatus:@"期限已过期！"];

        }
    }else{
        [SVProgressHUD showErrorWithStatus:@"标题过短！"];

    }

}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        UITextField *txt = [alertView textFieldAtIndex:0];
        NSLog(@"lflflflflflflflfl%@",txt.text);
        
        NSString *str=[[DataDefault shareInstance] userPhone];
        
        NSString *co=[str substringWithRange:NSMakeRange(str.length-6,6)];
        
        NSLog(@"lflflflflflflflfl%@",co);
        if ([txt.text isEqualToString:co]) {
            
            NSString *strTim=[NSString stringWithFormat:@"%@ 23:59:59",_dateText.text];
            NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
            [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *date1 = [dateformatter dateFromString:strTim];
            NSTimeInterval interval = [date1 timeIntervalSince1970];
            NSString *ss=[NSString stringWithFormat:@"%.0f",interval];
            
            [self uploadNotice:_dic tit:_titleText.text count:_countText.text hour:ss];
        }else{
        
            [SVProgressHUD showErrorWithStatus:@"权限验证码错误！"];

        }
    }
}
- (void)uploadNotice:(NSDictionary *)dic tit:(NSString *)tit count:(NSString *)count hour:(NSString *)hour{
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"add" forKey:@"type"];
    [dict setObject:dic[@"user_phone"] forKey:@"phone"];
    [dict setObject:tit forKey:@"title"];
    [dict setObject:count forKey:@"content"];
    [dict setObject:hour forKey:@"hours"];
    [dict setObject:dic[@"user_city"] forKey:@"city"];
    [dict setObject:dic[@"user_country"] forKey:@"country"];
    [dict setObject:dic[@"user_town"] forKey:@"town"];
    [dict setObject:dic[@"user_post"] forKey:@"post"];
    [dict setObject:dic[@"user_name"] forKey:@"name"];
    [manger POST:NoticeUrl parameters:dict success:^(AFHTTPRequestOperation * operation, id responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
      
        
        NSLog(@"%@",dict);
        if ([dict[@"code"] isEqualToString:@"ok"]) {
            [SVProgressHUD showSuccessWithStatus:@"发布成功！"];
            
            [self.navigationController popViewControllerAnimated:YES];
            if (_actionPushSuccess) {
                _actionPushSuccess();
            }
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:error.userInfo[@"NSLocalizedDescription"]];

    }];
}

#pragma mark -PhoneTextField Editing
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;

}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
        if (SCREEN_HEIGHT<600) {
            CGRect frame=CGRectMake(0, 0, SCREEN_WIDTH, 210);
            [UIView animateWithDuration:0.3 animations:^{
    
                _detailView.frame=frame;
    
            }];
        }
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        if (SCREEN_HEIGHT<600) {
            CGRect frame=CGRectMake(0, 228, SCREEN_WIDTH, 180);
            [UIView animateWithDuration:0.3 animations:^{
                
                _detailView.frame=frame;
                
            }];
        }
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}
- (NSInteger)compareDate:(NSString*)date{
    NSInteger aa;
    NSDateFormatter *dateformater = [[NSDateFormatter alloc] init];
    [dateformater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dta = [NSDate date];
    NSDate *dtb = [[NSDate alloc] init];
    dtb = [dateformater dateFromString:date];
    NSComparisonResult result = [dta compare:dtb];
    if (result==NSOrderedSame)
    {
        aa=0;
        //        相等  aa=0
    }else if (result==NSOrderedAscending)
    {
        //bDate比aDate大
        aa=1;
    }else if (result==NSOrderedDescending)
    {
        //bDate比aDate小
        aa=-1;
        
    }
    
    return aa;
}

- (void)stupNav{
    self.title=@"发布通知";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:18.0]}];
    [self.navigationController.navigationBar setBarTintColor:RGBCOLOR(0, 32, 203)];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end

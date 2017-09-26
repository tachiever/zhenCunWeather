//
//  UploadWeatherController.m
//  BaojiWeather
//
//  Created by Tcy on 2017/6/14.
//  Copyright © 2017年 Tcy. All rights reserved.
//

#import "UploadWeatherController.h"
#import "IHAvatarPicker.h"

#define MAX_COMPRESS_PHOTO_R 320.f
@interface UploadWeatherController ()<UIScrollViewDelegate,IHPhotoPickerDelegate>{
    UIScrollView *scroller;
}

@property (strong, nonatomic) IBOutlet UIView *UpView;

@property (weak, nonatomic) IBOutlet UIButton *time1;
@property (weak, nonatomic) IBOutlet UIButton *time2;

@property (weak, nonatomic) IBOutlet UIButton *w1;
@property (weak, nonatomic) IBOutlet UIButton *w2;
@property (weak, nonatomic) IBOutlet UIButton *w3;
@property (weak, nonatomic) IBOutlet UIButton *w4;
@property (weak, nonatomic) IBOutlet UIButton *w5;

@property (weak, nonatomic) IBOutlet UIButton *lv1;
@property (weak, nonatomic) IBOutlet UIButton *lv2;
@property (weak, nonatomic) IBOutlet UIButton *lv3;

@property (weak, nonatomic) IBOutlet UITextView *detail;

@property (weak, nonatomic) IBOutlet UILabel *upPerson;

@property (weak, nonatomic) IBOutlet UIImageView *image;

@property (weak, nonatomic) IBOutlet UIButton *upBtn;
@property (weak, nonatomic) IBOutlet UILabel *disLab;

@property (nonatomic ) NSInteger tim;
@property (nonatomic ) NSInteger we;
@property (nonatomic ) NSInteger lv;

@property (nonatomic) IHPhotoPicker *avatarPicker;
@property (nonatomic) UIImage *navatarImage;
@end

@implementation UploadWeatherController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationController.navigationBar.hidden=NO;
    [self stupNav];

    _tim=-1;
    _we=-1;
    _lv=-1;
    _navatarImage=nil;
    [self updateUI];
}
- (void)updateUI{
    
    NSLog(@"=====%@",_userDic);
    
    CGFloat h1=SCREEN_HEIGHT<500 ?568:(SCREEN_HEIGHT<700 ?SCREEN_HEIGHT:700);
    scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
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
    
    _UpView.frame=CGRectMake(0, 0, SCREEN_WIDTH, 700);
    [scroller addSubview:_UpView];
    _image.userInteractionEnabled=YES;
    _detail.layer.masksToBounds=YES;
    _detail.layer.cornerRadius=8;
    _detail.layer.borderWidth=1;
    _detail.layer.borderColor=RGBCOLOR(15, 125, 255).CGColor;
    _image.layer.masksToBounds=YES;
    _image.layer.cornerRadius=8;
    _image.layer.borderWidth=1;
    _image.layer.borderColor=RGBCOLOR(15, 125, 255).CGColor;
    _upBtn.layer.masksToBounds=YES;
    _upBtn.layer.cornerRadius=8;
    
    _upPerson.text=[NSString stringWithFormat:@"上报人:%@",_userDic[@"user_name"]];

        _avatarPicker = [[IHPhotoPicker alloc] initWithRootView:self.view controller:self];
        [_avatarPicker setDelegate:self];
        [_avatarPicker setIsAllowEditing:YES];
        [_avatarPicker setCompressedMaxRadius:SCREEN_WIDTH];
}



- (void)getUploadString{
    [self setDiscrible];
    if (_tim>=0&&_we>=0&_lv>=0) {
        _detail.text=[self getString];
    }
}

- (void)setDiscrible{
    NSArray *disArr=@[@[@"冰雹直径20毫米以上",@"冰雹直径1-20毫米",@"冰雹直径5-10毫米"],
                      @[@"一次过程积雪50厘米以上",@"一次过程积雪30-50厘米",@"一次过程积雪15-30厘米"],
                      @[@"狂风拔起树木",@"烈风小损房屋",@"大风摧毁树枝"],
                      @[@"能见度50米以下",@"能见度50-500米",@"能见度500-1000米"],
                      @[@"雷击距离很近,声音变化很大且声音方向不断变化",@"雷击距离较近,声音较大且声音方向相同",@"雷击距离较远,声音断断续续"]];
    if (_we>=0&_lv>=0) {
        _disLab.text=disArr[_we][_lv];
    }

}


- (NSString *)getString{
    NSArray *timeArr=@[@"10分钟内在",@"30分钟内在"];
    NSArray *weArr=@[@"冰雹",@"暴雪",@"大风",@"大雾",@"雷暴"];
    NSArray *disArr=@[@[@"级别大:冰雹直径20毫米以上",@"级别中:冰雹直径1-20毫米",@"级别小:冰雹直径5-10毫米"],
  @[@"级别大:一次过程积雪50厘米以上",@"级别中:一次过程积雪30-50厘米",@"级别小:一次过程积雪15-30厘米"],
  @[@"级别大:狂风拔起树木",@"级别中:烈风小损房屋",@"级别小:大风摧毁树枝"],
  @[@"级别大:能见度50米以下",@"级别中:能见度50-500米",@"级别小:能见度500-1000米"],
  @[@"级别大:雷击距离很近,声音变化很大且声音方向不断变化",@"级别中:雷击距离较近,声音较大且声音方向相同",@"级别小:雷击距离较远,声音断断续续"]];
    NSString *str=[NSString stringWithFormat:@"%@%@%@发生%@天气,%@",timeArr[_tim],_userDic[@"user_country"],_userDic[@"user_town"],weArr[_we],disArr[_we][_lv]];
    return str;
}



- (IBAction)Choosetime1:(id)sender {
    [self resetTimebtn];
    [_time1 setImage:[UIImage imageNamed:@"btn_sel"] forState:UIControlStateNormal];
    _tim=0;
    [self getUploadString];
}
- (IBAction)Choosetime2:(id)sender {
    [self resetTimebtn];
    [_time2 setImage:[UIImage imageNamed:@"btn_sel"] forState:UIControlStateNormal];
    _tim=1;
    [self getUploadString];

}
- (IBAction)Choosew1:(id)sender {
    [self resetWebtn];
    [_w1 setImage:[UIImage imageNamed:@"btn_sel"] forState:UIControlStateNormal];
    _we=0;
    [self getUploadString];

}
- (IBAction)Choosew2:(id)sender {
    [self resetWebtn];
    [_w2 setImage:[UIImage imageNamed:@"btn_sel"] forState:UIControlStateNormal];
    _we=1;
    [self getUploadString];

}
- (IBAction)Choosew3:(id)sender {
    [self resetWebtn];
    [_w3 setImage:[UIImage imageNamed:@"btn_sel"] forState:UIControlStateNormal];
    _we=2;
    [self getUploadString];

}
- (IBAction)Choosew4:(id)sender {
    [self resetWebtn];
    [_w4 setImage:[UIImage imageNamed:@"btn_sel"] forState:UIControlStateNormal];
    _we=3;
    [self getUploadString];

}
- (IBAction)Choosew5:(id)sender {
    [self resetWebtn];
    [_w5 setImage:[UIImage imageNamed:@"btn_sel"] forState:UIControlStateNormal];
    _we=4;
    [self getUploadString];

}
- (IBAction)Chooselv1:(id)sender {
    [self resetLvbtn];
    [_lv1 setImage:[UIImage imageNamed:@"btn_sel"] forState:UIControlStateNormal];
    _lv=0;
    [self getUploadString];

}
- (IBAction)Chooselv2:(id)sender {
    [self resetLvbtn];
    [_lv2 setImage:[UIImage imageNamed:@"btn_sel"] forState:UIControlStateNormal];
    _lv=1;
    [self getUploadString];

}
- (IBAction)Chooselv3:(id)sender {
    [self resetLvbtn];
    [_lv3 setImage:[UIImage imageNamed:@"btn_sel"] forState:UIControlStateNormal];
    _lv=2;
    [self getUploadString];

}
- (IBAction)ChooseImage:(id)sender {
    
    [_avatarPicker show];
}

- (void)photoPicker:(IHPhotoPicker *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
    [_image setImage:image];
    _navatarImage = image;
}
- (IBAction)upload:(id)sender {
    _upBtn.enabled=NO;
    if (_tim>=0&&_we>=0&_lv>=0&&_navatarImage!=nil) {
        NSData *_data = UIImageJPEGRepresentation(_navatarImage, 1.0f);
        NSString *_encodedImageStr = [_data base64Encoding];
        
        NSArray *weArr=@[@"冰雹",@"暴雪",@"大风",@"大雾",@"雷暴"];
        
        NSString *detStr=[NSString stringWithFormat:@"%@上报人:%@(%@)",_detail.text,_userDic[@"user_name"],_userDic[@"user_phone"]];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:_userDic[@"user_phone"] forKey:@"phone"];
        [dict setObject:weArr[_we] forKey:@"title"];
        [dict setObject:@"video" forKey:@"type"];
        [dict setObject:_encodedImageStr forKey:@"imgfile"];
        [dict setObject:detStr forKey:@"details"];
        
        AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
        manger.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manger POST:SpecialWeather parameters:dict success:^(AFHTTPRequestOperation * operation, id responseObject) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            _upBtn.enabled=YES;

             NSLog(@"乡镇预报——————————%@",dict);
            if ([dict[@"code"] isEqualToString:@"ok"]) {
                [SVProgressHUD showSuccessWithStatus:dict[@"msg"]];
                
                [self.navigationController popViewControllerAnimated:YES];

            }else{
                [SVProgressHUD showErrorWithStatus:dict[@"msg"]];

            }
            
            
            
            
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:error.userInfo[@"NSLocalizedDescription"]];

        }];
        

    }else{
    
        [SVProgressHUD showErrorWithStatus:@"请将内容补充完整！"];
    }
 
    
    
}

- (void)resetTimebtn{
    [_time1 setImage:[UIImage imageNamed:@"btn_no"] forState:UIControlStateNormal];
    [_time2 setImage:[UIImage imageNamed:@"btn_no"] forState:UIControlStateNormal];
}
- (void)resetWebtn{
    [_w1 setImage:[UIImage imageNamed:@"btn_no"] forState:UIControlStateNormal];
    [_w2 setImage:[UIImage imageNamed:@"btn_no"] forState:UIControlStateNormal];
    [_w3 setImage:[UIImage imageNamed:@"btn_no"] forState:UIControlStateNormal];
    [_w4 setImage:[UIImage imageNamed:@"btn_no"] forState:UIControlStateNormal];
    [_w5 setImage:[UIImage imageNamed:@"btn_no"] forState:UIControlStateNormal];
}
- (void)resetLvbtn{
    [_lv1 setImage:[UIImage imageNamed:@"btn_no"] forState:UIControlStateNormal];
    [_lv2 setImage:[UIImage imageNamed:@"btn_no"] forState:UIControlStateNormal];
    [_lv3 setImage:[UIImage imageNamed:@"btn_no"] forState:UIControlStateNormal];
}

- (void)stupNav{
    self.title=@"特殊天气上报";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:18.0]}];
    [self.navigationController.navigationBar setBarTintColor:RGBCOLOR(0, 32, 203)];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

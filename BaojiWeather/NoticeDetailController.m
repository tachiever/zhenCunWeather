//
//  NoticeDetailController.m
//  BaojiWeather
//
//  Created by Tcy on 2017/6/2.
//  Copyright © 2017年 Tcy. All rights reserved.
//

#import "NoticeDetailController.h"

@interface NoticeDetailController ()
@property (weak, nonatomic) IBOutlet UILabel *titLab;
@property (weak, nonatomic) IBOutlet UILabel *pushPer;

@property (nonatomic) UILabel *detaiLab;
@property (nonatomic) UILabel *readPer;
@end

@implementation NoticeDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationController.navigationBar.hidden=NO;

    [self stupNav];
    [self createUI];
    [self downloadData];
    
    
    
}
- (void)downloadData{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:self.notId forKey:@"not_id"];
    [dict setObject:_userInf[@"user_phone"] forKey:@"phone"];
    [dict setObject:_userInf[@"user_name"] forKey:@"name"];
    [dict setObject:_userInf[@"user_city"] forKey:@"city"];
    [dict setObject:_userInf[@"user_country"] forKey:@"country"];
    [dict setObject:_userInf[@"user_town"] forKey:@"town"];
    [dict setObject:@"detail" forKey:@"type"];
    
    [NBRequest postWithURL:NoticeUrl type:RequestRefresh dic:dict success:^(NSData *requestData) {

        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:requestData options:NSJSONReadingMutableContainers error:nil];
        

        NSLog(@"notice Detail—————————%@",dict);
        
        [self updateLabUI:dict[@"list"][0] ];
        
    } failed:^(NSError *error) {
        
    }];


}

-(void)createUI{
    _detaiLab=[[UILabel alloc]initWithFrame:CGRectMake(20, 190, SCREEN_WIDTH-40, 150)];
    _detaiLab.font=[UIFont systemFontOfSize:18];
    _detaiLab.textColor=RGBCOLOR(44, 44, 44);
    _detaiLab.numberOfLines=0;
    _detaiLab.textAlignment=NSTextAlignmentLeft;
    _detaiLab.text=@"";
    [self.view addSubview:_detaiLab];
    //_detaiLab.backgroundColor=[UIColor yellowColor];
    
    
    _readPer=[[UILabel alloc]initWithFrame:CGRectMake(24, 190, SCREEN_WIDTH-48, 150)];
    _readPer.font=[UIFont systemFontOfSize:15];
    _readPer.textColor=RGBCOLOR(54, 54, 54);
    _readPer.numberOfLines=0;
    _readPer.textAlignment=NSTextAlignmentLeft;
    _readPer.text=@"";
    [self.view addSubview:_readPer];
    //_readPer.backgroundColor=[UIColor yellowColor];
    
    

    
}
- (void)updateLabUI:(NSDictionary *)dic{
    
    _titLab.text=dic[@"not_title"];
    _pushPer.text=[NSString stringWithFormat:@"发布人:%@",dic[@"send_name"]];
    _detaiLab.text=[NSString stringWithFormat:@"  %@",dic[@"not_content"]];
    NSString *labelText = _detaiLab.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText attributes:@{NSKernAttributeName:@(2)}];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:3];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    _detaiLab.attributedText = attributedString;
    [_detaiLab sizeToFit];
    
    _readPer.text=[NSString stringWithFormat:@"浏览者: %@",dic[@"readers"]];
    
    _readPer.frame=CGRectMake(24, _detaiLab.frame.origin.y+_detaiLab.frame.size.height+20, SCREEN_WIDTH-48, 30);
    
    NSString *labelText1 = _readPer.text;
    NSMutableAttributedString *attributedString1 = [[NSMutableAttributedString alloc] initWithString:labelText1 attributes:@{NSKernAttributeName:@(1)}];
    NSMutableParagraphStyle *paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:1];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [labelText1 length])];
    _readPer.attributedText = attributedString1;
    [_readPer sizeToFit];
    
}



- (void)stupNav{
    self.title=@"通知详情";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:18.0]}];
    [self.navigationController.navigationBar setBarTintColor:RGBCOLOR(0, 32, 203)];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  SendMessController.m
//  BaojiWeather
//
//  Created by Tcy on 2017/6/19.
//  Copyright © 2017年 Tcy. All rights reserved.
//

#import "SendMessController.h"
#import <MessageUI/MessageUI.h>

@interface SendMessController ()
@property (weak, nonatomic) IBOutlet UILabel *titLab;
@property (weak, nonatomic) IBOutlet UIImageView *detImage;

@end

@implementation SendMessController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationController.navigationBar.hidden=NO;
    [self stupNav];
    CGFloat f=SCREEN_WIDTH>350?(SCREEN_WIDTH>400?23:22):20;
    _titLab.font=[UIFont systemFontOfSize:f];
    
    [self createbtn];

}

- (void)createbtn{
    NSArray *arr=@[@"移动定制",@"电信定制",@"联通定制"];
    for (int i=0; i<3; i++) {
        UIButton * searchBtn=[[UIButton alloc]initWithFrame:CGRectMake(25*Rat+((SCREEN_WIDTH-100*Rat)/3+25*Rat)*i,_detImage.frame.size.height+_detImage.frame.origin.y+60*Rat,(SCREEN_WIDTH-100*Rat)/3,((SCREEN_WIDTH-100*Rat)/3)*0.4)];
        searchBtn.tag=i;
        [searchBtn setTitleColor:RGBACOLOR(254, 254, 254, 1) forState:UIControlStateNormal];
        [searchBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        searchBtn.titleLabel.font=[UIFont systemFontOfSize:15];
        [searchBtn setTitle:arr[i] forState:UIControlStateNormal];
        [searchBtn setBackgroundColor:RGBCOLOR(0, 92, 177)];
        [searchBtn addTarget:self action:@selector(upLoadNotice:) forControlEvents:UIControlEventTouchUpInside];
        searchBtn.layer.masksToBounds=YES;
        searchBtn.layer.cornerRadius=4;
        [self.view addSubview:searchBtn];

    }
}

- (void)upLoadNotice:(UIButton *)btn{
    if (btn.tag==0) {
        [self  showMessageView:@"10620121" mess:@"0917"];
    }
    if (btn.tag==1) {
        [self  showMessageView:@"10620121" mess:@"D0917"];
    }
    if (btn.tag==2) {
        [self  showMessageView:@"10010" mess:@"6363"];
    }


}


- (void)showMessageView:(NSString *)num mess:(NSString *)mess{
    if( [MFMessageComposeViewController canSendText] )
    {
        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc] init]; //autorelease];
        controller.recipients = [NSArray arrayWithObject:num];
        controller.body = mess;
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

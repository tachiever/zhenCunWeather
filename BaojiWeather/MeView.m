//
//  MeView.m
//  BaojiWeather
//
//  Created by Tcy on 2017/6/16.
//  Copyright © 2017年 Tcy. All rights reserved.
//

#import "MeView.h"
#import "MeCell.h"
#import "ExitCell.h"



@interface MeView ()<UITableViewDelegate,UITableViewDataSource>{
    
    UITableView *_tableView;
}
@property (nonatomic ) NSMutableArray *dataArray;
@property (nonatomic ) NSDictionary *userDic;


@end
@implementation MeView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        _dataArray=[[NSMutableArray alloc]init];
        [self createTableView];
           }
    return self;
}
- (void)setInfor:(NSDictionary *)dic{
    _userDic=dic;
    NSString *sttt=_userDic[@"user_phone"];
    NSString *str ;
    if (sttt.length==11) {
       str= [_userDic[@"user_phone"] stringByReplacingCharactersInRange:NSMakeRange(7, 4) withString:@"****"];
    }else{
        str=@"*****";
    }

    NSArray *detArr=@[@[[NSString stringWithFormat:@"账号:%@",str],[NSString stringWithFormat:@"我的姓名:%@",_userDic[@"user_name"]],[NSString stringWithFormat:@"我的地址:%@%@%@",_userDic[@"user_city"],_userDic[@"user_country"],_userDic[@"user_town"]],[NSString stringWithFormat:@"我的职位:%@",_userDic[@"user_post"]],@"xxx"],@[@"QQ群:201088507",@"下载地址:"],@[@"电话预报:0917-12121",@"短信定制(定制后通过短信接收)",@"新浪微博:http://weibo.com/u/1580731447",@"微信订阅:baoji12121"]];
    [_dataArray addObjectsFromArray:detArr];
    [_tableView reloadData];


}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *viw=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    viw.backgroundColor=RGBCOLOR(239, 248, 255);
    return viw;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *viw=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    viw.backgroundColor=RGBCOLOR(239, 248, 255);
    return viw;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 10;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr=_dataArray[section];
    return arr.count;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0&&indexPath.row==4) {
        [self existApp];
    }
    if (indexPath.section==2&&indexPath.row==1) {
        if (_actionShowMessPage) {
            _actionShowMessPage();
        }
    }
    if (indexPath.section==1&&indexPath.row==0) {
        if (![TencentOAuth iphoneQQInstalled]) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还没有安装QQ客户端" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
            [alert show];
            
        }else {
            [self joinGroup:nil key:nil];}
    }
}
- (void)createTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.frame.size.height) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.backgroundColor=RGBCOLOR(239, 248, 255);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:_tableView];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];//纯代码定制cell
    [_tableView registerNib:[UINib nibWithNibName:@"MeCell" bundle:nil] forCellReuseIdentifier:@"MeCell"];//xib定制cell
    [_tableView registerNib:[UINib nibWithNibName:@"ExitCell" bundle:nil] forCellReuseIdentifier:@"ExitCell"];//xib定制cell
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *imageArr=@[@[@"111",@"222",@"333",@"444",@""],@[@"555",@"444"],@[@"777",@"888",@"999",@"000"]];
    

    if (indexPath.section==0&&indexPath.row==4) {
        ExitCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ExitCell"];

        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        return cell;
    }else{
    
        MeCell *cell=[tableView dequeueReusableCellWithIdentifier:@"MeCell"];
        
        if (indexPath.section==0||(indexPath.section==2&&indexPath.row==3)) {
            cell.rigBtn.hidden=YES;
        }
        if (indexPath.section==2&&indexPath.row==4) {
            cell.line.hidden=YES;
        }
        
        [cell.iconImage setImage:[UIImage imageNamed:imageArr[indexPath.section][indexPath.row]]];
        cell.detailText.text=_dataArray[indexPath.section][indexPath.row];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        return cell;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0&&indexPath.row==4) {
        CGFloat f= SCREEN_HEIGHT>700?(SCREEN_HEIGHT>600?45:45):40;
        
        return f;
    }else{
        CGFloat f= SCREEN_HEIGHT>700?(SCREEN_HEIGHT>600?53:50):45;
        
        return f;
    }

}

- (BOOL)joinGroup:(NSString *)groupUin key:(NSString *)key{
    NSString *urlStr = [NSString stringWithFormat:@"mqqapi://card/show_pslcard?src_type=internal&version=1&uin=%@&key=%@&card_type=group&source=external", @"369081985",@"5bb5ba7d391954b6c98336afa753693639686876ac2d29329bd1891dd41b641c"];
    NSURL *url = [NSURL URLWithString:urlStr];
    if([[UIApplication sharedApplication] canOpenURL:url]){
        [[UIApplication sharedApplication] openURL:url];
        return YES;
    }
    else return NO;
}



- (void)existApp{
    
    [[DataDefault shareInstance]setUserPhone:nil];

    
    [UIView beginAnimations:@"exitApplication" context:nil];
    
    [UIView setAnimationDuration:0.5];
    
    [UIView setAnimationDelegate:self];
    
    [UIView setAnimationTransition:UIViewAnimationCurveEaseOut forView:self.window cache:NO];
    
    [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
    
    
    self.window.bounds = CGRectMake(0, 0, 0, 0);
    
    [UIView commitAnimations];
}
- (void)animationFinished:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    
    if ([animationID compare:@"exitApplication"] == 0) {
        
        exit(0);
        
    }
}



- (void)updateHighWithFrame{
    CGRect frame0=CGRectMake(0, 0, SCREEN_WIDTH, self.frame.size.height);
    [UIView animateWithDuration:0.3 animations:^{
        _tableView.frame=frame0;
    }];
}
@end
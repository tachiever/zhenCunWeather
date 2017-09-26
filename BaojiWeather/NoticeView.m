//
//  NoticeView.m
//  BaojiWeather
//
//  Created by Tcy on 2017/6/1.
//  Copyright © 2017年 Tcy. All rights reserved.
//

#import "NoticeView.h"
#import "NoticeModel.h"
#import "NoticeCell.h"

@interface NoticeView ()<UITableViewDelegate,UITableViewDataSource>{
    
    UITableView *_tableView;
    UIButton * searchBtn;
}
@property (nonatomic, assign) NBRequestType requestType;
@property (nonatomic )NSMutableArray *dataArray;
@property (nonatomic) NSDictionary *userDic;
@property (nonatomic) NSString  *num;
@property (nonatomic) NSString *tonum;
@property (nonatomic) BOOL isrefresh;

@end
@implementation NoticeView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        _dataArray=[[NSMutableArray alloc]init];
        _requestType=RequestRefresh;
        _isrefresh=YES;

        [self createTableView];
        _num=@"0";
        _tonum=@"10";
    }
    return self;
}

- (void)refreshData{

    [self loadNewData];

}


- (void)downloadDataWith:(NSDictionary *)dic{
    _userDic=dic;
    
   // NSLog(@"---------%@%@",_num,_tonum);
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:_num forKey:@"num"];
    [dict setObject:_tonum forKey:@"tonum"];
    [dict setObject:dic[@"user_phone"] forKey:@"phone"];
    [dict setObject:dic[@"user_town"] forKey:@"town"];
    [dict setObject:@"list" forKey:@"type"];
    
    [NBRequest postWithURL:NoticeUrl type:_requestType dic:dict success:^(NSData *requestData) {
        if (    _isrefresh) {
            [_dataArray removeAllObjects];
        }
        [_tableView headerEndRefreshing];
        
        //  NSArray *array = [NSJSONSerialization JSONObjectWithData:requestData options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:requestData options:NSJSONReadingMutableContainers error:nil];
        _requestType=RequestRefresh;
        
        NSArray *arr=dict[@"list"];
        
        for (NSDictionary *dic in arr) {
            NoticeModel *model=[[NoticeModel alloc]init];
            
            [model setValuesForKeysWithDictionary:dic];
            [_dataArray addObject:model];
        }
        //NSLog(@"预警——————————%@",dict);
        
        [_tableView reloadData];
        [_tableView headerEndRefreshing];
        [_tableView footerEndRefreshing];

    } failed:^(NSError *error) {
        [_tableView headerEndRefreshing];
        [_tableView footerEndRefreshing];

    }];
}
- (void)loadNewData{
    _isrefresh=YES;
    _num=@"0";
    _tonum=@"10";
    _requestType=RequestRefresh;
    
    [self downloadDataWith:_userDic];
    
}
- (void)loadMoreData{
    _isrefresh=NO;

    NSString *st=[NSString stringWithFormat:@"%@",_tonum];
    _num=[NSString stringWithFormat:@"%d",[st intValue]+1];
    _tonum=[NSString stringWithFormat:@"%d",[_num intValue]+10];
    _requestType=RequestRefresh;
    [self downloadDataWith:_userDic];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.00001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.0001;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArray.count;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NoticeModel *model=_dataArray[indexPath.row];
    [model setSteaue:@"1"];
    [_dataArray replaceObjectAtIndex:indexPath.row withObject:model];

    [_tableView reloadData];
    if (self.actionShowDetail) {
        self.actionShowDetail(model.not_id);
    }
}




- (void)createTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.frame.size.height-80*Rat) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.backgroundColor=[UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:_tableView];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];//纯代码定制cell
    [_tableView registerNib:[UINib nibWithNibName:@"NoticeCell" bundle:nil] forCellReuseIdentifier:@"NoticeCell"];//xib定制cell
    
    [_tableView addHeaderWithTarget:self action:@selector(loadNewData) dateKey:@"refresh"];
    [_tableView setHeaderRefreshingText:@"正在刷新..."];
    [_tableView addFooterWithTarget:self action:@selector(loadMoreData)];
    
    [_tableView setFooterRefreshingText:@"正在加载..."];
    
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:40/255.0 green:29/255.0  blue:214/255.0  alpha:1].CGColor, (__bridge id)[UIColor colorWithRed:35/255.0 green:75/255.0  blue:223/255.0  alpha:1].CGColor, (__bridge id)[UIColor colorWithRed:26/255.0 green:128/255.0  blue:237/255.0  alpha:1].CGColor];
    //    gradientLayer.colors = @[(__bridge id)[UIColor redColor].CGColor, (__bridge id)[UIColor yellowColor].CGColor, (__bridge id)[UIColor blueColor].CGColor];
    //    gradientLayer.locations = @[@0.3, @0.5, @1.0];
    gradientLayer.locations = @[@0.2, @0.5,@0.8];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1.0, 0);
    gradientLayer.frame =CGRectMake(0, 0, SCREEN_WIDTH-80*Rat, 52*Rat);
    
    searchBtn=[[UIButton alloc]initWithFrame:CGRectMake(40*Rat, self.frame.size.height-66*Rat, SCREEN_WIDTH-80*Rat, 52*Rat)];
    
    searchBtn.layer.masksToBounds=YES;
    searchBtn.layer.cornerRadius=6;
    [searchBtn.layer addSublayer:gradientLayer];
    [searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [searchBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    searchBtn.titleLabel.font=[UIFont systemFontOfSize:18];
    [searchBtn setTitle:@"发 布 新 通 知" forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(upLoadNotice) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:searchBtn];
    
}
- (void)upLoadNotice{
    if (_actionPushNotice) {
        _actionPushNotice();
    }
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    NoticeCell *cell=[tableView dequeueReusableCellWithIdentifier:@"NoticeCell"];
    
    CGFloat f= (SCREEN_HEIGHT>600? 17 :14);
    
    NoticeModel *model=_dataArray[indexPath.row];
    [cell setDataWith:model];
    cell.textLabel.textColor=[UIColor whiteColor];
    cell.textLabel.font=[UIFont systemFontOfSize:f];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}


- (void)updateHighWithFrame{
    CGRect frame0=CGRectMake(0, 0, SCREEN_WIDTH, self.frame.size.height-80*Rat);
    CGRect frame1=CGRectMake(40*Rat, self.frame.size.height-66*Rat, SCREEN_WIDTH-80*Rat, 52*Rat);
    
    
    [UIView animateWithDuration:0.3 animations:^{
        _tableView.frame=frame0;
        searchBtn.frame=frame1;
    }];
}
@end

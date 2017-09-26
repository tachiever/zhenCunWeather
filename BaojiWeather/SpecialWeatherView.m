//
//  SpecialWeatherView.m
//  BaojiWeather
//
//  Created by Tcy on 2017/6/13.
//  Copyright © 2017年 Tcy. All rights reserved.
//

#import "SpecialWeatherView.h"
#import "SpecialWeatherCell.h"
@interface SpecialWeatherView ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
    
    UITableView *_tableView;
    UITextField *seaField;
    UIButton *surBtn;
}
@property (nonatomic ) NSMutableArray *dataArray;
@property (nonatomic ) NSMutableArray *dataArray0;


@property (nonatomic ) NSDictionary *userDic;
@property (nonatomic ) NSString  *num;
@property (nonatomic ) NSString *tonum;
@property (nonatomic ) NSInteger project;

@property (nonatomic) BOOL isrefresh;

@end
@implementation SpecialWeatherView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        _dataArray=[[NSMutableArray alloc]init];
        _dataArray0=[[NSMutableArray alloc]init];
        _isrefresh=YES;
        _project=1;
        [self createTableView];
        _num=@"0";
        _tonum=@"10";
    }
    return self;
}

- (void)downloadDataWith:(NSDictionary *)dic{
    _userDic=dic;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:_num forKey:@"num"];
    [dict setObject:_tonum forKey:@"tonum"];
    [dict setObject:@"list" forKey:@"type"];
    [dict setObject:dic[@"user_country"] forKey:@"position"];
    
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manger POST:SpecialWeather parameters:dict success:^(AFHTTPRequestOperation * operation, id responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if (_isrefresh) {
                [_dataArray removeAllObjects];
        }
        _isrefresh=YES;
        if (![dict isEqual:[NSNull null]]) {
            
            // NSLog(@"乡镇预报——————————%@",dict);

                NSArray *arr=dict[@"list"];
                for (NSDictionary *dic in arr) {
                    [_dataArray addObject:dic];
                }
        }
        [_tableView reloadData];
        [_tableView headerEndRefreshing];
        [_tableView footerEndRefreshing];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [_tableView headerEndRefreshing];
        [_tableView footerEndRefreshing];
        [SVProgressHUD showErrorWithStatus:error.userInfo[@"NSLocalizedDescription"]];

    }];
    
}
- (void)loadNewData{
    _isrefresh=YES;
    _num=@"0";
    _tonum=@"10";
    if (_project==0) {
        [self loadSearchData:_userDic KeyWords:seaField.text];
        
    }else{
        [self downloadDataWith:_userDic];
        
    }
}
- (void)loadMoreData{
    if (_project==1) {
        _isrefresh=NO;
        NSString *st=[NSString stringWithFormat:@"%@",_tonum];
        _num=[NSString stringWithFormat:@"%d",[st intValue]+1];
        _tonum=[NSString stringWithFormat:@"%d",[st intValue]+10];

            [self downloadDataWith:_userDic];
        }

    if (_project==0) {
        _isrefresh=YES;

        [self loadSearchData:_userDic KeyWords:seaField.text];
        
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.00080;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.0001;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_project==0) {
        return _dataArray0.count;
        
    }
    if (_project==1) {
        return _dataArray.count;
        
    }else   {
        return _dataArray.count;
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{


//    if (self.actionDataDetail) {
//        self.actionDataDetail(model.id);
//    }
}




- (void)createTableView{
    UIView *seaeView=[[UIView alloc]initWithFrame:CGRectMake(-1, -1, SCREEN_WIDTH+2, 51)];
    seaeView.backgroundColor=[UIColor whiteColor];
    seaeView.layer.borderWidth=1;
    seaeView.layer.borderColor=[UIColor grayColor].CGColor;
    [self addSubview:seaeView];
    
    seaField=[[UITextField alloc]initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-80, 30)];
    seaField.borderStyle=UITextBorderStyleRoundedRect;
    seaField.delegate=self;
    seaField.placeholder=@"请输入关键字";
    seaField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;  //垂直居中
    [seaField setValue:[UIColor colorWithRed:111/255.0 green:111/255.0 blue:133/255.0 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    [seaField setValue:[UIFont systemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    seaField.keyboardType=UIKeyboardTypeDefault;
    seaField.returnKeyType=UIReturnKeySearch;
    seaField.textColor=RGBACOLOR(4, 40, 4,0.9);
    seaField.font = [UIFont fontWithName:@"ArialMT" size:15];
    seaField.clearButtonMode=UITextFieldViewModeWhileEditing;
    [seaeView addSubview:seaField];
    
    surBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    surBtn.frame=CGRectMake(SCREEN_WIDTH-60,11,50, 28);
    surBtn.backgroundColor=[UIColor blueColor];
    surBtn.titleLabel.font=[UIFont systemFontOfSize:16];
    surBtn.layer.masksToBounds=YES;
    surBtn.layer.cornerRadius=3;
    [surBtn setTitle:@"上报" forState:UIControlStateNormal];
    [surBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [surBtn addTarget:self action:@selector(search:) forControlEvents:UIControlEventTouchUpInside];
    [seaeView addSubview:surBtn];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, self.frame.size.height-50) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.backgroundColor=[UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self addSubview:_tableView];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];//纯代码定制cell
    [_tableView registerNib:[UINib nibWithNibName:@"SpecialWeatherCell" bundle:nil] forCellReuseIdentifier:@"SpecialWeatherCell"];//xib定制cell
    
    [_tableView addHeaderWithTarget:self action:@selector(loadNewData) dateKey:@"refresh"];
    [_tableView setHeaderRefreshingText:@"正在刷新..."];
    [_tableView addFooterWithTarget:self action:@selector(loadMoreData)];
    [_tableView setFooterRefreshingText:@"正在加载..."];
    
}

- (void)search:(UIButton *)btn{
    
    [seaField resignFirstResponder];
    if ([btn.titleLabel.text isEqualToString:@"上报"]) {
        
        if (_actionUploadeNotice) {
            _actionUploadeNotice();
        }
    }
    if ([btn.titleLabel.text isEqualToString:@"取消"]) {
        [surBtn setTitle:@"上报" forState:UIControlStateNormal];
        _project=1;
        seaField.text=nil;
        seaField.placeholder=@"请输入搜索内容";
        if (_dataArray.count<1) {
            [self downloadDataWith:_userDic];
            
        }
        [_tableView reloadData];
    }

    

}
-(void)loadSearchData:(NSDictionary *)dic KeyWords:(NSString *)ky{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    [dict setObject:@"search" forKey:@"type"];
    [dict setObject:dic[@"user_country"] forKey:@"position"];
    [dict setObject:ky forKey:@"keyword"];
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manger POST:SpecialWeather parameters:dict success:^(AFHTTPRequestOperation * operation, id responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if (_isrefresh) {
            [_dataArray0 removeAllObjects];
            
        }
        _isrefresh=YES;
        if (![dict isEqual:[NSNull null]]) {
            NSArray *arr=dict[@"list"];
            for (NSDictionary *dic in arr) {
                [_dataArray0 addObject:dic];
            }
        }
        
        [_tableView reloadData];
        [_tableView headerEndRefreshing];
        [_tableView footerEndRefreshing];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [_tableView headerEndRefreshing];
        [_tableView footerEndRefreshing];
        [SVProgressHUD showErrorWithStatus:error.userInfo[@"NSLocalizedDescription"]];

    }];
    
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SpecialWeatherCell *cell=[tableView dequeueReusableCellWithIdentifier:@"SpecialWeatherCell"];
    NSDictionary *model;
    if (_project==0) {
        model=_dataArray0[indexPath.row];
        
    }
    if (_project==1) {
        model=_dataArray[indexPath.row];
        
    }
    [cell setDataWithDic:model];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 170;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    [surBtn setTitle:@"取消" forState:UIControlStateNormal];
    _project=0;
    return YES;
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [seaField resignFirstResponder];
    [self loadSearchData:_userDic KeyWords:seaField.text];

    return YES;
}


- (void)updateHighWithFrame{
    CGRect frame0=CGRectMake(0, 50, SCREEN_WIDTH, self.frame.size.height-50);
    [UIView animateWithDuration:0.3 animations:^{
        _tableView.frame=frame0;
    }];
}
@end

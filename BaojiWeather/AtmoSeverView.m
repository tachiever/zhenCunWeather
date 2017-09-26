//
//  AtmoSeverView.m
//  BaojiWeather
//
//  Created by Tcy on 2017/6/6.
//  Copyright © 2017年 Tcy. All rights reserved.
//

#import "AtmoSeverView.h"
#import "AtmoViewCell.h"

#import "AtmoModel.h"

@interface AtmoSeverView ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
    
    UITableView *_tableView;
    UIView *_signView;
    UITextField *seaField;
    //   UIButton * searchBtn;
}
@property (nonatomic ) NSMutableArray *staArray;
@property (nonatomic ) NSMutableArray *dataArray;
@property (nonatomic ) NSMutableArray *dataArray0;
@property (nonatomic ) NSMutableArray *dataArray1;
@property (nonatomic ) NSMutableArray *dataArray2;
@property (nonatomic ) NSMutableArray *dataArray3;
@property (nonatomic ) NSMutableArray *dataArray4;
@property (nonatomic ) NSDictionary *userDic;
@property (nonatomic ) NSString  *num;
@property (nonatomic ) NSString *tonum;
@property (nonatomic ) NSInteger project;

@property (nonatomic) BOOL isrefresh;

@end
@implementation AtmoSeverView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=RGBCOLOR(0, 32, 203);
        _dataArray=[[NSMutableArray alloc]init];
        _dataArray0=[[NSMutableArray alloc]init];
        _dataArray1=[[NSMutableArray alloc]init];
        _dataArray2=[[NSMutableArray alloc]init];
        _dataArray3=[[NSMutableArray alloc]init];
        _dataArray4=[[NSMutableArray alloc]init];
        _staArray=[[NSMutableArray alloc]init];
        
        for (int i=0; i<6; i++) {
            NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
            [dic setValue:@"0" forKey:@"num"];
            [dic setValue:@"10" forKey:@"tonum"];
            [_staArray addObject:dic];
        }
        _isrefresh=YES;
        _project=0;
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
    
    NSMutableDictionary *diction=_staArray[_project];
    
    NSArray *tyarray=@[@"决策",@"农业气象",@"旅游",@"环境",@"森林防火"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:diction[@"num"] forKey:@"num"];
    [dict setObject:diction[@"tonum"] forKey:@"tonum"];
    [dict setObject:@"气象服务" forKey:@"product_type"];
    [dict setObject:dic[@"user_city"] forKey:@"site_name"];
    [dict setObject:@"" forKey:@"keyword"];
    [dict setObject:tyarray[_project] forKey:@"type"];
    
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manger POST:AtmoSever parameters:dict success:^(AFHTTPRequestOperation * operation, id responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if (_isrefresh) {
            
            if (_project==0) {
                [_dataArray0 removeAllObjects];
            }
            if (_project==1) {
                [_dataArray1 removeAllObjects];
            }
            if (_project==2) {
                [_dataArray2 removeAllObjects];
            }
            if (_project==3) {
                [_dataArray3 removeAllObjects];
            }
            if (_project==4) {
                [_dataArray4 removeAllObjects];
            }
        }
        _isrefresh=YES;
        if (![dict isEqual:[NSNull null]]) {
            
           // NSLog(@"乡镇预报——————————%@",dict);
           // NSLog(@"ppppppppppp%ld",(long)_project);
            if (_project==0) {
                NSArray *arr=dict[@"list"];
                for (NSDictionary *dic in arr) {
                    AtmoModel *model=[[AtmoModel alloc]init];
                    [model setValuesForKeysWithDictionary:dic];
                    [_dataArray0 addObject:model];
                }
            }
            if (_project==1) {
                NSArray *arr=dict[@"list"];
                for (NSDictionary *dic in arr) {
                    AtmoModel *model=[[AtmoModel alloc]init];
                    [model setValuesForKeysWithDictionary:dic];
                    [_dataArray1 addObject:model];
                }            }
            if (_project==2) {
                NSArray *arr=dict[@"list"];
                for (NSDictionary *dic in arr) {
                    AtmoModel *model=[[AtmoModel alloc]init];
                    [model setValuesForKeysWithDictionary:dic];
                    [_dataArray2 addObject:model];
                }            }
            if (_project==3) {
                NSArray *arr=dict[@"list"];
                for (NSDictionary *dic in arr) {
                    AtmoModel *model=[[AtmoModel alloc]init];
                    [model setValuesForKeysWithDictionary:dic];
                    [_dataArray3 addObject:model];
                }            }
            if (_project==4) {
                NSArray *arr=dict[@"list"];
                for (NSDictionary *dic in arr) {
                    AtmoModel *model=[[AtmoModel alloc]init];
                    [model setValuesForKeysWithDictionary:dic];
                    [_dataArray4 addObject:model];
                }            }

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
    
    NSMutableDictionary *dic=_staArray[_project];

    [dic setValue:_num forKey:@"num"];
    [dic setValue:_tonum forKey:@"tonum"];
    
    [_staArray replaceObjectAtIndex:_project withObject:dic];
    
    if (_project==5) {
        [self loadSearchData:_userDic KeyWords:seaField.text];
        
    }else{
        
        [self downloadDataWith:_userDic];
        
    }
}
- (void)loadMoreData{
    _isrefresh=NO;
    
    NSMutableDictionary *dic=_staArray[_project];
    
    NSString *st=[NSString stringWithFormat:@"%@",dic[@"tonum"]];
    _num=[NSString stringWithFormat:@"%d",[st intValue]+1];
    _tonum=[NSString stringWithFormat:@"%d",[st intValue]+10];
    
    [dic setValue:_num forKey:@"num"];
    [dic setValue:_tonum forKey:@"tonum"];
    
    [_staArray replaceObjectAtIndex:_project withObject:dic];
    if (_project==5) {
        [self loadSearchData:_userDic KeyWords:seaField.text];

    }else{
    
        [self downloadDataWith:_userDic];

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
        return _dataArray1.count;
  
    }
    if (_project==2) {
        return _dataArray2.count;
 
    }
    if (_project==3) {
        return _dataArray3.count;
        
    }
    if (_project==4) {
        return _dataArray4.count;
        
    }
    if (_project==5) {
        return _dataArray.count;
        
    }else   {
        return _dataArray0.count;

    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AtmoModel *model;
    if (_project==0) {
        model=_dataArray0[indexPath.row];
        
    }
    if (_project==1) {
        model=_dataArray1[indexPath.row];
        
    }
    if (_project==2) {
        model=_dataArray2[indexPath.row];
        
    }
    if (_project==3) {
        model=_dataArray3[indexPath.row];
        
    }
    if (_project==4) {
        model=_dataArray4[indexPath.row];
        
    }
    if (_project==5) {
        model=_dataArray[indexPath.row];
        
    }
        if (self.actionDataDetail) {
            self.actionDataDetail(model.id);
        }
}




- (void)createTableView{
    
    NSArray *arr=@[@"决策",@"农业气象",@"旅游",@"环境",@"森林防火"];
    for (int i=0; i<arr.count; i++) {
        UIButton * searchBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width/5*i,0,self.frame.size.width/5,39)];
        searchBtn.tag=i;
        [searchBtn setTitleColor:RGBACOLOR(24, 24, 24, 0.9) forState:UIControlStateNormal];
        [searchBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        searchBtn.titleLabel.font=[UIFont systemFontOfSize:15];
        [searchBtn setTitle:arr[i] forState:UIControlStateNormal];
        [searchBtn setBackgroundColor:RGBCOLOR(193, 218, 249)];
        [searchBtn addTarget:self action:@selector(upLoadNotice:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:searchBtn];
    }
    _signView=[[UIView alloc]initWithFrame:CGRectMake(0, 37, self.frame.size.width/5, 3)];
    _signView.backgroundColor=RGBACOLOR(0, 181, 233, 0.9);
    [self addSubview:_signView];
    
    
    UIView *seaeView=[[UIView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 50)];
    seaeView.backgroundColor=[UIColor whiteColor];
    [self addSubview:seaeView];
    
    seaField=[[UITextField alloc]initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-60, 30)];
    seaField.borderStyle=UITextBorderStyleRoundedRect;
    seaField.delegate=self;
    seaField.placeholder=@"请输入搜索内容";
    [seaField setValue:[UIColor colorWithRed:111/255.0 green:111/255.0 blue:133/255.0 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    [seaField setValue:[UIFont systemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    seaField.keyboardType=UIKeyboardTypeDefault;
    seaField.textColor=RGBACOLOR(4, 40, 4,0.9);
    seaField.font = [UIFont fontWithName:@"ArialMT" size:15];
    seaField.clearButtonMode=UITextFieldViewModeWhileEditing;
    [seaeView addSubview:seaField];
    
    UIButton *surBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    surBtn.frame=CGRectMake(SCREEN_WIDTH-40,10,30, 30);
    
    [surBtn setImage:[UIImage imageNamed:@"searchBg"] forState:UIControlStateNormal];
    [surBtn addTarget:self action:@selector(search:) forControlEvents:UIControlEventTouchUpInside];
    [seaeView addSubview:surBtn];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 90, SCREEN_WIDTH, self.frame.size.height-90) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.backgroundColor=[UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self addSubview:_tableView];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];//纯代码定制cell
    [_tableView registerNib:[UINib nibWithNibName:@"AtmoViewCell" bundle:nil] forCellReuseIdentifier:@"AtmoViewCell"];//xib定制cell
    
    [_tableView addHeaderWithTarget:self action:@selector(loadNewData) dateKey:@"refresh"];
    [_tableView setHeaderRefreshingText:@"正在刷新..."];
    [_tableView addFooterWithTarget:self action:@selector(loadMoreData)];
    
    [_tableView setFooterRefreshingText:@"正在加载..."];
    
}

- (void)search:(UIButton *)btn{

    [seaField resignFirstResponder];
    _project=5;

    if (seaField.text.length>0) {
        [self loadSearchData:_userDic KeyWords:seaField.text];
    }
}

-(void)loadSearchData:(NSDictionary *)dic KeyWords:(NSString *)ky{
    NSMutableDictionary *diction=_staArray[_project];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:diction[@"num"] forKey:@"num"];
    [dict setObject:diction[@"tonum"] forKey:@"tonum"];
    [dict setObject:@"气象服务" forKey:@"product_type"];
    [dict setObject:dic[@"user_city"] forKey:@"site_name"];
    [dict setObject:ky forKey:@"keyword"];
    [dict setObject:@"决策" forKey:@"type"];
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manger POST:AtmoSever parameters:dict success:^(AFHTTPRequestOperation * operation, id responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if (_isrefresh) {
            [_dataArray removeAllObjects];
            
        }
        _isrefresh=YES;
        if (![dict isEqual:[NSNull null]]) {
            NSArray *arr=dict[@"list"];
            for (NSDictionary *dic in arr) {
                AtmoModel *model=[[AtmoModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [_dataArray addObject:model];
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
- (void)upLoadNotice:(UIButton *)btn{
    [self signViewMove:btn.tag];
    seaField.text=nil;
    seaField.placeholder=@"请输入搜索内容";
    if (btn.tag!=_project) {
        _project=btn.tag;
        
        if (_project==0) {
            if (_dataArray0.count<1) {
                [self downloadDataWith:_userDic];
                
            }
        }
        if (_project==1) {
            if (_dataArray1.count<1) {
                [self downloadDataWith:_userDic];
                
            }
        }
        if (_project==2) {
            if (_dataArray2.count<1) {
                [self downloadDataWith:_userDic];
                
            }
        }
        if (_project==3) {
            if (_dataArray3.count<1) {
                [self downloadDataWith:_userDic];
                
            }
        }
        if (_project==4) {
            if (_dataArray4.count<1) {
                [self downloadDataWith:_userDic];
                
            }
        }
        
        [_tableView reloadData];
        

    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    AtmoViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"AtmoViewCell"];
    //
    CGFloat f= (SCREEN_HEIGHT>600? 17 :15);
    AtmoModel *model;
    if (_project==0) {
        model=_dataArray0[indexPath.row];
        
    }
    if (_project==1) {
        model=_dataArray1[indexPath.row];
        
    }
    if (_project==2) {
        model=_dataArray2[indexPath.row];
        
    }
    if (_project==3) {
        model=_dataArray3[indexPath.row];
        
    }
    if (_project==4) {
        model=_dataArray4[indexPath.row];
        
    }
    if (_project==5) {
        model=_dataArray[indexPath.row];
        
    }
    
    [cell setData:model];
    cell.titLab.textColor=[UIColor blackColor];
    cell.dateLab.textColor=[UIColor blackColor];
    cell.textLabel.font=[UIFont systemFontOfSize:f];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [seaField resignFirstResponder];
    return YES;
}

- (void)signViewMove:(NSInteger)inte{
    CGRect fram= CGRectMake(self.frame.size.width/5*inte, 37, self.frame.size.width/5, 3);
    [UIView animateWithDuration:0.2 animations:^(void){
        _signView.frame=fram;
    }completion:^(BOOL finished) {
        
    }];
}

- (void)updateHighWithFrame{
    CGRect frame0=CGRectMake(0, 90, SCREEN_WIDTH, self.frame.size.height-90);
    [UIView animateWithDuration:0.3 animations:^{
        _tableView.frame=frame0;
    }];
}
@end

//
//  SincePointView.m
//  BaojiWeather
//
//  Created by Tcy on 2017/6/9.
//  Copyright © 2017年 Tcy. All rights reserved.
//

#import "SincePointView.h"

#import "SinceCell.h"

@interface SincePointView ()<UITableViewDelegate,UITableViewDataSource>{
    
    UITableView *_tableView;
    UIView *ChooseView;
}
@property (nonatomic ) UIButton *locaBtn;
@property (nonatomic ) UIButton *otherBtn;

@property (nonatomic ) NSMutableArray *staArray;
@property (nonatomic ) NSMutableArray *dataArray0;
@property (nonatomic ) NSMutableArray *dataArray1;
@property (nonatomic ) NSDictionary *userDic;
@property (nonatomic ) NSInteger pro;
@property (nonatomic) BOOL isrefresh;

@end
@implementation SincePointView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=RGBCOLOR(0, 32, 203);
        _dataArray0=[[NSMutableArray alloc]init];
        _dataArray1=[[NSMutableArray alloc]init];
        _staArray=[[NSMutableArray alloc]init];
        [self createTableView];
        _pro=0;
        for (int i=0; i<2; i++) {
            NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
            [dic setValue:@"0" forKey:@"num"];
            [dic setValue:@"10" forKey:@"tonum"];
            [_staArray addObject:dic];
        }
        _isrefresh=YES;
    }
    return self;
}

- (void)refreshData{
    
    [self loadNewData];
    
}

- (void)downloadDataWith:(NSDictionary *)dic{
    _userDic=dic;
    NSLog(@"%@",dic);
    NSArray *arr=@[@"local",@"other"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:arr[_pro] forKey:@"siteType"];
    [dict setObject:dic[@"user_country"] forKey:@"position"];
    [dict setObject:_staArray[_pro][@"num"] forKey:@"num"];
    [dict setObject:_staArray[_pro][@"tonum"] forKey:@"tonum"];
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manger POST:SinceUrl parameters:dict success:^(AFHTTPRequestOperation * operation, id responseObject) {
        if (    _isrefresh) {
            if (_pro==0) {
                [_dataArray0 removeAllObjects];
            }
            if (_pro==1) {
                [_dataArray1 removeAllObjects];

            }
        }
        
        _isrefresh=YES;

        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"-----d--d-d-d-d-----%@",dict);
        NSArray *arr=dict[@"list"];
        
        if (_pro==0) {
            [_dataArray0 addObjectsFromArray:arr];
        }
        if (_pro==1) {
            [_dataArray1 addObjectsFromArray:arr];

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
    
    NSMutableDictionary *dic=_staArray[_pro];
    
    [dic setValue:@"0" forKey:@"num"];
    [dic setValue:@"10" forKey:@"tonum"];
    
    [_staArray replaceObjectAtIndex:_pro withObject:dic];
    
    [self downloadDataWith:_userDic];

}
- (void)loadMoreData{
    _isrefresh=NO;
    NSMutableDictionary *dic=_staArray[_pro];
    NSString *st=[NSString stringWithFormat:@"%@",dic[@"tonum"]];
    [dic setValue:[NSString stringWithFormat:@"%d",[st intValue]+1] forKey:@"num"];
    [dic setValue:[NSString stringWithFormat:@"%d",[st intValue]+10] forKey:@"tonum"];
    [_staArray replaceObjectAtIndex:_pro withObject:dic];
    [self downloadDataWith:_userDic];

}

- (void)chooseLoca:(UIButton *)btn{

    if (btn.tag!=_pro) {
        _pro=btn.tag;
        NSLog(@"%d",_pro);

        if (_pro==0) {
            [_locaBtn setBackgroundColor:RGBCOLOR(0, 32, 203)];
            [_otherBtn setBackgroundColor:RGBCOLOR(193, 218, 249)];
            if (_dataArray0.count<1) {
                [self downloadDataWith:_userDic];
                
            }
        }
        if (_pro==1) {
            [_otherBtn setBackgroundColor:RGBCOLOR(0, 32, 203)];
            [_locaBtn setBackgroundColor:RGBCOLOR(193, 218, 249)];
            if (_dataArray1.count<1) {
                [self downloadDataWith:_userDic];
                
            }
        }
        [_tableView reloadData];
        
        
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
    if (_pro==0) {
        return  _dataArray0.count;
    }
    if (_pro==1) {
        return  _dataArray1.count;
    }else{
        return  _dataArray0.count;
    }
    
   // return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (void)createTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.frame.size.height-50) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.showsVerticalScrollIndicator=NO;
   // _tableView.backgroundColor=RGBCOLOR(193, 218, 249);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:_tableView];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];//纯代码定制cell
    [_tableView registerNib:[UINib nibWithNibName:@"SinceCell" bundle:nil] forCellReuseIdentifier:@"SinceCell"];//xib定制cell
    [_tableView addHeaderWithTarget:self action:@selector(loadNewData) dateKey:@"refresh"];
    [_tableView setHeaderRefreshingText:@"正在刷新..."];
    [_tableView addFooterWithTarget:self action:@selector(loadMoreData)];
    
    [_tableView setFooterRefreshingText:@"正在加载..."];
    
    
    ChooseView=[[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-50, SCREEN_WIDTH, 50)];
    ChooseView.backgroundColor=[UIColor whiteColor];
    [self addSubview: ChooseView];
    
    
    _locaBtn=[[UIButton alloc]initWithFrame:CGRectMake(0,0,self.frame.size.width/2,50)];
    _locaBtn.tag=0;
    [_locaBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_locaBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    _locaBtn.titleLabel.font=[UIFont systemFontOfSize:16];
    [_locaBtn setTitle:@"本地景点" forState:UIControlStateNormal];
    [_locaBtn setBackgroundColor:RGBCOLOR(0, 32, 203)];
    [_locaBtn addTarget:self action:@selector(chooseLoca:) forControlEvents:UIControlEventTouchUpInside];
    [ChooseView addSubview:_locaBtn];
    
    _otherBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width/2,0,self.frame.size.width/2,50)];
    _otherBtn.tag=1;
    [_otherBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_otherBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    _otherBtn.titleLabel.font=[UIFont systemFontOfSize:16];
    [_otherBtn setTitle:@"附近景点" forState:UIControlStateNormal];
    [_otherBtn setBackgroundColor:RGBCOLOR(193, 218, 249)];
    [_otherBtn addTarget:self action:@selector(chooseLoca:) forControlEvents:UIControlEventTouchUpInside];
    [ChooseView addSubview:_otherBtn];

    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        SinceCell *cell=[tableView dequeueReusableCellWithIdentifier:@"SinceCell"];
    NSDictionary *dic;
    if (_pro==0) {
        dic =_dataArray0[indexPath.row];
    }
    if (_pro==1) {
        dic =_dataArray1[indexPath.row];
        
    }
    

    [cell setInformWithDic:dic];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        return SCREEN_WIDTH*1.2;
        

}

- (void)updateHighWithFrame{
    CGRect frame0=CGRectMake(0, 0, SCREEN_WIDTH, self.frame.size.height-50);
    CGRect frame1=CGRectMake(0, self.frame.size.height-50, SCREEN_WIDTH, 50);
    
    [UIView animateWithDuration:0.3 animations:^{
        _tableView.frame=frame0;
        ChooseView.frame=frame1;

    }];
}
@end

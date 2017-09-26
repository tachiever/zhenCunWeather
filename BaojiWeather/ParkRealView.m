//
//  ParkRealView.m
//  BaojiWeather
//
//  Created by Tcy on 2017/6/8.
//  Copyright © 2017年 Tcy. All rights reserved.
//

#import "ParkRealView.h"
#import "ParkRealCell.h"
#import "ParkRealCell3.h"

@interface ParkRealView ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
    
    UITableView *_tableView;

}
@property (nonatomic ) NSMutableArray *dataArray;
@property (nonatomic ) NSDictionary *userDic;
@property (nonatomic ) UILabel *titLab;
@property (nonatomic ) UILabel *dateLab;

@end
@implementation ParkRealView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=RGBCOLOR(0, 32, 203);
        _dataArray=[[NSMutableArray alloc]init];
        [self createTableView];
    }
    return self;
}

- (void)refreshData{
    
    [self loadNewData];
    
}


- (void)downloadDataWith:(NSDictionary *)dic{
    _userDic=dic;
    NSString *numSt;
    if ([dic[@"user_country"] isEqualToString:@"凤翔县"]) {
        numSt=@"1";
    }
    if ([dic[@"user_country"] isEqualToString:@"千阳县"]) {
        numSt=@"2";
    }
    if ([dic[@"user_country"] isEqualToString:@"渭滨区"]) {
        numSt=@"3";
    }else{
        numSt=@"";
    }
    _titLab.text=[NSString stringWithFormat:@"%@土壤小气候",dic[@"user_country"]];

    NSString *url=[NSString stringWithFormat:ParkRealUrl,numSt];
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manger POST:url parameters:nil success:^(AFHTTPRequestOperation * operation, id responseObject) {
        
        
        //NSLog(@"乡镇预报——————————,%@",responseObject);

        [_dataArray removeAllObjects];

        NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        //使用如下方法 将获取到的数据按照gbkEncoding的方式进行编码，结果将是正常的汉字
        NSString *zhuanHuanHouDeShuJu = [[NSString alloc] initWithData:responseObject encoding:gbkEncoding];
        
        
        NSArray *array1 = [zhuanHuanHouDeShuJu componentsSeparatedByString:@"<table width=\"100%\" border=\"0\" align=\"center\" cellpadding=\"5\" cellspacing=\"1\">"];
        NSArray *array2 = [[array1 lastObject] componentsSeparatedByString:@"</table>"]; //从字符A中分隔成2个元素的数组
        
        NSString *reStr = [array2[0] stringByReplacingOccurrencesOfString:@" width=\"180\"" withString:@""];
        
        NSString *reStr1 = [[reStr stringByReplacingOccurrencesOfString:@"<tr><td class=\"s2\">" withString:@""] stringByReplacingOccurrencesOfString:@"</td><td class=\"s3\">" withString:@":"];
        
        NSString *reStr2 = [[[reStr1 stringByReplacingOccurrencesOfString:@"地温" withString:@""] stringByReplacingOccurrencesOfString:@"土壤水分" withString:@""] stringByReplacingOccurrencesOfString:@"</td></tr>" withString:@""];
        
        reStr2 = [reStr2 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; //去除掉首尾的空白字符和换行字符

        
        NSString *reStr3 = [reStr2 stringByReplacingOccurrencesOfString:@"\n" withString:@"=="];

        
        NSArray *arr= [reStr3 componentsSeparatedByString:@"=="];
        
        [_dataArray addObjectsFromArray:arr];
        _dateLab.text=_dataArray[0];

        [_dataArray removeObjectAtIndex:0];
        NSString *st1=_dataArray[8];
        [_dataArray removeObjectAtIndex:8];
        [_dataArray insertObject:st1 atIndex:5];
        
        NSString *st2=[_dataArray lastObject];
        [_dataArray removeObjectAtIndex:12];
        [_dataArray insertObject:st2 atIndex:6];
        
        NSMutableArray *arr1=[[NSMutableArray alloc]init];
        NSMutableArray *arr2=[[NSMutableArray alloc]init];
        for (int i=0; i<3; i++) {
            [arr1 addObject:_dataArray[7]];
            [_dataArray removeObjectAtIndex:7];

        }
        for (int i=0; i<3; i++) {
            [arr2 addObject:_dataArray[7]];
            [_dataArray removeObjectAtIndex:7];
            
        }
        [_dataArray addObject:arr1];
        [_dataArray addObject:arr2];

        [_tableView reloadData];
        [_tableView headerEndRefreshing];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [_tableView headerEndRefreshing];
        [SVProgressHUD showErrorWithStatus:error.userInfo[@"NSLocalizedDescription"]];

    }];
    
}
- (void)loadNewData{
        [self downloadDataWith:_userDic];
        

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
    return _dataArray.count;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

- (void)createTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.frame.size.height-0) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.backgroundColor=RGBCOLOR(193, 218, 249);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:_tableView];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];//纯代码定制cell
    [_tableView registerNib:[UINib nibWithNibName:@"ParkRealCell" bundle:nil] forCellReuseIdentifier:@"ParkRealCell"];//xib定制cell
    [_tableView registerNib:[UINib nibWithNibName:@"ParkRealCell3" bundle:nil] forCellReuseIdentifier:@"ParkRealCell3"];//xib定制cell
    [_tableView addHeaderWithTarget:self action:@selector(loadNewData) dateKey:@"refresh"];
    [_tableView setHeaderRefreshingText:@"正在刷新..."];
    
    UIView *seaeView=[[UIView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 85)];
    seaeView.backgroundColor=RGBCOLOR(190, 218, 255);
    _tableView.tableHeaderView=seaeView;
    
    _titLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 15, SCREEN_WIDTH, 30)];
    _titLab.textAlignment=NSTextAlignmentCenter;
    _titLab.textColor=RGBACOLOR(0, 32, 202,0.9);
    _titLab.font=[UIFont systemFontOfSize:20];
    _titLab.text=@"渭滨区土壤小气候";
    [seaeView addSubview:_titLab];
    
    _dateLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 20)];
    _dateLab.textAlignment=NSTextAlignmentCenter;
    _dateLab.textColor=RGBACOLOR(0, 32, 202,0.9);
    _dateLab.font=[UIFont systemFontOfSize:14];
    
    
    
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *str=[inputFormatter stringFromDate:[NSDate date]];
    _dateLab.text=str;
    [seaeView addSubview:_dateLab];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row<7) {
        ParkRealCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ParkRealCell"];
        cell.titlab.text=_dataArray[indexPath.row];
        [cell sIconImage:[NSString stringWithFormat:@"%ld",indexPath.row]];

        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }else{
    
         ParkRealCell3 *cell=[tableView dequeueReusableCellWithIdentifier:@"ParkRealCell3"];
        if (indexPath.row==7) {
            cell.titlab.text=@"地温";

        }
        if (indexPath.row==8) {
            cell.titlab.text=@"土壤水分";

        }
        [cell sIconImage:[NSString stringWithFormat:@"%ld",indexPath.row]];
        cell.detlab1.text=_dataArray[indexPath.row][0];
        cell.detlab2.text=_dataArray[indexPath.row][1];
        cell.detlab3.text=_dataArray[indexPath.row][2];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }



}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row<7) {
        return 70;

    }else{
        
        return 136;

    }
}

- (void)updateHighWithFrame{
    CGRect frame0=CGRectMake(0, 0, SCREEN_WIDTH, self.frame.size.height);
    [UIView animateWithDuration:0.3 animations:^{
        _tableView.frame=frame0;
    }];
}
@end

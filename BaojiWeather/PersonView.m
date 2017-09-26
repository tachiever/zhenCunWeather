
//
//  PersonView.m
//  BaojiWeather
//
//  Created by Tcy on 2017/6/15.
//  Copyright © 2017年 Tcy. All rights reserved.
//

#import "PersonView.h"
#import "PersonModel.h"
#import "CityButton.h"
#import "PersonTableViewCell.h"
#import "PerTableViewCell.h"

@interface PersonView ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *_tableView;
    
}

@property (nonatomic)NSMutableArray *dataArray;
@property (nonatomic)NSMutableArray *statuArray;
@property (nonatomic)NSArray *cityArray;
@property (nonatomic)NSInteger num;

@property (nonatomic)CityButton *btn0;
@property (nonatomic)CityButton *btn1;
@property (nonatomic)CityButton *btn2;
@property (nonatomic)CityButton *btn3;
@property (nonatomic)CityButton *btn4;
@property (nonatomic)CityButton *btn5;
@property (nonatomic)CityButton *btn6;
@property (nonatomic)CityButton *btn7;
@property (nonatomic)CityButton *btn8;
@property (nonatomic)CityButton *btn9;
@property (nonatomic)CityButton *btn10;
@property (nonatomic)CityButton *btn11;
@property (nonatomic)CityButton *btn12;

@end

@implementation PersonView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        
        _dataArray=[[NSMutableArray alloc]init];
        _statuArray=[[NSMutableArray alloc]init];
        _num=9999999;
        _cityArray=@[@"宝鸡市",@"渭滨区",@"金台区",@"陈仓区",@"凤翔县",@"岐山县",@"扶风县",@"眉县",@"陇县",@"千阳县",@"麟游县",@"凤县",@"太白县"];
        
        [self createTableView];

    }
    return self;
}

- (void)downlaodData{
    [self getPersonInfor:@"宝鸡市"];
}
#pragma Mark CommunicatePerson Part
- (void)getPersonInfor:(NSString *)city{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:city forKey:@"site_id"];
    
    [NBRequest postWithURL:PersonUrl type:RequestRefresh dic:dict success:^(NSData *requestData) {
        
        [_dataArray removeAllObjects];
        [_statuArray removeAllObjects];
        _num=9999999;
        
        NSArray *array = [NSJSONSerialization JSONObjectWithData:requestData options:NSJSONReadingMutableContainers error:nil];

        if (array.count>0) {
            for (NSDictionary *dic in array) {
                NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
                NSArray *arr=dic[@"childlist"];
                [dict setObject:dic[@"childlist"] forKey:@"childlist"];
                [dict setObject:dic[@"prentMenuName"] forKey:@"prentMenuName"];
                [dict setObject:[NSString stringWithFormat:@"%ld人",(unsigned long)arr.count] forKey:@"presonNum"];
                [_dataArray addObject:dict];
            }
            // NSLog(@"%ld",_dataArray.count);
            NSLog(@"%@",_dataArray[0]);
            
            for (int i=0; i<_dataArray.count; i++) {
                [_statuArray addObject:@(NO)];
            }
        }
        [_tableView reloadData];

    } failed:^(NSError *error) {
        
    }];
    
    
    
}


- (void)buttonClick:(UIButton *)button {
    button.transform = CGAffineTransformMakeRotation(M_PI_2);
    // 更改数组里保存的状态的值
    if (_num!=button.tag-100&&_num<1000) {
        [_statuArray replaceObjectAtIndex:_num withObject:@(NO)];
    }
    _num=button.tag-100;
    BOOL state = [_statuArray[button.tag-100] boolValue];
    [_statuArray replaceObjectAtIndex:button.tag-100 withObject:@(!state)];
    [_tableView reloadData];
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:button.tag-100];
    [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 60)];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(_tableView.frame.size.width-40, 10, 30, 30);
    [button setImage:[UIImage imageNamed:@"xyjt"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = 100+section;
    BOOL state = [_statuArray[section] boolValue];
    if (state) {
        button.transform = CGAffineTransformMakeRotation(M_PI/2);
    } else {
        button.transform = CGAffineTransformMakeRotation(0);
    }
    [view addSubview:button];
    
    
    CGFloat f= (SCREEN_HEIGHT>600? 17 :15);
    UIView *linView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,_tableView.frame.size.width, 1)];
    linView.backgroundColor= RGBCOLOR(120, 120, 120);
    [view addSubview:linView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 160, 50)];
    label.text = _dataArray[section][@"prentMenuName"];
    label.font = [UIFont systemFontOfSize:f];
    label.textColor=[UIColor darkGrayColor];
    [view addSubview:label];
    view.backgroundColor = RGBCOLOR(253, 253, 255);
    
    
    UILabel *numLab = [[UILabel alloc] initWithFrame:CGRectMake(_tableView.frame.size.width-80, 0, 40, 50)];
    numLab.text = _dataArray[section][@"presonNum"];
    numLab.font = [UIFont systemFontOfSize:f];
    numLab.textColor=[UIColor darkGrayColor];
    [view addSubview:numLab];
    
    return view;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.0001;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return _dataArray.count;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    BOOL state = [_statuArray[section] boolValue];
    if (state) {
        return [_dataArray[section][@"childlist"] count];
    } else {
        return 0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}




- (void)createTableView{
    [self createButton];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(((self.frame.size.height-14)/13.00)*2.0+1,0, SCREEN_WIDTH-((self.frame.size.height-14)/13.00)*2.0-2, self.frame.size.height) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.backgroundColor=[UIColor clearColor];
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.separatorColor = RGBCOLOR(120, 120, 120);
    
    [self addSubview:_tableView];
    
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];//纯代码定制cell
    
    [_tableView registerNib:[UINib nibWithNibName:@"PersonTableViewCell" bundle:nil] forCellReuseIdentifier:@"PersonTableViewCell"];//xib定制cell
    [_tableView registerNib:[UINib nibWithNibName:@"PerTableViewCell" bundle:nil] forCellReuseIdentifier:@"PerTableViewCell"];//xib定制cell
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dic=_dataArray[indexPath.section][@"childlist"][indexPath.row];
    PersonModel *model=[[PersonModel alloc]init];
    [model setValuesForKeysWithDictionary:dic];
    
    if (SCREEN_HEIGHT<600) {
        PerTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"PerTableViewCell"];
        
        cell.backgroundColor=[UIColor clearColor];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = RGBACOLOR(77, 77, 77, 1);
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.layer.masksToBounds=YES;
        cell.layer.cornerRadius=5;
        cell.layer.borderWidth=1;
        cell.layer.borderColor=RGBCOLOR(32, 183, 238).CGColor;
        
        [cell.nameLab setText:[NSString stringWithFormat:@"%@",model.name]];
        [cell.dutyLab setText:[NSString stringWithFormat:@"%@",model.duty]];
        [cell.comany setText:[NSString stringWithFormat:@"%@",model.company]];
        [cell.otherLab setText:[NSString stringWithFormat:@"%@",model.other]];
        NSString *fax;
        NSString *pho=[model.phone substringWithRange:NSMakeRange(3,11)];
        if (model.fax.length>10) {
            fax=[model.fax substringWithRange:NSMakeRange(3,12)];
            
        }else{
            fax=[model.fax substringFromIndex:3];
            
        }
        [cell.phonebtn setTitle:pho forState:UIControlStateNormal];
        [cell.faxbtn setTitle:fax forState:UIControlStateNormal];
        
        [cell setMessageAction:^(){
            NSLog(@"message");
            if (_actionSendMess) {
                _actionSendMess(pho);
            }
        }];
        [cell setPhoneAction:^(){
            NSLog(@"phone");
            if (_actionMakeCell) {
                _actionMakeCell(pho);
            }        }];
        [cell setFaxAction:^(){
            NSLog(@"fax");
            if (_actionMakeCell) {
                _actionMakeCell(pho);
            }
        }];
        
        return cell;
    }
    else{
        
        PersonTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"PersonTableViewCell"];
        cell.backgroundColor=[UIColor clearColor];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = RGBACOLOR(77, 77, 77, 1);
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.layer.masksToBounds=YES;
        cell.layer.cornerRadius=5;
        cell.layer.borderWidth=1;
        cell.layer.borderColor=RGBCOLOR(32, 183, 238).CGColor;
        
        [cell.nameLab setText:[NSString stringWithFormat:@"%@",model.name]];
        [cell.dutyLab setText:[NSString stringWithFormat:@"%@",model.duty]];
        [cell.comany setText:[NSString stringWithFormat:@"%@",model.company]];
        [cell.otherLab setText:[NSString stringWithFormat:@"%@",model.other]];
        NSString *fax;
        NSString *pho=[model.phone substringWithRange:NSMakeRange(3,11)];
        if (model.fax.length>10) {
            fax=[model.fax substringWithRange:NSMakeRange(3,12)];
            
        }else{
            fax=[model.fax substringFromIndex:3];
            
        }
        NSLog(@"%@,%@",pho,fax);
        [cell.phoneLab setTitle:pho forState:UIControlStateNormal];
        [cell.faxLab setTitle:fax forState:UIControlStateNormal];
        
        [cell setMessageAction:^(){
            NSLog(@"message");
            if (_actionSendMess) {
                _actionSendMess(pho);
            }
            
        }];
        [cell setPhoneAction:^(){
            NSLog(@"call phone");
            if (_actionMakeCell) {
                _actionMakeCell(pho);
            }
        }];
        [cell setFaxAction:^(){
            NSLog(@"call fax");
            if (_actionMakeCell) {
                _actionMakeCell(pho);
            }
        }];
        
        return cell;
    }
    
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 240;
}


- (void)createButton{
    _btn0=[CityButton buttonWithType:UIButtonTypeCustom];
    _btn0.frame=CGRectMake(1, 1+((self.frame.size.height-14)/13.00+1)*0, ((self.frame.size.height-14)/13.00)*2.0, (self.frame.size.height-14)/13.00);
    [_btn0 setTitle:_cityArray[0] forState:UIControlStateNormal];
    [_btn0 addTarget:self action:@selector(selectCity:) forControlEvents:UIControlEventTouchUpInside];
    _btn0.layer.borderColor=[UIColor clearColor].CGColor;
    _btn0.backgroundColor=[UIColor whiteColor];
    _btn0.enabled=NO;
    [self addSubview:_btn0];
    
    _btn1=[CityButton buttonWithType:UIButtonTypeCustom];
    _btn1.frame=CGRectMake(1, 1+((self.frame.size.height-14)/13.00+1)*1, ((self.frame.size.height-14)/13.00)*2.0, (self.frame.size.height-14)/13.00);
    [_btn1 setTitle:_cityArray[1] forState:UIControlStateNormal];
    [_btn1 addTarget:self action:@selector(selectCity:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_btn1];
    
    _btn2=[CityButton buttonWithType:UIButtonTypeCustom];
    _btn2.frame=CGRectMake(1, 1+((self.frame.size.height-14)/13.00+1)*2, ((self.frame.size.height-14)/13.00)*2.0, (self.frame.size.height-14)/13.00);
    [_btn2 setTitle:_cityArray[2] forState:UIControlStateNormal];
    [_btn2 addTarget:self action:@selector(selectCity:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_btn2];
    
    _btn3=[CityButton buttonWithType:UIButtonTypeCustom];
    _btn3.frame=CGRectMake(1, 1+((self.frame.size.height-14)/13.00+1)*3, ((self.frame.size.height-14)/13.00)*2.0, (self.frame.size.height-14)/13.00);
    [_btn3 setTitle:_cityArray[3] forState:UIControlStateNormal];
    [_btn3 addTarget:self action:@selector(selectCity:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_btn3];
    
    _btn4=[CityButton buttonWithType:UIButtonTypeCustom];
    _btn4.frame=CGRectMake(1, 1+((self.frame.size.height-14)/13.00+1)*4, ((self.frame.size.height-14)/13.00)*2.0, (self.frame.size.height-14)/13.00);
    [_btn4 setTitle:_cityArray[4] forState:UIControlStateNormal];
    [_btn4 addTarget:self action:@selector(selectCity:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_btn4];
    
    _btn5=[CityButton buttonWithType:UIButtonTypeCustom];
    _btn5.frame=CGRectMake(1, 1+((self.frame.size.height-14)/13.00+1)*5, ((self.frame.size.height-14)/13.00)*2.0, (self.frame.size.height-14)/13.00);
    [_btn5 setTitle:_cityArray[5] forState:UIControlStateNormal];
    [_btn5 addTarget:self action:@selector(selectCity:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_btn5];
    
    _btn6=[CityButton buttonWithType:UIButtonTypeCustom];
    _btn6.frame=CGRectMake(1, 1+((self.frame.size.height-14)/13.00+1)*6, ((self.frame.size.height-14)/13.00)*2.0, (self.frame.size.height-14)/13.00);
    [_btn6 setTitle:_cityArray[6] forState:UIControlStateNormal];
    [_btn6 addTarget:self action:@selector(selectCity:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_btn6];
    
    _btn7=[CityButton buttonWithType:UIButtonTypeCustom];
    _btn7.frame=CGRectMake(1, 1+((self.frame.size.height-14)/13.00+1)*7, ((self.frame.size.height-14)/13.00)*2.0, (self.frame.size.height-14)/13.00);
    [_btn7 setTitle:_cityArray[7] forState:UIControlStateNormal];
    [_btn7 addTarget:self action:@selector(selectCity:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_btn7];
    
    _btn8=[CityButton buttonWithType:UIButtonTypeCustom];
    _btn8.frame=CGRectMake(1, 1+((self.frame.size.height-14)/13.00+1)*8, ((self.frame.size.height-14)/13.00)*2.0, (self.frame.size.height-14)/13.00);
    [_btn8 setTitle:_cityArray[8] forState:UIControlStateNormal];
    [_btn8 addTarget:self action:@selector(selectCity:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_btn8];
    
    _btn9=[CityButton buttonWithType:UIButtonTypeCustom];
    _btn9.frame=CGRectMake(1, 1+((self.frame.size.height-14)/13.00+1)*9, ((self.frame.size.height-14)/13.00)*2.0, (self.frame.size.height-14)/13.00);
    [_btn9 setTitle:_cityArray[9] forState:UIControlStateNormal];
    [_btn9 addTarget:self action:@selector(selectCity:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_btn9];
    
    _btn10=[CityButton buttonWithType:UIButtonTypeCustom];
    _btn10.frame=CGRectMake(1, 1+((self.frame.size.height-14)/13.00+1)*10, ((self.frame.size.height-14)/13.00)*2.0, (self.frame.size.height-14)/13.00);
    [_btn10 setTitle:_cityArray[10] forState:UIControlStateNormal];
    [_btn10 addTarget:self action:@selector(selectCity:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_btn10];
    
    _btn11=[CityButton buttonWithType:UIButtonTypeCustom];
    _btn11.frame=CGRectMake(1, 1+((self.frame.size.height-14)/13.00+1)*11, ((self.frame.size.height-14)/13.00)*2.0, (self.frame.size.height-14)/13.00);
    [_btn11 setTitle:_cityArray[11] forState:UIControlStateNormal];
    [_btn11 addTarget:self action:@selector(selectCity:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_btn11];
    
    
    _btn12=[CityButton buttonWithType:UIButtonTypeCustom];
    _btn12.frame=CGRectMake(1, 1+((self.frame.size.height-14)/13.00+1)*12, ((self.frame.size.height-14)/13.00)*2.0, (self.frame.size.height-14)/13.00);
    [_btn12 setTitle:_cityArray[12] forState:UIControlStateNormal];
    [_btn12 addTarget:self action:@selector(selectCity:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_btn12];
    
    
}
- (void)selectCity:(UIButton *)btn{
    [self resetButton];
    if (btn==_btn0) {
        _btn0.enabled=NO;
        _btn0.layer.borderColor=[UIColor clearColor].CGColor;
        _btn0.backgroundColor=[UIColor whiteColor];
        [self getPersonInfor:_cityArray[0]];
    }
    if (btn==_btn1) {
        _btn1.enabled=NO;
        _btn1.layer.borderColor=[UIColor clearColor].CGColor;
        _btn1.backgroundColor=[UIColor whiteColor];
        [self getPersonInfor:_cityArray[1]];
    }
    if (btn==_btn2) {
        _btn2.enabled=NO;
        _btn2.layer.borderColor=[UIColor clearColor].CGColor;
        _btn2.backgroundColor=[UIColor whiteColor];
        [self getPersonInfor:_cityArray[2]];
    }
    if (btn==_btn3) {
        _btn3.enabled=NO;
        _btn3.layer.borderColor=[UIColor clearColor].CGColor;
        _btn3.backgroundColor=[UIColor whiteColor];
        [self getPersonInfor:_cityArray[3]];
    }
    if (btn==_btn4) {
        _btn4.enabled=NO;
        _btn4.layer.borderColor=[UIColor clearColor].CGColor;
        _btn4.backgroundColor=[UIColor whiteColor];
        [self getPersonInfor:_cityArray[4]];
    }
    if (btn==_btn5) {
        _btn5.enabled=NO;
        _btn5.layer.borderColor=[UIColor clearColor].CGColor;
        _btn5.backgroundColor=[UIColor whiteColor];
        [self getPersonInfor:_cityArray[5]];
    }
    if (btn==_btn6) {
        _btn6.enabled=NO;
        _btn6.layer.borderColor=[UIColor clearColor].CGColor;
        _btn6.backgroundColor=[UIColor whiteColor];
        [self getPersonInfor:_cityArray[6]];
    }
    if (btn==_btn7) {
        _btn7.enabled=NO;
        _btn7.layer.borderColor=[UIColor clearColor].CGColor;
        _btn7.backgroundColor=[UIColor whiteColor];
        [self getPersonInfor:_cityArray[7]];
    }
    if (btn==_btn8) {
        _btn8.enabled=NO;
        _btn8.layer.borderColor=[UIColor clearColor].CGColor;
        _btn8.backgroundColor=[UIColor whiteColor];
        [self getPersonInfor:_cityArray[8]];
    }
    if (btn==_btn9) {
        _btn9.enabled=NO;
        _btn9.layer.borderColor=[UIColor clearColor].CGColor;
        _btn9.backgroundColor=[UIColor whiteColor];
        [self getPersonInfor:_cityArray[9]];
    }
    if (btn==_btn10) {
        _btn10.enabled=NO;
        _btn10.layer.borderColor=[UIColor clearColor].CGColor;
        _btn10.backgroundColor=[UIColor whiteColor];
        [self getPersonInfor:_cityArray[10]];
    }
    if (btn==_btn11) {
        _btn11.enabled=NO;
        _btn11.layer.borderColor=[UIColor clearColor].CGColor;
        _btn11.backgroundColor=[UIColor whiteColor];
        [self getPersonInfor:_cityArray[11]];
    }
    if (btn==_btn12) {
        _btn12.enabled=NO;
        _btn12.layer.borderColor=[UIColor clearColor].CGColor;
        _btn12.backgroundColor=[UIColor whiteColor];
        [self getPersonInfor:_cityArray[12]];
    }
}
- (void)resetButton{
    _btn0.layer.borderColor=[UIColor lightGrayColor].CGColor;
    _btn0.backgroundColor=RGBCOLOR(243, 244, 246);
    _btn0.enabled=YES;
    
    _btn1.layer.borderColor=[UIColor lightGrayColor].CGColor;
    _btn1.backgroundColor=RGBCOLOR(243, 244, 246);
    _btn1.enabled=YES;
    
    _btn2.layer.borderColor=[UIColor lightGrayColor].CGColor;
    _btn2.backgroundColor=RGBCOLOR(243, 244, 246);
    _btn2.enabled=YES;
    
    _btn3.layer.borderColor=[UIColor lightGrayColor].CGColor;
    _btn3.backgroundColor=RGBCOLOR(243, 244, 246);
    _btn3.enabled=YES;
    
    _btn4.layer.borderColor=[UIColor lightGrayColor].CGColor;
    _btn4.backgroundColor=RGBCOLOR(243, 244, 246);
    _btn4.enabled=YES;
    
    _btn5.layer.borderColor=[UIColor lightGrayColor].CGColor;
    _btn5.backgroundColor=RGBCOLOR(243, 244, 246);
    _btn5.enabled=YES;
    
    _btn6.layer.borderColor=[UIColor lightGrayColor].CGColor;
    _btn6.backgroundColor=RGBCOLOR(243, 244, 246);
    _btn6.enabled=YES;
    
    _btn7.layer.borderColor=[UIColor lightGrayColor].CGColor;
    _btn7.backgroundColor=RGBCOLOR(243, 244, 246);
    _btn7.enabled=YES;
    
    _btn8.layer.borderColor=[UIColor lightGrayColor].CGColor;
    _btn8.backgroundColor=RGBCOLOR(243, 244, 246);
    _btn8.enabled=YES;
    
    _btn9.layer.borderColor=[UIColor lightGrayColor].CGColor;
    _btn9.backgroundColor=RGBCOLOR(243, 244, 246);
    _btn9.enabled=YES;
    
    _btn10.layer.borderColor=[UIColor lightGrayColor].CGColor;
    _btn10.backgroundColor=RGBCOLOR(243, 244, 246);
    _btn10.enabled=YES;
    
    
    _btn11.layer.borderColor=[UIColor lightGrayColor].CGColor;
    _btn11.backgroundColor=RGBCOLOR(243, 244, 246);
    _btn11.enabled=YES;
    
    _btn12.layer.borderColor=[UIColor lightGrayColor].CGColor;
    _btn12.backgroundColor=RGBCOLOR(243, 244, 246);
    _btn12.enabled=YES;
    
}
- (void)updateBtnFrame{
    _btn0.frame=CGRectMake(1, 1+((self.frame.size.height-14)/13.00+1)*0, ((self.frame.size.height-14)/13.00)*2.0, (self.frame.size.height-14)/13.00);
    _btn1.frame=CGRectMake(1, 1+((self.frame.size.height-14)/13.00+1)*1, ((self.frame.size.height-14)/13.00)*2.0, (self.frame.size.height-14)/13.00);
    _btn2.frame=CGRectMake(1, 1+((self.frame.size.height-14)/13.00+1)*2, ((self.frame.size.height-14)/13.00)*2.0, (self.frame.size.height-14)/13.00);
    _btn3.frame=CGRectMake(1, 1+((self.frame.size.height-14)/13.00+1)*3, ((self.frame.size.height-14)/13.00)*2.0, (self.frame.size.height-14)/13.00);
    _btn4.frame=CGRectMake(1, 1+((self.frame.size.height-14)/13.00+1)*4, ((self.frame.size.height-14)/13.00)*2.0, (self.frame.size.height-14)/13.00);
    _btn5.frame=CGRectMake(1, 1+((self.frame.size.height-14)/13.00+1)*5, ((self.frame.size.height-14)/13.00)*2.0, (self.frame.size.height-14)/13.00);
    _btn6.frame=CGRectMake(1, 1+((self.frame.size.height-14)/13.00+1)*6, ((self.frame.size.height-14)/13.00)*2.0, (self.frame.size.height-14)/13.00);
    _btn7.frame=CGRectMake(1, 1+((self.frame.size.height-14)/13.00+1)*7, ((self.frame.size.height-14)/13.00)*2.0, (self.frame.size.height-14)/13.00);
    _btn8.frame=CGRectMake(1, 1+((self.frame.size.height-14)/13.00+1)*8, ((self.frame.size.height-14)/13.00)*2.0, (self.frame.size.height-14)/13.00);
    _btn9.frame=CGRectMake(1, 1+((self.frame.size.height-14)/13.00+1)*9, ((self.frame.size.height-14)/13.00)*2.0, (self.frame.size.height-14)/13.00);
    _btn10.frame=CGRectMake(1, 1+((self.frame.size.height-14)/13.00+1)*10, ((self.frame.size.height-14)/13.00)*2.0, (self.frame.size.height-14)/13.00);
    _btn11.frame=CGRectMake(1, 1+((self.frame.size.height-14)/13.00+1)*11, ((self.frame.size.height-14)/13.00)*2.0, (self.frame.size.height-14)/13.00);
    _btn12.frame=CGRectMake(1, 1+((self.frame.size.height-14)/13.00+1)*12, ((self.frame.size.height-14)/13.00)*2.0, (self.frame.size.height-14)/13.00);

}
- (void)updateHighWithFrame{
    CGRect frame0=CGRectMake(((self.frame.size.height-14)/13.00)*2.0+1,0, SCREEN_WIDTH-((self.frame.size.height-14)/13.00)*2.0-2, self.frame.size.height);
    [UIView animateWithDuration:0.3 animations:^{
        _tableView.frame=frame0;
        [self updateBtnFrame];
    }];
}

@end

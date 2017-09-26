//
//  NoticeCell.m
//  BaojiWeather
//
//  Created by Tcy on 2017/6/2.
//  Copyright © 2017年 Tcy. All rights reserved.
//

#import "NoticeCell.h"

@implementation NoticeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self stup];
}


- (void)stup{
    
    _bgView.layer.masksToBounds=NO;
    _bgView.layer.cornerRadius=6;
    _bgView.layer.shadowColor=[UIColor grayColor].CGColor;
    _bgView.layer.shadowOffset=CGSizeMake(0, 2);
    _bgView.layer.shadowOpacity=0.8;
    _bgView.layer.shadowRadius=3.f;

}

- (void)setDataWith:(NoticeModel *)model{

    _titleLab.text=model.not_title;
    _pushPerLab.text=model.send_name;
    
    _timeAndAount.text=[NSString stringWithFormat:@"浏览%@次 %@",model.reader_count,model.create_time];
    
    if ([model.is_read intValue]==0) {
        [_readSignal setImage:[UIImage imageNamed:@"notice_read_no"]];
    }else{
        [_readSignal setImage:[UIImage imageNamed:@"notice_read_yes"]];

    }
    
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
    
    
    if (interval>=[model.not_value_hours floatValue]) {
        [_outSignal setImage:[UIImage imageNamed:@"notice_timeout_yes"]];

    }else{
        [_outSignal setImage:[UIImage imageNamed:@"notice_timeout_no"]];

    
    }
    

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  NoticeModel.h
//  BaojiWeather
//
//  Created by Tcy on 2017/6/1.
//  Copyright © 2017年 Tcy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoticeModel : NSObject
@property (nonatomic,copy) NSString *create_time;
@property (nonatomic,copy) NSString *is_read;
@property (nonatomic,copy) NSString *not_content;
@property (nonatomic,copy) NSString *not_id;
@property (nonatomic,copy) NSString *not_title;
@property (nonatomic,copy) NSString *not_value_hours;
@property (nonatomic,copy) NSString *reader_count;
@property (nonatomic,copy) NSString *readers;
@property (nonatomic,copy) NSString *send_city;
@property (nonatomic,copy) NSString *send_country;
@property (nonatomic,copy) NSString *send_name;
@property (nonatomic,copy) NSString *send_phone;
@property (nonatomic,copy) NSString *send_post;
@property (nonatomic,copy) NSString *send_town;

- (void)setSteaue:(NSString *)str;
@end

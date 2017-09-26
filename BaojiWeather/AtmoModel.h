//
//  AtmoModel.h
//  BaojiWeather
//
//  Created by Tcy on 2017/6/7.
//  Copyright © 2017年 Tcy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AtmoModel : NSObject
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *id;
@property (nonatomic,copy) NSString *product_type;
@property (nonatomic,copy) NSString *site_id;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *up_time;
@end

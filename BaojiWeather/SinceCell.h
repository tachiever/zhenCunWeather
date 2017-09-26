//
//  SinceCell.h
//  BaojiWeather
//
//  Created by Tcy on 2017/6/9.
//  Copyright © 2017年 Tcy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SinceCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *downView;
@property (weak, nonatomic) IBOutlet UILabel *sinceLab;
@property (weak, nonatomic) IBOutlet UILabel *detailLab;
@property (weak, nonatomic) IBOutlet UIImageView *sinceImage;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

- (void)setInformWithDic:(NSDictionary *)dic;
@end

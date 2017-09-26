//
//  SinceCell.m
//  BaojiWeather
//
//  Created by Tcy on 2017/6/9.
//  Copyright © 2017年 Tcy. All rights reserved.
//

#import "SinceCell.h"

@implementation SinceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _downView.backgroundColor=RGBACOLOR(24, 24, 24, 0.4);

    
}

- (void)setInformWithDic:(NSDictionary *)dic{
    
    _sinceLab.text=dic[@"position"];
    _detailLab.text=dic[@"real"];
    
   // _sinceImage.ima;
    [_webView loadHTMLString:dic[@"forcasthtml"] baseURL:nil];
    _webView.backgroundColor=[UIColor clearColor];
    [_webView setOpaque:NO];
  //  [_sinceImage setImageWithURL:dic[@"pic"] placeholderImage:[UIImage imageNamed:@""]];
    [_sinceImage sd_setImageWithURL:dic[@"pic"] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];

}


- (IBAction)showDetail:(id)sender {
    
    NSString *st=[NSString stringWithFormat:baikeUrl,_sinceLab.text];
    st = [st  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url=[NSURL URLWithString:st];
    
    [[UIApplication sharedApplication] openURL:url];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end

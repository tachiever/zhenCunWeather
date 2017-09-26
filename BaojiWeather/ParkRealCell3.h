//
//  ParkRealCell3.h
//  BaojiWeather
//
//  Created by Tcy on 2017/6/9.
//  Copyright © 2017年 Tcy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ParkRealCell3 : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titlab;
@property (weak, nonatomic) IBOutlet UILabel *detlab1;
@property (weak, nonatomic) IBOutlet UILabel *detlab2;
@property (weak, nonatomic) IBOutlet UILabel *detlab3;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
- (void)sIconImage:(NSString *)imageName;
@end

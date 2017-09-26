//
//  MeCell.h
//  BaojiWeather
//
//  Created by Tcy on 2017/6/16.
//  Copyright © 2017年 Tcy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *rigBtn;

@property (weak, nonatomic) IBOutlet UITextView *detailText;
@property (weak, nonatomic) IBOutlet UILabel *line;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;

@end

//
//  LMJScrollTextView.m
//  LMJScrollTextView
//
//  Version 1.0.0
//
//  Created by MajorLi on 14-12-4.
//  Copyright (c) 2014年 iOS开发者公会. All rights reserved.


#import "LMJScrollTextView.h"

@implementation LMJScrollTextView
{
    UILabel * _contentLabel1;
    UILabel * _contentLabel2;
    
    NSTimer * _timer;
    
    NSString * _text;
    UIFont * _font;
    UIColor * _textColor;
    
    UITapGestureRecognizer * _tapGesture;
    
    
    CGFloat _textWidth;
    LMJTextScrollMode _currentScrollModel;
    LMJTextScrollMoveDirection _currentMoveDirection;
    
    int _wanderingOffset;
}


-(id)initWithFrame:(CGRect)frame textScrollModel:(LMJTextScrollMode)scrollModel direction:(LMJTextScrollMoveDirection)moveDirection{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        
        //默认初始化
        _text = @"";
        _textColor = [UIColor whiteColor];
        _font = [UIFont systemFontOfSize:self.frame.size.height-4];
        _wanderingOffset = -1;

        //设置滚动模式和方向
        _currentScrollModel   = scrollModel;
        _currentMoveDirection = moveDirection;
    }
    return self;
}

- (void)textScrollModel:(LMJTextScrollMode)scrollModel direction:(LMJTextScrollMoveDirection)moveDirection{
    _currentScrollModel   = scrollModel;
    _currentMoveDirection = moveDirection;

}

#pragma mark - 开始滚动
-(void)startScrollWithText:(NSString * )text textColor:(UIColor *)color font:(UIFont *)font{
    //清空self上的子视图
    for (int i = 0; i < self.subviews.count; i++) {
        UIView * view = [self.subviews objectAtIndex:i];
        [view removeFromSuperview];
        view = nil;
    }
    
    //赋新值
    _text = text;
    _textColor = color;
    _font = font;
    
    _textWidth = [text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil]].width;
    
    //开始滚动
    [self startScroll];
}
- (void)updateText:(NSString *)str{
    _contentLabel2.text = @"";
    _contentLabel1.text = @"";

    for (int i = 0; i < self.subviews.count; i++) {
        UIView * view = [self.subviews objectAtIndex:i];
        [view removeFromSuperview];
        view = nil;
    }
    
    _text = str;
    _textWidth = [_text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:_font, NSFontAttributeName, nil]].width;
    [self startScroll];

}



#pragma mark - 创建滚动视图
-(void)startScroll{
    
    if (_text.length == 0) {//如果字符串长度为0，直接返回
        return;
    }
    
    
    //初始化滚动字符串label
    switch (_currentScrollModel) {
        
        case LMJTextScrollContinuous:
        {
            if (_textWidth > self.frame.size.width) {
                if (_currentMoveDirection == LMJTextScrollMoveLeft) {
                    [self creatLabel1AndLabel2WithFrame1:CGRectMake(0, 0, _textWidth, self.frame.size.height) frame2:CGRectMake(_textWidth, 0, _textWidth, self.frame.size.height)];
                }else{
                    [self creatLabel1AndLabel2WithFrame1:CGRectMake(self.frame.size.width -_textWidth, 0, _textWidth, self.frame.size.height) frame2:CGRectMake(self.frame.size.width -_textWidth -_textWidth, 0, _textWidth, self.frame.size.height)];
                }
            }else{//如果字符串长度小于控件宽度，只创建一个字符串label
                if (_currentMoveDirection == LMJTextScrollMoveLeft) {
                    [self creatLabel1WithFrame:CGRectMake(0, 0, _textWidth, self.frame.size.height)];
                }else{
                    [self creatLabel1WithFrame:CGRectMake(self.frame.size.width -_textWidth, 0, _textWidth, self.frame.size.height)];
                }
                
            }
        }break;
            
        case LMJTextScrollIntermittent:
        {
            if (_currentMoveDirection == LMJTextScrollMoveLeft) {
                [self creatLabel1WithFrame:CGRectMake(0, 0, _textWidth, self.frame.size.height)];
            }else{
                [self creatLabel1WithFrame:CGRectMake(self.frame.size.width -_textWidth, 0, _textWidth, self.frame.size.height)];
            }
        }break;
            
        case LMJTextScrollFromOutside:
        {
            if (_currentMoveDirection == LMJTextScrollMoveLeft) {
                [self creatLabel1WithFrame:CGRectMake(self.frame.size.width, 0, _textWidth, self.frame.size.height)];
            }else{
                [self creatLabel1WithFrame:CGRectMake(_textWidth, 0, _textWidth, self.frame.size.height)];
            }
        }break;
            
        case LMJTextScrollWandering:
        {
            [self creatLabel1WithFrame:CGRectMake(0, 0, _textWidth, self.frame.size.height)];
        }break;
            
        default:
            break;
    }

    
    //设置速度，开始滚动（默认为0.03）
    [self setMoveSpeed:0.02];;
}

#pragma mark - 创建label
-(void)creatLabel1WithFrame:(CGRect)frame{
    _contentLabel1 = [[UILabel alloc] initWithFrame:frame];
    _contentLabel1.text = _text;
    _contentLabel1.font = _font;
    _contentLabel1.textColor = _textColor;
    _contentLabel1.backgroundColor = [UIColor clearColor];
    [self addSubview:_contentLabel1];
}
-(void)creatLabel1AndLabel2WithFrame1:(CGRect)frame1 frame2:(CGRect)frame2{
    _contentLabel1 = [[UILabel alloc] initWithFrame:frame1];
    _contentLabel1.text = _text;
    _contentLabel1.font = _font;
    _contentLabel1.textColor = _textColor;
    _contentLabel1.backgroundColor = [UIColor clearColor];
    [self addSubview:_contentLabel1];
    
    _contentLabel2 = [[UILabel alloc] initWithFrame:frame2];
    _contentLabel2.text = _text;
    _contentLabel2.font = _font;
    _contentLabel2.textColor = _textColor;
    _contentLabel2.backgroundColor = [UIColor clearColor];
    [self addSubview:_contentLabel2];
}

#pragma mark - 设置速度
-(void)setMoveSpeed:(CGFloat)speed{
    if (speed > 0.1) {
        if (_timer==nil) {
            _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(contentMove) userInfo:nil repeats:YES];

        }
        return;
    }
    if (speed < 0.001) {
        if (_timer==nil) {
            _timer = [NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(contentMove) userInfo:nil repeats:YES];
        }
        return;
    }
    
    if (_timer==nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:speed target:self selector:@selector(contentMove) userInfo:nil repeats:YES];
    }
}

#pragma mark - 内容移动
- (void)contentMove {

    if (_textWidth < self.frame.size.width) {//如果字符串长度小于控件宽度，不滚动
        
        if (_currentScrollModel == LMJTextScrollWandering) {//往返模式除外
            [self moveWandering];
        }
        return;
    }
    switch (_currentScrollModel) {
            
        case LMJTextScrollContinuous:
        {
            [self moveContinuous];
        }
            break;
        case LMJTextScrollIntermittent:
        {
            [self moveIntermittent];
        }
            break;
        case LMJTextScrollFromOutside:
        {
            [self moveFromOutside];
        }
            break;
        case LMJTextScrollWandering:
        {
            [self moveWandering];
        }
            break;
        default:
            break;
    }
}
//连续滚动
-(void)moveContinuous{
    if (_currentMoveDirection == LMJTextScrollMoveLeft) {
        _contentLabel1.frame = CGRectMake(_contentLabel1.frame.origin.x -1, 0, _textWidth, self.frame.size.height);
        _contentLabel2.frame = CGRectMake(_contentLabel2.frame.origin.x -1, 0, _textWidth, self.frame.size.height);
        if (_contentLabel1.frame.origin.x < -_textWidth) {
            _contentLabel1.frame = CGRectMake(_contentLabel2.frame.origin.x + _textWidth, 0, _textWidth, self.frame.size.height);
        }
        if (_contentLabel2.frame.origin.x < -_textWidth) {
            _contentLabel2.frame = CGRectMake(_contentLabel1.frame.origin.x + _textWidth, 0, _textWidth, self.frame.size.height);
        }
    }else{
        _contentLabel1.frame = CGRectMake(_contentLabel1.frame.origin.x +1, 0, _textWidth, self.frame.size.height);
        _contentLabel2.frame = CGRectMake(_contentLabel2.frame.origin.x +1, 0, _textWidth, self.frame.size.height);
        if (_contentLabel1.frame.origin.x > _textWidth) {
            _contentLabel1.frame = CGRectMake(_contentLabel2.frame.origin.x - _textWidth, 0, _textWidth, self.frame.size.height);
        }
        if (_contentLabel2.frame.origin.x > _textWidth) {
            _contentLabel2.frame = CGRectMake(_contentLabel1.frame.origin.x - _textWidth, 0, _textWidth, self.frame.size.height);
        }
    }
}
//间断滚动
-(void)moveIntermittent{
    if (_currentMoveDirection == LMJTextScrollMoveLeft) {
        _contentLabel1.frame = CGRectMake(_contentLabel1.frame.origin.x -1, 0, _textWidth, self.frame.size.height);
        if (_contentLabel1.frame.origin.x < -_textWidth) {
            _contentLabel1.frame = CGRectMake(0, 0, _textWidth, self.frame.size.height);
        }
    }else{
        _contentLabel1.frame = CGRectMake(_contentLabel1.frame.origin.x +1, 0, _textWidth, self.frame.size.height);
        if (_contentLabel1.frame.origin.x > self.frame.size.width) {
            _contentLabel1.frame = CGRectMake(self.frame.size.width -_textWidth, 0, _textWidth, self.frame.size.height);
        }
    }
}
//控件外开始滚动
-(void)moveFromOutside{
    if (_currentMoveDirection == LMJTextScrollMoveLeft) {
        _contentLabel1.frame = CGRectMake(_contentLabel1.frame.origin.x -1, 0, _textWidth, self.frame.size.height);
        if (_contentLabel1.frame.origin.x < -_textWidth) {
            _contentLabel1.frame = CGRectMake(self.frame.size.width, 0, _textWidth, self.frame.size.height);
        }
    }else{
        _contentLabel1.frame = CGRectMake(_contentLabel1.frame.origin.x +1, 0, _textWidth, self.frame.size.height);
        if (_contentLabel1.frame.origin.x > self.frame.size.width) {
            _contentLabel1.frame = CGRectMake(-_textWidth, 0, _textWidth, self.frame.size.height);
        }
    }
}
//往返滚动
-(void)moveWandering{
    _contentLabel1.frame = CGRectMake(_contentLabel1.frame.origin.x + _wanderingOffset, 0, _textWidth, self.frame.size.height);
    if (_contentLabel1.frame.origin.x < -(_textWidth -self.frame.size.width)) {
        _wanderingOffset = 1;
    }
    if (_contentLabel1.frame.origin.x > 2) {
        _wanderingOffset = -1;
    }
}

@end

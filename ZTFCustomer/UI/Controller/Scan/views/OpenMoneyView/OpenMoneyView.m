//
//  OpenMoneyView.m
//  WeiTown
//
//  Created by kakatool on 15/10/28.
//  Copyright © 2015年 Hairon. All rights reserved.
//

#import "OpenMoneyView.h"

@implementation OpenMoneyView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


-(id)initWithParentController:(UIViewController *)aParentCtrl
{
    if (self=[super init]) {
        
        self.snid = @"";
        
        self.parentCtrl = aParentCtrl;
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hide) name:@"Open_Coupon_Clicked" object:nil];
        
        [self prepareView];
    }
    
    return self;
}

-(void)prepareView
{
    
    if (self.parentCtrl) {
        
        self.frame = self.parentCtrl.view.frame;
        //        if (IS_IPHONE_5) {
        //            [self fixYForIPhone5:NO addHight:YES];
        //        }
        
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.6];
        
        if (_bgView==nil) {
            _bgView = [[UIView alloc] initWithSize:CGSizeMake(286, 271)];
            _bgView.backgroundColor = [UIColor clearColor];
            _bgView.center = self.center;
            [self addSubview:_bgView];
            
            //背景图片
            _bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 286, 271)];
            _bgImageView.image=[UIImage imageNamed:@"bg"];
            _bgImageView.backgroundColor=[UIColor clearColor];
            [_bgView addSubview:_bgImageView];
            
            //优惠券名称
            _nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 106, 286, 27)];
            _nameLbl.backgroundColor = [UIColor clearColor];
            _nameLbl.textColor = UIColorFromRGB(0xffa355);
            _nameLbl.textAlignment = NSTextAlignmentCenter;
            _nameLbl.font = [UIFont systemFontOfSize:15];
            [_bgView addSubview:_nameLbl];
            
            //数量
            _countLbl = [[UILabel alloc] initWithFrame:CGRectMake(127, 143, 52, 34)];
            _countLbl.backgroundColor = [UIColor clearColor];
            _countLbl.textColor = UIColorFromRGB(0xffeb72);
            _countLbl.textAlignment = NSTextAlignmentCenter;
            _countLbl.font = [UIFont systemFontOfSize:20];
            [_bgView addSubview:_countLbl];
            
            //金币图标
            _moneyImageView = [[UIImageView alloc] initWithFrame:CGRectMake(59, 125, 75, 57)];
            _moneyImageView.image = [UIImage imageNamed:@"money"];
            _moneyImageView.backgroundColor = [UIColor clearColor];
            [_bgView addSubview:_moneyImageView];
            
            //数量单位
            _counDescLbl = [[UILabel alloc] initWithFrame:CGRectMake(180, 143, 40, 34)];
            _counDescLbl.backgroundColor = [UIColor clearColor];
            _counDescLbl.textColor = [UIColor whiteColor];
            _counDescLbl.text=@"元";
            _counDescLbl.textAlignment = NSTextAlignmentLeft;
            _counDescLbl.font = [UIFont systemFontOfSize:23];
            [_bgView addSubview:_counDescLbl];
            
            //商户名称
            _shopLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 184, 286, 27)];
            _shopLbl.backgroundColor = [UIColor clearColor];
            _shopLbl.textColor = [UIColor whiteColor];
            _shopLbl.textAlignment = NSTextAlignmentCenter;
            _shopLbl.font = [UIFont systemFontOfSize:14];
            [_bgView addSubview:_shopLbl];
            
            
            //取消按钮
            self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.cancelBtn.frame = CGRectMake(100, 217, 92, 28);
            [self.cancelBtn setBackgroundImage:[UIImage imageNamed:@"btn"] forState:UIControlStateNormal];
            [self.cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [[self.cancelBtn titleLabel] setFont:[UIFont systemFontOfSize:14.0f]];
            [self.cancelBtn setTitle:@"知道了" forState:UIControlStateNormal];
            [self.cancelBtn addTarget:self action:@selector(hideByClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [_bgView addSubview:_cancelBtn];
            
        }
        
    }
}

-(void)show:(NSString *)content
{
    if (self.parentCtrl&&content) {
    
//    //测试
//    if (self.parentCtrl) {
//        //测试
//        content = @"恭喜您参加\"扫码送大米\"活动获得【千丝发艺】开门奖励10元";
    
        if ([self.parentCtrl.view.subviews containsObject:self]==NO) {
            
            
            NSString *shopName =  [self subStringFromString:content Begin:@"【" End:@"】"];
            if (shopName) {
                self.shopLbl.text = [NSString stringWithFormat:@"来自 %@",shopName];
            }
            
            content = [content stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"【%@】",shopName] withString:@""];
            
            NSString *name =  [self subStringFromString:content Begin:@"\"" End:@"\""];
            if (name) {
                self.nameLbl.text = [NSString stringWithFormat:@"%@",name];
            }
            
            content = [content stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"\"%@\"",name] withString:@""];
            
            NSString *countStr = [self subStringFromString:content End:@"开门奖励"];
            if (countStr) {
                
                countStr = [self subStringFromString:countStr Begin:@"元"];
                
                double count =0.00;
                
                @try {
                    count = [countStr doubleValue];
                    //保留两位小数的情况下并四舍五入
                    count += 0.0005;
                }
                @catch (NSException *exception) {
                    
                }
                @finally {
                    
                }

                NSString *str = [NSString stringWithFormat:@"%0.2f",count];
                UIFont *font = [UIFont systemFontOfSize:21];
//                CGSize textSize = [str sizeWithFont:font constrainedToSize:CGSizeMake(MAXFLOAT, 30)];
                CGSize textSize = [str boundingRectWithSize:CGSizeMake(MAXFLOAT, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
                
                self.countLbl.width = textSize.width;
                self.countLbl.x = _bgImageView.center.x;
                
                self.moneyImageView.x = self.countLbl.x - self.moneyImageView.width;
                self.counDescLbl.x = self.countLbl.x + self.countLbl.width + 10;
                
                self.countLbl.text = str;

            }
            
            [self.parentCtrl.view addSubview:self];
            
            [self showBubble];
            
        }
    }
}


-(void)hide
{
    if (self.parentCtrl) {
        [self removeFromSuperview];
    }
}

-(void)showBubble
{
    self.bgView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
    
    [UIView animateWithDuration:0.15 animations:^{
        
        self.bgView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
        self.bgView.hidden = NO;
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.15 animations:^{
            
            self.bgView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
            
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.15 animations:^{
                
                self.bgView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
                
            } completion:^(BOOL finished) {
                
                
            }];
            
        }];
        
        
    }];
    
}

//两个字符串之间的子字符串，不含being和end
-(NSString *)subStringFromString:(NSString*)content Begin:(NSString *)begin End:(NSString *)end
{
    if (!content) {
        return nil;
    }
    
    NSRange range1= [content rangeOfString:begin];
    
    if (range1.location==NSNotFound) {
        return nil;
    }
    
    content = [content substringFromIndex:range1.location+range1.length];
    
    if (!content||[content trim].length==0) {
        return nil;
    }
    
    
    NSRange range2= [content rangeOfString:end];
    
    if (range2.location==NSNotFound) {
        return nil;
    }
    
    content = [content substringToIndex:range2.location];
    
    if (!content||[content trim].length==0) {
        return nil;
    }
    
    return content;
    
}

//end后的字符串，不含end
-(NSString *)subStringFromString:(NSString*)content End:(NSString *)end
{
    if (!content) {
        return nil;
    }
    
    NSRange range1= [content rangeOfString:end];
    
    if (range1.location==NSNotFound) {
        return nil;
    }
    
    content = [content substringFromIndex:range1.location+range1.length];
    
    if (!content||[content trim].length==0) {
        return nil;
    }
    
    return content;
    
}

//begin前的字符串，不含begin
-(NSString *)subStringFromString:(NSString*)content Begin:(NSString *)begin
{
    if (!content) {
        return nil;
    }
    
    NSRange range1= [content rangeOfString:begin];
    
    if (range1.location==NSNotFound) {
        return nil;
    }
    
    content = [content substringToIndex:range1.location];
    
    if (!content||[content trim].length==0) {
        return nil;
    }
    
    return content;
    
}


//关闭
-(void)hideByClick:(id)sender
{
    // NSLog(@"hideByClick");
    [self hide];
}

@end

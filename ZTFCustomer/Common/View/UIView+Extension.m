//
//  UIView+Extension.m
//  ZTFCustomer
//
//  Created by mac on 16/10/20.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)


-(void)setViewCornerRadius:(CGFloat)cornerRadius{
    self.clipsToBounds = YES;
    self.layer.cornerRadius = cornerRadius;
    
}
-(void)setViewBorderColor:(UIColor *)borderColor{
    self.layer.borderColor = borderColor.CGColor;
}


@end

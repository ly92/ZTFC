//
//  UIView+NibStyle.h
//  mplus
//
//  Created by QFish on 10/16/14.
//  Copyright (c) 2014 geek-zoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (NibStyle)

#pragma mark -

@property (nonatomic) NSString * nibBackgroundColor;
@property (nonatomic) id nibBorderColor;
@property (nonatomic) NSNumber * nibBorderWidth;
@property (nonatomic) NSNumber * nibCornerRadius;
@property (nonatomic) NSNumber * nibAlpha;

@end

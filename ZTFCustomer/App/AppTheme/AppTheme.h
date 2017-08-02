//
//  AppTheme.h
//  yichao
//
//  Created by Chenyun on 15/4/2.
//  Copyright (c) 2015年 geek-zoo. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  定义各个页面所用到的字体及颜色 以及段落样式
 */
@interface AppTheme : NSObject

@singleton( AppTheme )

+ (UIColor *)mainColor;
+ (UIColor *)titleColor;
+ (UIColor *)subTitleColor;
+ (UIColor *)bgColor;
+ (UIColor *)lineColor;

#pragma mark - Line

+ (CGFloat)onePixel;

#pragma mark - UITabBarItem

+ (UITabBarItem *)itemWithImageName:(NSString *)imageName selectImageName:(NSString *)selectImageName title:(NSString *)title;

#pragma mark - UINavigationBarItem

+ (UIBarButtonItem *)itemWithContent:(id)content handler:(void (^)(id sender))handler;
+ (UIBarButtonItem *)backItemWithHandler:(void (^)(id sender))handler;

+ (NSMutableAttributedString *)timelineNameButtonwithName:(NSString *)name font:(CGFloat)font;

+ (NSMutableAttributedString *)attributedStringWithStr:(NSString *)str
                                                ranges:(NSArray *)ranges;

@end

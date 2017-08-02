//
//  AppTheme.h
//  yichao
//
//  Created by Chenyun on 15/4/2.
//  Copyright (c) 2015年 geek-zoo. All rights reserved.
//

#import "AppTheme.h"
#import "UIBarButtonItem+BlocksKit.h"
//#import "Aspects.h"

@implementation AppTheme

@def_singleton(AppTheme)

+ (void)load
{
	[[self class] setupAppearance];
}

+ (void)setupAppearance
{
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithColor:NAV_BG_COLOR]
                                       forBarMetrics:UIBarMetricsDefault];
    
    NSMutableDictionary * attribute = [NSMutableDictionary dictionaryWithObject:NAV_TEXTCOLOR forKey:NSForegroundColorAttributeName];
    
    if ( GT_IOS7 )
    {
        // 6.0
        [[UIBarButtonItem appearance] setBackgroundImage:[UIImage new]
                                                forState:UIControlStateNormal
                                              barMetrics:UIBarMetricsDefault];
        [[UITabBar appearance] setSelectionIndicatorImage:[UIImage new]];
    }
    else
    {
        // 7.0 +
        [attribute setObject:[UIFont systemFontOfSize:18] forKey:NSFontAttributeName];
    }
	[[UINavigationBar appearance] setTitleTextAttributes:attribute];

	[[UITabBar appearance] setTintColor:[AppTheme bgColor]];
	[[UITabBar appearance] setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]]];
    [[UITabBar appearance] setHeight:49];
}

+ (UIColor *)mainColor
{
    return [UIColor colorWithRGBValue:0x27A2F0];
}

+ (UIColor *)titleColor
{
	return [UIColor colorWithRGBValue:0x333B46];
}

+ (UIColor *)subTitleColor
{
	return [UIColor colorWithRGBValue:0xBFC7CC];
}

//背景颜色
+ (UIColor *)bgColor
{
    return [UIColor colorWithRGBValue:0xF2F3F4];
}

+ (UIColor *)lineColor
{
    return [UIColor colorWithRGBValue:0xE6E9EA];
}

#pragma mark - Line

+ (CGFloat)onePixel
{
	static CGFloat one;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		one = 1 / [UIScreen mainScreen].scale;
	});
	return one;
}

#pragma mark - UINavigationBarItem

+ (UIBarButtonItem *)itemWithContent:(id)content handler:(void (^)(id))handler
{
    UIBarButtonItem * item = nil;
    
    if ( [content isKindOfClass:[NSString class]] )
    {
        item = [[UIBarButtonItem alloc] bk_initWithTitle:content style:UIBarButtonItemStylePlain handler:handler];
        item.tintColor = NAV_TEXTCOLOR;
    }
    else if ( [content isKindOfClass:[UIImage class]] )
    {
        if ( GT_IOS7 )
        {
            item = [[UIBarButtonItem alloc] bk_initWithImage:[(UIImage *)content imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain handler:handler];
        }
        else
        {
            item = [[UIBarButtonItem alloc] bk_initWithImage:content style:UIBarButtonItemStylePlain handler:handler];
        }
    }
    
    return item;
}

+ (UIBarButtonItem *)backItemWithHandler:(void (^)(id sender))handler
{
	UIBarButtonItem * item = [self itemWithContent:[UIImage imageNamed:@"icon_back"] handler:handler];
	return item;
}

+ (UITabBarItem *)itemWithImageName:(NSString *)imageName selectImageName:(NSString *)selectImageName title:(NSString *)title
{
	UIImage * home  = [UIImage imageNamed:imageName];
	UIImage * homeS = [UIImage imageNamed:selectImageName];

    UITabBarItem * item = nil;
//    if ( GT_IOS7 )
//    {
        item = [[UITabBarItem alloc] initWithTitle:title image:home selectedImage:homeS];
        item.image = [home imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        item.selectedImage = [homeS imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        item.imageInsets = UIEdgeInsetsMake(-2, 0, 2, 0);
        item.titlePositionAdjustment = UIOffsetMake(0, 0);
        
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#238EEC"], NSFontAttributeName : [UIFont systemFontOfSize:11]} forState:UIControlStateSelected];
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor grayColor], NSFontAttributeName : [UIFont systemFontOfSize:11]} forState:UIControlStateNormal];
//    }
//    else
//    {
//        item = [[UITabBarItem alloc] initWithTitle:@"" image:nil tag:0];
//        UIImage * imageSelect = [UIImage imageNamed:[NSString stringWithFormat:@"%@_6_click", imageName]];
//        UIImage * imageUnSelect = [UIImage imageNamed:[NSString stringWithFormat:@"%@_6", imageName]];
//        [item setFinishedSelectedImage:imageSelect withFinishedUnselectedImage:imageUnSelect];
//        item.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
//    }

	return item;
}

+ (NSMutableAttributedString *)timelineNameButtonwithName:(NSString *)name font:(CGFloat)font
{
    UIFont * fontName = [UIFont systemFontOfSize:font];
    if ( GT_IOS7 )
    {
        fontName = [UIFont fontWithName:@"PingFangTC-Medium" size:font];
    }
    NSMutableAttributedString * nickName = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", name] attributes:@{                                                                                        NSFontAttributeName : fontName,                                                                                                                                                                             NSForegroundColorAttributeName : [UIColor colorWithRGBValue:0x576B95],
        }];
    return nickName;
}

#pragma mark - AttributedString

+ (NSMutableAttributedString *)attributedStringWithStr:(NSString *)str
                                                ranges:(NSArray *)ranges
{
    NSMutableAttributedString * attriString = [[NSMutableAttributedString alloc] initWithString:str];
    
    static NSDictionary * s1;
    static NSDictionary * s2;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSMutableParagraphStyle * ps = [[NSMutableParagraphStyle alloc] init];
        ps.lineSpacing = 3;
        ps.minimumLineHeight = 14;
        
        UIFont * fontName = [UIFont systemFontOfSize:15];
        if ( GT_IOS9 )
        {
            fontName = [UIFont fontWithName:@"PingFangTC-Medium" size:15];
        }
        
        s1 = @{
               NSFontAttributeName : fontName,
               NSForegroundColorAttributeName : [UIColor colorWithRGBValue:0x576B95],
               NSParagraphStyleAttributeName : ps,
               };
        s2 = @{
               NSFontAttributeName : [UIFont systemFontOfSize:15],
               NSForegroundColorAttributeName : [UIColor blackColor],
               NSParagraphStyleAttributeName : ps,
               };
    });
    
    [attriString addAttributes:s2 range:NSMakeRange(0, str.length)];

    for ( int i = 0; i < ranges.count; i++ )
    {
        NSTextCheckingResult * result = ranges[i];
        NSRange range = result.range;

        [attriString addAttributes:s1 range:range];
    }
    
    return attriString;
}

@end

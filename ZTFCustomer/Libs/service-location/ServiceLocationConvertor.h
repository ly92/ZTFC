//
//  ServiceLocationConvertor.h
//
//  Created by QFish on 7/3/14.
//  Copyright (c) 2014 geek-zoo. All rights reserved.
//

#import <Foundation/Foundation.h>

// iOS 系统默认获取到的是 WGS84，安卓端调用百度地图时，可以选择编码类型，支持 GCJ02 和 BD09ll

// 具体取哪种类型，三端保持一致就行，一般以后台为准，涉及到坐标拾取

/**
 *  地球坐标（国际标准） 转到 火星坐标（国测局标准）
 */
FOUNDATION_EXPORT CLLocationCoordinate2D ConvertLocationFromWGS84ToGCJ02(CLLocationCoordinate2D coordinate);

/**
 *  火星坐标 转到 百度坐标
 */
FOUNDATION_EXPORT CLLocationCoordinate2D ConvertLocationFromGCJ02ToBD09LL(CLLocationCoordinate2D coordinate);

/**
 *  百度坐标 转到 火星坐标
 */
FOUNDATION_EXPORT CLLocationCoordinate2D ConvertLocationFromBD09LLToGCJ02(CLLocationCoordinate2D coordinate);
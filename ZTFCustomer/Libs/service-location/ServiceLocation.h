//
//  ServiceLocation.h
//  quchicha
//
//  Created by liuyadi on 15/10/14.
//  Copyright © 2015年 Geek Zoo Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

FOUNDATION_EXPORT NSString * const ServiceLocationGetLocationSucceedNotification;
FOUNDATION_EXPORT NSString * const ServiceLocationGetLocationFailNotification;
FOUNDATION_EXPORT NSString * const ServiceLocationReverseLocationSucceedNotification;
FOUNDATION_EXPORT NSString * const ServiceLocationReverseLocationFailNotification;

typedef NS_ENUM(NSUInteger, ServiceLocationSystemMode) {
    ServiceLocationSystemModeWGS84,   // 地球坐标系，国际标准经纬度，iOS 系统获取到的
    ServiceLocationSystemModeGCJ02,   // 火星坐标系，国测局制定
    ServiceLocationSystemModeBD09LL,  // 百度坐标系，
};

@interface ServiceLocation : NSObject <CLLocationManagerDelegate>

+ (instancetype)sharedLocation;

@property (nonatomic, assign) ServiceLocationSystemMode locationMode;
@property (nonatomic, strong) CLLocation * location;
@property (nonatomic, assign) BOOL isContinuous; // 是否一直定位

@property (nonatomic, copy) void (^whenGetLocation)(CLLocation * location, NSError * e);

// 开始定位，停止定位
- (void)startLocation;
- (void)stopLocation;

// 用户是否开启定位
- (BOOL)canLocate;

// 反地理编码
// placemark: CLLPlackmark, BMKReverseGeoCodeResult
- (void)reverseGeocodingLocation:(CLLocation *)location then:(void (^)(id placemark, NSError * e))then;

@end

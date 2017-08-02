//
//  BaseUrlFilter.h
//  EstateBiz
//
//  Created by Ender on 10/26/15.
//  Copyright © 2015 Magicsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <YTKNetworkConfig.h>
//#import <YTKNetworkPrivate.h>
#import "YTKNetworkConfig.h"
#import "YTKBaseRequest.h"

@interface BaseUrlFilter : NSObject<YTKUrlFilterProtocol>

//配置WeTown服务器参数
+ (BaseUrlFilter *)filterWithArguments:(NSDictionary *)arguments;

//配置卡卡兔服务器参数
+ (BaseUrlFilter *)filterKKTWithArguments:(NSDictionary *)arguments;
//配置ICE服务器
+ (BaseUrlFilter *)filterICEWithArguments:(NSDictionary *)arguments;
//配置模拟器服务器
+ (BaseUrlFilter *)filterSimulatorWithArguments:(NSDictionary *)arguments;

- (NSString *)filterUrl:(NSString *)originUrl withRequest:(YTKBaseRequest *)request;

@end

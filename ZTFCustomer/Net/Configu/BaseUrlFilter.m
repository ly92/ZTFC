//
//  BaseUrlFilter.m
//  EstateBiz
//
//  Created by Ender on 10/26/15.
//  Copyright © 2015 Magicsoft. All rights reserved.
//

#import "BaseUrlFilter.h"
#import "AFURLRequestSerialization.h"
#import "UIDevice+MacAddress.h"
#import "UIDevice+Hardware.h"
#import "NSString+helper.h"

@implementation BaseUrlFilter{
    
    NSDictionary *_arguments;
}

//配置WeTown服务器参数
+ (BaseUrlFilter *)filterWithArguments:(NSDictionary *)arguments {
    
    if (arguments==nil) {

        NSString *device = [[UIDevice currentDevice] uniqueDeviceIdentifier];
        NSString *ver1 = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
        NSString *ver = [ver1 stringByReplacingOccurrencesOfString:@"." withString:@""];
        NSString *model = [[[UIDevice currentDevice] platformString] trim];
        NSString *sdkver = [[UIDevice currentDevice] systemVersion];
        NSString *ct=@"c";
        
        //设置token
        //[LocalData getAccessToken];
//        NSString *kkToken = [STICache.global objectForKey:@"ACCESSTOKEN"];
//        if (kkToken == nil) {
//            kkToken = @"";
//        }
         NSString *kkToken = [LocalData getAccessToken];
        UserModel *user = [[LocalData shareInstance] getUserAccount];
        NSString *cid = @"";
        if (user) {
            cid=user.cid;
        }
    
        NSDate *date = [NSDate date];
        NSString *timeStamp = [NSString stringWithFormat:@"%.f",[date timeIntervalSince1970]];
        
        NSString *token = [[NSString stringWithFormat:@"%@%@%@",cid,kkToken,timeStamp] MD5Hash];
        
        return [[self alloc]initWithArguments:@{@"device":device,
                                                @"ver":ver,
                                                @"model":model,
                                                @"platform":APP_PLATFORM,
                                                @"sdkver":sdkver,
                                                @"token":token,
                                                @"ct":ct,
                                                @"cid":cid,
                                                @"timestamp":timeStamp,
                                                @"appid":APP_ID}];

        
    }
    else{
         return [[self alloc] initWithArguments:arguments];
    }
   
}

//配置卡卡兔参数
+ (BaseUrlFilter *)filterKKTWithArguments:(NSDictionary *)arguments{
    
    if (arguments==nil) {
        
        NSString *device = [[UIDevice currentDevice] uniqueDeviceIdentifier];
//        NSString *ver = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
        NSString *ver1 = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
        //        NSArray *arr = [ver1 componentsSeparatedByString:@"."];
        //        NSString *ver = [arr componentsJoinedByString:@""];
        NSString *ver = [ver1 stringByReplacingOccurrencesOfString:@"." withString:@""];
        NSString *model = [[[UIDevice currentDevice] platformString] trim];
        NSString *sdkver = [[UIDevice currentDevice] systemVersion];
        NSString *ct=@"c";
        
        
        //设置token
        //[LocalData getAccessToken];
//        NSString *kkToken = [STICache.global objectForKey:@"ACCESSTOKEN"];
//        if (kkToken == nil) {
//            kkToken = @"";
//        }
         NSString *kkToken = [LocalData getAccessToken];
        
        return [[self alloc]initWithArguments:@{@"device":device,
                                                @"ver":ver,
                                                @"model":model,
                                                @"platform":APP_PLATFORM,
                                                @"sdkver":sdkver,
                                                @"token":kkToken,
                                                @"ct":ct,
                                                @"appid":APP_ID}];
        
        
    }
    else{
        return [[self alloc] initWithArguments:arguments];
    }
}
//配置ice服务器参数
+ (BaseUrlFilter *)filterICEWithArguments:(NSDictionary *)arguments {
    
    if (arguments==nil) {
        
        NSString *timeStamp = [NSString stringWithFormat:@"%d",(int)[[NSDate date] timeIntervalSince1970]];
        NSString *sign = [[[NSString stringWithFormat:@"%@%@%@%@",KAppId,timeStamp,kAppToken,KAppSignKay] MD5Hash] lowercaseString];//sign值
        UserModel *user = [[LocalData shareInstance] getUserAccount];
        NSString *cid = @"";
        if (user) {
            cid=user.cid;
        }
        NSString *device = [[UIDevice currentDevice] uniqueDeviceIdentifier];
        NSString *ver1 = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
        NSString *ver = [ver1 stringByReplacingOccurrencesOfString:@"." withString:@""];
        NSString *model = [[[UIDevice currentDevice] platformString] trim];
        NSString *sdkver = [[UIDevice currentDevice] systemVersion];
        NSString *ct=@"c";
        
        //设置token
        //[LocalData getAccessToken];
//        NSString *kkToken = [STICache.global objectForKey:@"ACCESSTOKEN"];
//        
//        if (kkToken == nil) {
//            kkToken = @"";
//        }
        NSString *kkToken = [LocalData getAccessToken];
        
        NSString *token = [[NSString stringWithFormat:@"%@%@%@",cid,kkToken,timeStamp] MD5Hash];
        
        return [[self alloc]initWithArguments:@{@"device":device,
                                                @"ver":ver,
                                                @"model":model,
                                                @"sdkver":sdkver,
                                                @"releasever":sdkver,
                                                @"ct":ct,
                                                @"platform":APP_PLATFORM,
                                                @"cid":cid,
                                                @"timestamp":timeStamp,
                                                @"token":token,
                                                @"sign":sign,
                                                @"ts":timeStamp,
                                                @"appID":KAppId
                                                }];
    }
    else{
        return [[self alloc] initWithArguments:arguments];
    }
    
}
//配置rap服务器
+ (BaseUrlFilter *)filterSimulatorWithArguments:(NSDictionary *)arguments {
    
    if (arguments==nil) {
        
        UserModel *user = [[LocalData shareInstance] getUserAccount];
        NSString *cid = @"";
        if (user) {
            cid=user.cid;
        }
        
//        return [[self alloc]initWithArguments:@{@"cid":cid}];
        
        return [[self alloc]initWithArguments:@{}];
        
    }
    else{
        return [[self alloc] initWithArguments:arguments];
    }
    
}
- (id)initWithArguments:(NSDictionary *)arguments {
    self = [super init];
    if (self) {
        _arguments = arguments;
    }
    return self;
}

- (NSString *)filterUrl:(NSString *)originUrl withRequest:(YTKBaseRequest *)request {

    NSLog(@"_arguments:%@",request.requestArgument);
//    return [YTKNetworkPrivate urlStringWithOriginUrlString:originUrl appendParameters:_arguments];
    
    return [self urlStringWithOriginUrlString:originUrl appendParameters:_arguments];
}
- (NSString *)urlStringWithOriginUrlString:(NSString *)originUrlString appendParameters:(NSDictionary *)parameters {
    NSString *filteredUrl = originUrlString;
    NSString *paraUrlString = [self urlParametersStringFromParameters:parameters];
    if (paraUrlString && paraUrlString.length > 0) {
        if ([originUrlString rangeOfString:@"?"].location != NSNotFound) {
            filteredUrl = [filteredUrl stringByAppendingString:paraUrlString];
        } else {
            filteredUrl = [filteredUrl stringByAppendingFormat:@"?%@", [paraUrlString substringFromIndex:1]];
        }
        return filteredUrl;
    } else {
        return originUrlString;
    }
}
- (NSString *)urlParametersStringFromParameters:(NSDictionary *)parameters {
    NSMutableString *urlParametersString = [[NSMutableString alloc] initWithString:@""];
    
    
    if (parameters && parameters.count > 0) {
        for (NSString *key in parameters) {
            NSString *value = parameters[key];
            value = [NSString stringWithFormat:@"%@",value];
            value = [self urlEncode:value];
            [urlParametersString appendFormat:@"&%@=%@", key, value];
        }
    }
    return urlParametersString;
}
- (NSString*)urlEncode:(NSString*)str {
    
    return AFPercentEscapedStringFromString(str);
}

@end

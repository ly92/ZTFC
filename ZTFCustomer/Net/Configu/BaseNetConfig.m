//
//  BaseNetConfig.m
//  EstateBiz
//
//  Created by Ender on 10/26/15.
//  Copyright © 2015 Magicsoft. All rights reserved.
//

#import "BaseNetConfig.h"
#import <YTKNetworkConfig.h>
#import <YTKNetworkAgent.h>
#import "BaseUrlFilter.h"

//#pragma mark - 中铁建服务器
////#define CRCCBASE_URL_1 @"http://crcc.kakatool.cn:8091/api/" //中铁建正式服务器
//#define CRCCBASE_URL_1 @"https://crcc.kakatool.cn/api" //中铁建正式服务器(https)
//#define CRCCBASE_URL_2 @"http://wttest.kakatool.cn:8080/api/"//中铁建测试服务器
//
//#pragma mark - 卡卡兔服务器
//#define KAKABASE_URL_1 @"https://api.kakatool.com/"//卡卡兔服务器
//#define KAKABASE_URL_2 @"http://test.kakatool.cn:8082/"    //卡卡兔外部测试
//#define KAKABASE_URL_3 @"http://gaoye.kakatool.com/"   //外部正式测试
//
//#pragma mark - ice服务器
//#define ICEBASE_URL_1 @"http://120.77.55.129:8081/v1/"//ice服务器
//
//#define RAPBASE_URL_1 @"http://rap.taobao.org/mockjs/7227/"//rap服务器


/**
 *教程：https://github.com/yuantiku/YTKNetwork/blob/master/BasicGuide.md
 *https://github.com/yuantiku/YTKNetwork/blob/master/ProGuide.md
 *
 */
 

@implementation BaseNetConfig

+(BaseNetConfig *)shareInstance
{
    
    static id baseNetConfig = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
       
        baseNetConfig = [[self alloc] init];
        
    });
    return baseNetConfig;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

//配置WeTown服务器
-(void)configGlobalAPI:(YTkServer)server
{
    YTKNetworkConfig *config = [YTKNetworkConfig sharedConfig];
        switch (server) {
        case WETOWN:{
            config.baseUrl=CRCCBASE_URL_1;
            BaseUrlFilter *filter = [BaseUrlFilter filterWithArguments:nil];
            [config clearUrlFilter];
            [config addUrlFilter:filter];
        }
            break;
        case KAKATOOL:{
            config.baseUrl= KAKABASE_URL_1;
            BaseUrlFilter *filter = [BaseUrlFilter filterKKTWithArguments:nil];
            [config clearUrlFilter];
            [config addUrlFilter:filter];
        }
            break;
        case SIMULATOR:{
            config.baseUrl= RAPBASE_URL_1;
            BaseUrlFilter *filter = [BaseUrlFilter filterSimulatorWithArguments:nil];
            [config clearUrlFilter];
            [config addUrlFilter:filter];
            break;
        }
        case ICE:{
            config.baseUrl= ICEBASE_URL_1;
            BaseUrlFilter *filter = [BaseUrlFilter filterICEWithArguments:nil];
            [config clearUrlFilter];
            [config addUrlFilter:filter];
        }
            break;
        default:
            break;
    }
    config.cdnUrl=@"";
    
    //服务端返回格式问题，后端返回的结果不是"application/json"，afn 的 jsonResponseSerializer 是不认的。这里做临时处理
    YTKNetworkAgent *agent = [YTKNetworkAgent sharedAgent];
    [agent setValue:[NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json",@"text/html", nil]
         forKeyPath:@"jsonResponseSerializer.acceptableContentTypes"];
    
}
@end

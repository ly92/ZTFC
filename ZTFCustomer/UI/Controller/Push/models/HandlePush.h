//
//  HandlePush.h
//  EstateBiz
//
//  Created by mac on 16/7/5.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HandlePush : NSObject

//处理推送信息
+(void)handelPushMessage:(NSDictionary *)userinfo;

//获取推送计数器
+(void)fetchPushAmounts;

//获取计数器（新方式）
+(void)fetchPushAmounts:(NSString *)pushType CardID:(NSString *)cardId;

@end

//
//  ChatUserManager.m
//  EstateBiz
//
//  Created by Ender on 4/27/16.
//  Copyright © 2016 Magicsoft. All rights reserved.
//

#import "ChatUserManager.h"
#import "STICache.h"
//#import "ChatUserApi.h"

const NSString *kChatUserCacheKey = @"chatkey_";
@implementation ChatUserManager

+(ChatUserManager *)shareInstance
{
    
    static id instance = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        
        instance = [[self alloc] init];
        
    });
    return instance;
}


//保存聊天用户信息
-(void)saveChatUser:(PropertyConstrulantModel *)user{
    if (!user) {
        return;
    }
    
//    [[STICache global] setObject:user forKey:[NSString stringWithFormat:@"%@%@",kChatUserCacheKey,user.im]];
}

//保存聊天用户信息(根据用户聊天id)
-(void)saveChatUserByIm:(NSString *)im{
    
    if(!im){
        return ;
    }
    //如果是超级管理员，则不读取
    if ([im isEqualToString:@"admin"]) {
        return ;
    }
    
    if([[STICache global] objectForKey:[NSString stringWithFormat:@"chatUser"]]){
        
        return;
    }
    
    [[BaseNetConfig shareInstance]configGlobalAPI:SIMULATOR];
    PropertyConstulantAPI *propertyConstulantApi = [[PropertyConstulantAPI alloc]init];
    propertyConstulantApi.propertyType = ISBINDPROPERTY;
    [propertyConstulantApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
//        [self dismissTips];
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
            
            PropertyConstrulantModel *user = [PropertyConstrulantModel mj_objectWithKeyValues:result[@"saler"]];
            user.easemob = im;
            [STICache.global setObject:user forKey:@"chatUser"];
//            [self saveChatUser:user];
            
        }else{
//            [self presentFailureTips:result[@"reason"]];
        }
        
    } failure:^(__kindof YTKBaseRequest *request) {
//        [self presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
    }];

    
    
//    ChatUserApi *userApi = [[ChatUserApi alloc] initWithSalemanIM:im];
//    [userApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
//        
//        
//        NSDictionary *dic = (NSDictionary *)request.responseJSONObject;
//        
//        if ([dic[@"code"] intValue] == 0) {
//            
//            NSDictionary *content = dic[@"content"];
//            if (!([ISNull isNilOfSender:content])) {
//                ChatUser *user = [ChatUser mj_objectWithKeyValues:content];
//                user.im = im;
//                [self saveChatUser:user];
//                
//            }
//            
//        }else{
//            
//            NSLog(@"%@",dic[@"message"]);
//        }
//        
//        
//    } failure:^(__kindof YTKBaseRequest *request) {
//        [NSString stringWithFormat:@"网络错误:%ld",(long)request.responseStatusCode];
//    }];
    
    
    
}

//获取聊天用户信息
-(ChatUser *)fetchChatUserByIm:(NSString *)im
{
    if (!im) {
        return nil;
    }
    
    
    ChatUser *user = (ChatUser *)[[STICache global] objectForKey:[NSString stringWithFormat:@"%@%@",kChatUserCacheKey,im]];
    
    return user;
    
    
}

@end

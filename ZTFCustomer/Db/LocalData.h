//
//  LocalData.h
//  EstateBiz
//
//  Created by Ender on 4/25/16.
//  Copyright © 2016 Magicsoft. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LocalData : NSObject

//单例
+(LocalData *)shareInstance;


//用户名密码记住操作
+(void)updateNormalUserInfo:(NSString *)Name Psw:(NSString *)psw;

+(NSMutableDictionary *)fetchNormalUserInfo;

//获取销售员账号
-(UserModel*)getUserAccount;
//更新销售员账号
-(void)updateUserAccount:(UserModel *)user;
//删除用户信息
-(void)removeUserAccount;


#pragma mark - 推送token

+(NSString *)getDeviceToken;
+(void)updateDeviceToken:(NSString *)aToken;

#pragma mark - Token 用于存储本地接口凭证

+(NSString *)getAccessToken;
+(void)updateAccessToken:(NSString *)aToken;

#pragma mark - 判断用户是否登录
-(BOOL)isLogin;

#pragma mark-门禁
#pragma mark -- 门禁收藏
+ (NSArray *)getLockBookmark;
+(void)removeLock:(NSDictionary *)lock;
+ (void)updateLockBookmark:(NSDictionary *)lock;
+ (BOOL)containLockBookmark:(NSString *)lockid;

#pragma mark - 蓝牙开门权限
+ (void)updateBleDoorLimit:(NSArray *)door;
+ (NSString *)getBleMacByQrcode:(NSString *)qrcode;
+ (BOOL)haveBleDoorLimit:(NSString *)qrcode;
#pragma mark - 开门纪录
+ (NSArray *)getOpenBleDoorLog;
+ (void)updateOpenBleDoorLog:(NSDictionary *)openLog;
+ (void)removeOpenBleDoorLog:(NSArray *)removed;


#pragma mark - 历史搜索（会员卡搜索）
+ (NSArray *)getMemberCardSearchOfHistoryRecord;
+ (void)updateMemberCardSearchOfHistoryRecord:(NSString *)record;
+ (void)removeMemberCardSearchOfHistoryRecord;
+ (void)removeMemberCardSearchOfHistoryRecord:(NSString *)record;


#pragma mark - 历史搜索（小区搜索）

+ (NSArray *)getCommunitySearchOfHistoryRecord;
+ (void)updateCommunitySearchOfHistoryRecord:(NSString *)record;
+ (void)removeCommunitySearchOfHistoryRecord;
+ (void)removeCommunitySearchOfHistoryRecord:(NSString *)record;



#pragma mark-首页卡片按照点击次数进行排序
+(NSArray *)getHomeCard;
+(void)updateHomeCard:(NSDictionary *)homeCard;
+(void)removeHomeCardWithBid:(NSString *)bid;
+(int)getClickCountWithBid:(NSString *)bid;

@end

//
//  LocalData.m
//  EstateBiz
//
//  Created by Ender on 4/25/16.
//  Copyright © 2016 Magicsoft. All rights reserved.
//

#import "LocalData.h"
#import "NSUserDefaults+Convenience.h"

#define TOKEN                       @"WT2.0_token"
#define DEVICETOKEN                 @"WT2.0_DEVICETOKEN"
#define APP_BUNDLEID @"com.magicsoft.appwt"
@implementation LocalData

+(LocalData *)shareInstance
{
    
    static id instance = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        
        instance = [[self alloc] init];
        
    });
    return instance;
}


//用户名密码
+(void)updateNormalUserInfo:(NSString *)Name Psw:(NSString *)psw
{
    NSMutableDictionary *normalUserInfo = [NSMutableDictionary dictionaryWithCapacity:0];
    [normalUserInfo setObject:Name forKey:@"account"];
    [normalUserInfo setObject:psw forKey:@"password"];
    
    [[NSUserDefaults standardUserDefaults] setObject:normalUserInfo forKey:@"NORMALUSERINFO"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSMutableDictionary *)fetchNormalUserInfo
{
    NSMutableDictionary *dict=  [[NSUserDefaults standardUserDefaults] objectForKey:@"NORMALUSERINFO"];
    if (dict) {
        return dict;
    }
    else
    {
        return nil;
    }
}


-(UserModel*)getUserAccount
{
    NSString *key = [NSString stringWithFormat:@"%@_account",APP_BUNDLEID];
    NSData *data =  [[NSUserDefaults standardUserDefaults] objectForKey:key or:nil];
    if(data){
        return [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    return nil;
    
}

-(void)updateUserAccount:(UserModel *)user
{
     NSString *key = [NSString stringWithFormat:@"%@_account",APP_BUNDLEID];
    if(user){
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:user];
        [[NSUserDefaults standardUserDefaults] saveObject:data forKey:key];
    }
    
    
}

-(void)removeUserAccount
{
    NSString *key = [NSString stringWithFormat:@"%@_account",APP_BUNDLEID];
    [[NSUserDefaults standardUserDefaults] resetValuesForKeys:@[key]];
}

#pragma mark - 推送token

+(NSString *)getDeviceToken
{
    NSString *token = [[NSUserDefaults standardUserDefaults] stringForKey:DEVICETOKEN];
    
    if (token==nil) {
        return @"";
    }
    
    return token;
    
}

+(void)updateDeviceToken:(NSString *)aToken
{
    if (aToken) {
        [[NSUserDefaults standardUserDefaults] setObject:aToken forKey:DEVICETOKEN];
    } else
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:DEVICETOKEN];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}
#pragma mark - Token 用于存储本地接口凭证

+(NSString *)getAccessToken
{
    NSString *token = [[NSUserDefaults standardUserDefaults] stringForKey:TOKEN];
    
    if (token==nil) {
        return @"";
    }
    
    return token;
}

+(void)updateAccessToken:(NSString *)aToken
{
    if (aToken) {
        [[NSUserDefaults standardUserDefaults] setObject:aToken forKey:TOKEN];
    }   else
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:TOKEN];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - 判断用户是否登录

-(BOOL)isLogin
{
    UserModel *target=[self getUserAccount];
    if (target==nil) {
        return NO;
    }
    return YES;
}


#pragma mark -- 门禁收藏
+ (NSArray *)getLockBookmark
{
    UserModel *detail = [[LocalData shareInstance]getUserAccount];
    if (detail) {
        NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"LOCKBOOKMARK_%@",detail.cid]];
        
        if (array) {
            return array;
        }
        
        
    }
    
    return [NSArray array];
}

+(void)removeLock:(NSDictionary *)lock{
    
    if (lock == nil) {
        return;
    }
    
    UserModel *detail = [[LocalData shareInstance]getUserAccount];
    if (detail) {
        
        NSMutableArray *historyArray = [NSMutableArray arrayWithCapacity:0];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSArray *array = [userDefaults objectForKey:[NSString stringWithFormat:@"LOCKBOOKMARK_%@",detail.cid]];
        if (array) {
            
            historyArray = [NSMutableArray arrayWithArray:array];
            
            BOOL iscontain = NO;
            
            for (NSDictionary *item in historyArray) {
                
                NSString *itemid =[item objectForKey:@"qrcode"];
                NSString *lockid = [lock objectForKey:@"qrcode"];
                
                if ([itemid isEqualToString:lockid]) {
                    iscontain=YES;
                    break;
                }
                
            }
            
            if (iscontain) {
                [historyArray removeObject:lock];
                
                [userDefaults setObject:historyArray forKey:[NSString stringWithFormat:@"LOCKBOOKMARK_%@",detail.cid]];
                [userDefaults synchronize];
            }
        }
    }
}

+ (void)updateLockBookmark:(NSDictionary *)lock
{
    if (lock == nil) {
        return;
    }
    
    UserModel *detail = [[LocalData shareInstance]getUserAccount];
    if (detail) {
        
        NSMutableArray *historyArray = [NSMutableArray arrayWithCapacity:0];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSArray *array = [userDefaults objectForKey:[NSString stringWithFormat:@"LOCKBOOKMARK_%@",detail.cid]];
        if (array) {
            
            historyArray = [NSMutableArray arrayWithArray:array];
            
            BOOL iscontain = NO;
            
            for (NSDictionary *item in historyArray) {
                
                NSString *itemid =[item objectForKey:@"qrcode"];
                NSString *lockid = [lock objectForKey:@"qrcode"];
                
                if ([itemid isEqualToString:lockid]) {
                    iscontain=YES;
                    break;
                }
                
            }
            
            if (!iscontain) {
                //                [historyArray addObject:lock];
                [historyArray insertObject:lock atIndex:0];
            }
            
        }
        else{
            [historyArray addObject:lock];
        }
        
        [userDefaults setObject:historyArray forKey:[NSString stringWithFormat:@"LOCKBOOKMARK_%@",detail.cid]];
        [userDefaults synchronize];
    }
}


+ (BOOL)containLockBookmark:(NSString *)lockid
{
    UserModel *detail = [[LocalData shareInstance]getUserAccount];
    if (detail) {
        
        NSMutableArray *historyArray = [NSMutableArray arrayWithCapacity:0];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSArray *array = [userDefaults objectForKey:[NSString stringWithFormat:@"LOCKBOOKMARK_%@",detail.cid]];
        if (array) {
            
            historyArray = [NSMutableArray arrayWithArray:array];
            
            BOOL iscontain = NO;
            
            for (NSDictionary *item in historyArray) {
                
                NSString *itemid =[item objectForKey:@"qrcode"];
                
                if ([itemid isEqualToString:lockid]) {
                    iscontain=YES;
                    break;
                }
                
            }
            
            return iscontain;
            
        }
    }
    
    return NO;
    
}


#pragma mark - 蓝牙开门权限
+ (NSString *)getBleDoorLimitWithDoorid:(NSString *)doorid{
    NSString *doorcode = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"Doorcode_%@_5.0.3",doorid]];
    if (doorcode){
        return doorcode;
    }
    
    return [NSString string];
}

+ (void)updateBleDoorLimit:(NSArray *)doors{
    /**
     {
     starttime = 0,
     extra = ,
     qrcode = GUOLING_4C39,
     unitid = 3000,
     bid = 10099767,
     factorytype = 2,
     stoptime = 0,
     time_range = 0,
     wifienable = 1,
     is_whitelist = 0,
     version = ,
     doorid = 1167,
     doorcode = 001583004c39,
     doortype = 1,
     wificode = 00158300,
     name = 龙冠商务中心蓝牙测试BLE4c39,
     conntype = 2
     },
     */
    
    
    if (doors == nil){
        return;
    }
    UserModel *detail = [[LocalData shareInstance]getUserAccount];
    /**
     每次都只存获取的新的权限
     */
    NSMutableArray *doorArray = [NSMutableArray array];
    
    for (NSDictionary *door in doors) {
        NSString *doorid = [door objectForKey:@"doorid"];
        NSString *bid = [door objectForKey:@"bid"];
        NSString *bleMac = [door objectForKey:@"wificode"];
        NSString *wifienable = [door objectForKey:@"wifienable"];
        NSString *doorName = [door objectForKey:@"name"];
        NSString *qrcode = [door objectForKey:@"qrcode"];
        
        if ([wifienable intValue] == 1){
            [self addBleMac:bleMac AndBid:bid AndDoorName:doorName AndDoorId:doorid AndQrcode:qrcode];
            [doorArray addObject:door];
        }
        
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:doorArray forKey:[NSString stringWithFormat:@"BleDoorLimit_%@_5.0.3",detail.cid]];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)haveBleDoorLimit:(NSString *)qrcode{
    UserModel *detail = [[LocalData shareInstance]getUserAccount];
    if (detail) {
        NSArray *doors = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"BleDoorLimit_%@_5.0.3",detail.cid]];
        if (doors) {
            for (NSDictionary *door in doors) {
                if ([[door objectForKey:@"qrcode"]isEqualToString:qrcode]){
                    return YES;
                }
            }
        }
    }
    return NO;
}

+ (NSString *)getBleMacByQrcode:(NSString *)qrcode{
    UserModel *detail = [[LocalData shareInstance]getUserAccount];
    if (detail) {
        NSString *fitness = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"BLEMAC_%@_%@_5.0.3",detail.cid,qrcode]];
        if (fitness) {
            return fitness;
        }
    }
    return [NSString string];
}

+ (void)addBleMac:(NSString *)mac AndBid:(NSString *)bid AndDoorName:(NSString *)name AndDoorId:(NSString *)doorid AndQrcode:(NSString *)qrcode{
    if (mac == nil || bid == nil) {
        return;
    }
    
    UserModel *detail = [[LocalData shareInstance]getUserAccount];
    //    NSLog(@"%@",detail);
    NSString *fitness = [NSString stringWithFormat:@"%@*%@*%@*%@",mac,bid,name,doorid];
    if (detail) {
        
        [[NSUserDefaults standardUserDefaults] setObject:fitness forKey:[NSString stringWithFormat:@"BLEMAC_%@_%@_5.0.3",detail.cid,qrcode]];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
}


#pragma mark - 开门纪录
+ (NSArray *)getOpenBleDoorLog{
    NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:@"OpenBleDoorLog_5.0.3"];
    if (array){
        return array;
    }
    return [NSArray array];
}

+ (void)updateOpenBleDoorLog:(NSDictionary *)openLog{
    if (openLog == nil){
        return;
    }
    
    NSArray *array = [self getOpenBleDoorLog];
    NSMutableArray *arrayM = [NSMutableArray arrayWithArray:array];
    
    [arrayM addObject:openLog];
    
    [[NSUserDefaults standardUserDefaults] setObject:arrayM forKey:@"OpenBleDoorLog_5.0.3"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//将已经上传的数组删除
+ (void)removeOpenBleDoorLog:(NSArray *)removed{
    NSArray *array = [self getOpenBleDoorLog];
    NSMutableArray *arrayM = [NSMutableArray arrayWithArray:array];
    
    [arrayM removeObjectsInArray:removed];
    [[NSUserDefaults standardUserDefaults] setObject:arrayM forKey:@"OpenBleDoorLog_5.0.3"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}



#pragma mark - 历史搜索（会员卡搜索）

+ (NSArray *)getMemberCardSearchOfHistoryRecord
{
    if ([[LocalData shareInstance] isLogin]) {
        
        UserModel *user = [[LocalData shareInstance] getUserAccount];
        
        NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"historyRecord_%@_5.0.3",user.cid]];
        
        if (array) {
            return array;
        }
    }
    
    return nil;
}

+ (void)updateMemberCardSearchOfHistoryRecord:(NSString *)record
{
    if ([record trim].length == 0 || record == nil) {
        return;
    }
    
    
    if ([[LocalData shareInstance] isLogin]) {
        
        UserModel *user = [[LocalData shareInstance] getUserAccount];

        
        NSMutableArray *historyArray = [NSMutableArray arrayWithCapacity:0];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSArray *array = [userDefaults objectForKey:[NSString stringWithFormat:@"historyRecord_%@_5.0.3",user.cid]];
        if (array) {
            historyArray = [NSMutableArray arrayWithArray:array];
            
            if (historyArray.count == 6) {
                [historyArray removeLastObject];
                [historyArray insertObject:record atIndex:0];
            }
            
            if ([historyArray containsObject:record]) {
                [historyArray removeObject:record];
                [historyArray insertObject:record atIndex:0];
            }else {
                [historyArray insertObject:record atIndex:0];
            }
            
        }
        else {
            [historyArray addObject:record];
        }
        
        [userDefaults setObject:historyArray forKey:[NSString stringWithFormat:@"historyRecord_%@_5.0.3",user.cid]];
        [userDefaults synchronize];
    }
}

+ (void)removeMemberCardSearchOfHistoryRecord
{
    if ([[LocalData shareInstance] isLogin]) {
        UserModel *user = [[LocalData shareInstance] getUserAccount];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:[NSString stringWithFormat:@"historyRecord_%@_5.0.3",user.cid]];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (void)removeMemberCardSearchOfHistoryRecord:(NSString *)record{
    if ([record trim].length == 0 || record == nil) {
        return;
    }
    if ([[LocalData shareInstance] isLogin]) {
        
        UserModel *user = [[LocalData shareInstance] getUserAccount];
        
        NSMutableArray *historyArray = [NSMutableArray arrayWithCapacity:0];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSArray *array = [userDefaults objectForKey:[NSString stringWithFormat:@"historyRecord_%@_5.0.3",user.cid]];
        if (array) {
            historyArray = [NSMutableArray arrayWithArray:array];
            
            if ([historyArray containsObject:record]) {
                [historyArray removeObject:record];
            }
        }
        [userDefaults setObject:historyArray forKey:[NSString stringWithFormat:@"historyRecord_%@_5.0.3",user.cid]];
        [userDefaults synchronize];
    }
    
}

#pragma mark - 历史搜索（小区搜索）

+ (NSArray *)getCommunitySearchOfHistoryRecord
{
    UserModel *detail = [[LocalData shareInstance]getUserAccount];
    if (detail) {
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSArray *array = [userDefaults objectForKey:[NSString stringWithFormat:@"Community_historyRecord_%@",detail.cid]];
        
        if (array) {
            return array;
        }
    }
    
    return nil;
}

+ (void)updateCommunitySearchOfHistoryRecord:(NSString *)record
{
    if ([record trim].length == 0 || record == nil) {
        return;
    }
    
    UserModel *detail = [[LocalData shareInstance]getUserAccount];
    if (detail) {
        
        NSMutableArray *historyArray = [NSMutableArray arrayWithCapacity:0];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSArray *array = [userDefaults objectForKey:[NSString stringWithFormat:@"Community_historyRecord_%@",detail.cid]];
        if (array) {
            historyArray = [NSMutableArray arrayWithArray:array];
            
            if ([historyArray containsObject:record]) {
                [historyArray removeObject:record];
            }
            
            if (historyArray.count == 5) {
                //[historyArray replaceObjectAtIndex:0 withObject:record];
                [historyArray removeObjectAtIndex:historyArray.count-1];
                [historyArray insertObject:record atIndex:0];
            }
            else {
                [historyArray insertObject:record atIndex:0];
            }
        }
        else {
            [historyArray addObject:record];
        }
        
        [userDefaults setObject:historyArray forKey:[NSString stringWithFormat:@"Community_historyRecord_%@",detail.cid]];
        [userDefaults synchronize];
    }
}

+ (void)removeCommunitySearchOfHistoryRecord
{
    UserModel *detail = [[LocalData shareInstance]getUserAccount];
    if (detail) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults removeObjectForKey:[NSString stringWithFormat:@"Community_historyRecord_%@",detail.cid]];
        [userDefaults synchronize];
    }
}

//在查询结果中选中某一个时，先将纪录的输入字符清除再去纪录选中的查询结果
+ (void)removeCommunitySearchOfHistoryRecord:(NSString *)record{
    if ([record trim].length == 0 || record == nil) {
        return;
    }
    if ([[LocalData shareInstance] isLogin]) {
        
        UserModel *user = [[LocalData shareInstance] getUserAccount];
        
        NSMutableArray *historyArray = [NSMutableArray arrayWithCapacity:0];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSArray *array = [userDefaults objectForKey:[NSString stringWithFormat:@"Community_historyRecord_%@",user.cid]];
        if (array) {
            historyArray = [NSMutableArray arrayWithArray:array];
            
            if ([historyArray containsObject:record]) {
                [historyArray removeObject:record];
            }
        }
        [userDefaults setObject:historyArray forKey:[NSString stringWithFormat:@"Community_historyRecord_%@",user.cid]];
        [userDefaults synchronize];
    }
    
}


#pragma mark-首页卡片按照点击次数进行排序
+(NSArray *)getHomeCard{
    UserModel *detail = [[LocalData shareInstance]getUserAccount];
    
//    TUserDetail *detail = [TUserDetail getUserDetail];
    if (detail) {
         NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSArray *array = [userDefaults objectForKey:[NSString stringWithFormat:@"HOMECARDCLICK_%@",detail.cid]];
        if (array) {
            return array;
        }
    }
    
    return [NSArray array];
}

+(void)updateHomeCard:(NSDictionary *)homeCard{
    if (homeCard == nil) {
        return;
    }
    UserModel *detail = [[LocalData shareInstance]getUserAccount];

//    TUserDetail *detail = [TUserDetail getUserDetail];
    //    NSLog(@"%@",detail);
    if (detail) {
         NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSMutableArray *historyArray = [NSMutableArray arrayWithCapacity:0];
        
        NSArray *array = [userDefaults objectForKey:[NSString stringWithFormat:@"HOMECARDCLICK_%@",detail.cid]];
        if (array) {
            
            historyArray = [NSMutableArray arrayWithArray:array];
            
            BOOL iscontain = NO;
            
            for (NSDictionary *item in historyArray) {
                
                NSString *itemid =[item objectForKey:@"bid"];
                NSString *lockid = [homeCard objectForKey:@"bid"];
                
                if ([itemid isEqualToString:lockid]) {
                    iscontain=YES;
                    [historyArray removeObject:item];
                    [historyArray addObject:homeCard];
                    break;
                }
            }
            if (!iscontain) {
                [historyArray addObject:homeCard];
            }
            
        }
        else{
            [historyArray addObject:homeCard];
        }
        
        [userDefaults setObject:historyArray forKey:[NSString stringWithFormat:@"HOMECARDCLICK_%@",detail.cid]];
        [userDefaults synchronize];
    }
}
+(void)removeHomeCardWithBid:(NSString *)bid{
    if (bid == nil) {
        return;
    }
    UserModel *detail = [[LocalData shareInstance]getUserAccount];

//    TUserDetail *detail = [TUserDetail getUserDetail];
    if (detail) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSMutableArray *historyArray = [NSMutableArray arrayWithCapacity:0];
        
        NSArray *array = [userDefaults objectForKey:[NSString stringWithFormat:@"HOMECARDCLICK_%@",detail.cid]];
        if (array) {
            
            historyArray = [NSMutableArray arrayWithArray:array];
            
            for (NSDictionary *item in historyArray) {
                
                NSString *itemid =[item objectForKey:@"bid"];
                
                if ([itemid isEqualToString:bid]) {
                    [historyArray removeObject:item];
                    break;
                }
            }
            
        }
        
        [userDefaults setObject:historyArray forKey:[NSString stringWithFormat:@"HOMECARDCLICK_%@",detail.cid]];
        [userDefaults synchronize];
    }
    
}

+(int)getClickCountWithBid:(NSString *)bid{
    
    NSArray *array=[LocalData getHomeCard];
    for (NSDictionary *dic in array) {
        if ([[dic objectForKey:@"bid"] isEqualToString:bid]) {
            NSString *count=[dic objectForKey:@"clickCount"];
            return [count intValue];
        }
    }
    
    return 0;
}

@end

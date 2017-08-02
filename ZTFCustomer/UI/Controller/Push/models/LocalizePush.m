//
//  LocalizePush.m
//  CardToon
//
//  Created by fengwanqi on 13-11-15.
//  Copyright (c) 2013年 com.coortouch.ender. All rights reserved.
//
//#define PUSHDIC @"pushDic"

#import "LocalizePush.h"


static LocalizePush *localizePush;

@implementation LocalizePush

+(LocalizePush *)shareLocalizePush
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        localizePush = [[LocalizePush alloc] init];
    });
    
    return localizePush;
}

-(id)init
{
    if (self = [super init]) {

    }
    return self;
}

//卡包信息
-(void)cardBagMsg
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PushAdMessage" object:nil];
    
}
//重复登录
-(void)relogin
{
    
     [[AppDelegate sharedAppDelegate] showLogin];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"setupLogin" object:nil];
}
//删除会员
-(void)deleteMember
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteMember" object:nil];
}


/**
 *  获取本地推送数目
 *
 *  @return 数组
 */
-(NSMutableArray *)getPushArray
{
    NSMutableArray *target=nil;
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:PUSHDATA];
    if (data) {
        target = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    
    return target;
}

/**
 *  更新本地推送数目
 *
 *  @param array 更新数组
 */
-(void)updatePushArray:(NSMutableArray *)array
{
    if (array!=nil) {
        NSData *data=[NSKeyedArchiver archivedDataWithRootObject:array];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:PUSHDATA];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:PUSHDATA];

    }
     [[NSUserDefaults standardUserDefaults] synchronize];
}


#pragma mark - 更新本地气泡/清除服务器气泡

-(void)updateCardId:(NSString *)cardId Kind:(NSString *)kind Amounts:(NSString *)amouts
{
    
    NSMutableArray *pushArray = [self getPushArray];
    
    if (pushArray) {
        
       
        PushModel *subItem = nil;
        
        for (PushModel *item in pushArray) {
            
            if ([item.cardid isEqualToString:cardId]) {
                
                subItem = item;
                
                break;
            }
            
        }
        
        if (subItem) {
            
            int count = [amouts intValue];
            
          

            
            int clearCount =0;
            
            if ([kind isEqualToString:CardMsg]) {
                
                //更新数量
                if (count!=-1) {
                    
                    subItem.c1 = [NSString stringWithFormat:@"%d",count];
                }
                else{
                    //-1表示要清除服务器数量，保留原来数量，用于清除服务器
                    clearCount = [subItem.c1 intValue];
                    subItem.c1 = @"0";
                }
            }
            
            else if ([kind isEqualToString:ChargeMoney]) {
                
                //更新数量
                if (count!=-1) {
                    
                    subItem.c3 = [NSString stringWithFormat:@"%d",count];
                }
                else{
                    //-1表示要清除服务器数量，保留原来数量，用于清除服务器
                    clearCount = [subItem.c3 intValue];
                    subItem.c3 = @"0";
                }
            }
            else if ([kind isEqualToString:DeductMoney]) {
                
                //更新数量
                if (count!=-1) {
                    
                    subItem.c4 = [NSString stringWithFormat:@"%d",count];
                }
                else{
                    //-1表示要清除服务器数量，保留原来数量，用于清除服务器
                    clearCount = [subItem.c4 intValue];
                    subItem.c4 = @"0";
                }
            }
            
            else if ([kind isEqualToString:BookConfirm]) {
                
                //更新数量
                if (count!=-1) {
                    
                    subItem.c5 = [NSString stringWithFormat:@"%d",count];
                }
                else{
                    //-1表示要清除服务器数量，保留原来数量，用于清除服务器
                    clearCount = [subItem.c5 intValue];
                    subItem.c5 = @"0";
                }
            }
            else if ([kind isEqualToString:FeedbackReturn]) {
                
                //更新数量
                if (count!=-1) {
                    
                    subItem.c7 = [NSString stringWithFormat:@"%d",count];
                }
                else{
                    //-1表示要清除服务器数量，保留原来数量，用于清除服务器
                    clearCount = [subItem.c7 intValue];
                    subItem.c7 = @"0";
                }
            }
            else if ([kind isEqualToString:ChargePoints]) {
                
                //更新数量
                if (count!=-1) {
                    
                    subItem.c9 = [NSString stringWithFormat:@"%d",count];
                }
                else{
                    //-1表示要清除服务器数量，保留原来数量，用于清除服务器
                    clearCount = [subItem.c9 intValue];
                    subItem.c9 = @"0";
                }
            }
            else if ([kind isEqualToString:DeductPoints]) {
                
                //更新数量
                if (count!=-1) {
                    
                    subItem.c10 = [NSString stringWithFormat:@"%d",count];
                }
                else{
                    //-1表示要清除服务器数量，保留原来数量，用于清除服务器
                    clearCount = [subItem.c10 intValue];
                    subItem.c10 = @"0";
                }
            }
            else if ([kind isEqualToString:CancelMoney]) {
                
                //更新数量
                if (count!=-1) {
                    
                    subItem.c11 = [NSString stringWithFormat:@"%d",count];
                }
                else{
                    //-1表示要清除服务器数量，保留原来数量，用于清除服务器
                    clearCount = [subItem.c11 intValue];
                    subItem.c11 = @"0";
                }
            }
            else if ([kind isEqualToString:CancelPoints]) {
                
                //更新数量
                if (count!=-1) {
                    
                    subItem.c12 = [NSString stringWithFormat:@"%d",count];
                }
                else{
                    //-1表示要清除服务器数量，保留原来数量，用于清除服务器
                    clearCount = [subItem.c12 intValue];
                    subItem.c12 = @"0";
                }
            }
            else if ([kind isEqualToString:GetCoupon]) {
                
                //更新数量
                if (count!=-1) {
                    
                    subItem.c13 = [NSString stringWithFormat:@"%d",count];
                }
                else{
                    //-1表示要清除服务器数量，保留原来数量，用于清除服务器
                    clearCount = [subItem.c13 intValue];
                    subItem.c13 = @"0";
                }
            }
            else if ([kind isEqualToString:Events]) {
                
                //更新数量
                if (count!=-1) {
                    
                    subItem.c14 = [NSString stringWithFormat:@"%d",count];
                }
                else{
                    //-1表示要清除服务器数量，保留原来数量，用于清除服务器
                    clearCount = [subItem.c14 intValue];
                    subItem.c14 = @"0";
                }
            }
            else if ([kind isEqualToString:Votes]) {
                
                //更新数量
                if (count!=-1) {
                    
                    subItem.c15 = [NSString stringWithFormat:@"%d",count];
                }
                else{
                    //-1表示要清除服务器数量，保留原来数量，用于清除服务器
                    clearCount = [subItem.c15 intValue];
                    subItem.c15 = @"0";
                }
            }
            else if ([kind isEqualToString:GetOrder]) {
                
                //更新数量
                if (count!=-1) {
                    
                    subItem.c16 = [NSString stringWithFormat:@"%d",count];
                }
                else{
                    //-1表示要清除服务器数量，保留原来数量，用于清除服务器
                    clearCount = [subItem.c16 intValue];
                    subItem.c16 = @"0";
                }
            }
            
            
            //更新本地数据
            [self updatePushArray:pushArray];
            
            
            //刷新首页气泡
            //清空服务器气泡
            
            
        }
        
    }
}


#pragma mark - 执行本地气泡减1操作


-(void)updateLoaclCardId:(NSString *)cardId Kind:(NSString *)kind
{
    NSString *amount = [self getAmountCardId:cardId Kind:kind];
    
    int count = [amount intValue];
    
    count = count-1;//自减1
    
    //不能小于0，小于0将会请求清除服务器
    if (count<0) {
        count=0;
    }
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
    [dic setObject:[NSString stringWithFormat:@"%d",count] forKey:kind];
    NSMutableDictionary *msgDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [msgDic setObject:dic forKey:cardId];
    
    [[BaseNetConfig shareInstance]configGlobalAPI:KAKATOOL];
    UpdatePushAmountsAPI *updatePushAmountsApi = [[UpdatePushAmountsAPI alloc]initWithMsgDic:msgDic];
    [updatePushAmountsApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        
        if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
            
//            [[AppDelegate sharedAppDelegate].window.rootViewController dismissTips];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshHomeBadgle" object:nil];
            
            
        }else{
//             [[AppDelegate sharedAppDelegate].window.rootViewController presentFailureTips:result[@"reason"]];
        }
        
        
    } failure:^(__kindof YTKBaseRequest *request) {
//        [[AppDelegate sharedAppDelegate].window.rootViewController presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
        
    }];
    
    [self updateCardId:cardId Kind:kind Amounts:[NSString stringWithFormat:@"%d",count]];
    
}

#pragma mark - 根据cardId和类型获取气泡数量

-(NSString *)getAmountCardId:(NSString *)cardId Kind:(NSString *)kind
{
   
    
    NSMutableArray *pushArray = [self getPushArray];
    
    if (pushArray) {
        
        PushModel *subItem = nil;
        
        for (PushModel *item in pushArray) {
            
            if ([item.cardid isEqualToString:cardId]) {
                
                subItem = item;
                
                break;
            }
            
        }
        
        if (subItem) {
            
            int count = 0;

            if ([kind isEqualToString:CardMsg]) {
                
              count = [subItem.c1 intValue];
            }
            
            else if ([kind isEqualToString:ChargeMoney]) {
                
               count = [subItem.c3 intValue];
            }
            else if ([kind isEqualToString:DeductMoney]) {
                
               count = [subItem.c4 intValue];
            }
            
            else if ([kind isEqualToString:BookConfirm]) {
                
               count = [subItem.c5 intValue];
            }
            else if ([kind isEqualToString:FeedbackReturn]) {
                
                count = [subItem.c7 intValue];
            }
            else if ([kind isEqualToString:ChargePoints]) {
                
               count = [subItem.c9 intValue];
            }
            else if ([kind isEqualToString:DeductPoints]) {
                
               count = [subItem.c10 intValue];
            }
            else if ([kind isEqualToString:CancelMoney]) {
                
              count = [subItem.c11 intValue];
            }
            else if ([kind isEqualToString:CancelPoints]) {
                
               count = [subItem.c12 intValue];
            }
            else if ([kind isEqualToString:GetCoupon]) {
                
               count = [subItem.c13 intValue];
            }
            else if ([kind isEqualToString:Events]) {
                
               count = [subItem.c14 intValue];
            }
            else if ([kind isEqualToString:Votes]) {
                
               count = [subItem.c15 intValue];
            }
            else if ([kind isEqualToString:GetOrder]) {
                
              count = [subItem.c16 intValue];
            }

            
            return [NSString stringWithFormat:@"%d",count];
            
        }
        
    }
    
    return @"0";
    
}


#pragma mark - 移除所有气泡本地存储
-(void)removePushDic
{
    //NSLog(@"shop.bid = %@",shop.bid);
    NSUserDefaults *defauls = [NSUserDefaults standardUserDefaults];
    [defauls removeObjectForKey:PUSHDATA];
    [defauls synchronize];
    
}


#pragma mark - 根据cardId获取首页气泡

-(int)getHomeBadgle:(NSString *)cardId
{
    //NSLog(@"cardId : %@",cardId);
    
    NSMutableArray *pushArray = [self getPushArray];
    
    if (pushArray) {
        
        PushModel *subItem = nil;
        
        for (PushModel *item in pushArray) {
            
            if ([item.cardid isEqualToString:cardId]) {
                
                subItem = item;
                
                break;
            }
            
        }
        
        if (subItem) {
            
            int count = [subItem.c1 intValue]+[subItem.c3 intValue]+[subItem.c4 intValue]+[subItem.c5 intValue]+
                        [subItem.c7 intValue]+[subItem.c9 intValue]+[subItem.c10 intValue]+[subItem.c11 intValue]+
                        [subItem.c12 intValue]+[subItem.c13 intValue]+[subItem.c14 intValue]+[subItem.c15 intValue]+
                        [subItem.c6 intValue];
            
            //NSLog(@"count : %d",count);
            
            return count;
            
        }
    }
    
    return 0;
    
}


#pragma mark - 当删除卡片时，移除该卡片气泡本地存储

-(void)removePushDicWhenDelCard:(NSString *)cardId
{

    
    NSMutableArray *pushArray = [self getPushArray];
    
    if (pushArray) {
        
        PushModel *subItem = nil;
        
        for (PushModel *item in pushArray) {
            
            if ([item.cardid isEqualToString:cardId]) {
                
                subItem = item;
                
                break;
            }
            
        }
        
        if (subItem) {
            
            [pushArray removeObject:subItem];
            
            [self updatePushArray:pushArray];
            
        }
    }
    
    
}


#pragma mark - 获取设置优惠券气泡
-(int)getSettingBadgleWithCoupon
{
    NSMutableArray *pushArray = [self getPushArray];
    
    if (pushArray) {
        
        int total = 0;
        
        for (PushModel *item in pushArray) {
            
            
//            int count = [item.c1 intValue]+[item.c5 intValue] + [item.c7 intValue] + [item.c14 intValue] + [item.c15 intValue] +[item.c13 intValue];
//            
//            total+=count;
            
            total+=[item.c13 intValue];
//            NSLog(@"%@:%@",item.cardid,item.c13);
        }
        
        return total;
    }
    
    return 0;
}

#pragma mark - 移除设置优惠券气泡本地存储

-(void)removeSettingWithCouponPushDic
{
    NSMutableArray *pushArray = [self getPushArray];
    //NSLog(@"pushArray : %@",pushArray);
    
    if (![ISNull isNilOfSender:pushArray]) {
        
        int count = 0;
        
        NSMutableDictionary *msgs = [NSMutableDictionary dictionaryWithCapacity:0];
        
        for (PushModel *item in pushArray) {
            if (item.c13) {
                count += [item.c13 intValue];
                item.c13 = @"0";
                [msgs setObject:[NSMutableDictionary dictionaryWithObject:[NSString stringWithFormat:@"%d",count] forKey:@"c13"] forKey:item.cardid];
            }
        }
        
        [self updatePushArray:pushArray];
        
        //清空优惠券气泡
        
        [[BaseNetConfig shareInstance]configGlobalAPI:KAKATOOL];
        UpdatePushAmountsAPI *updatePushAmountsApi = [[UpdatePushAmountsAPI alloc]initWithMsgDic:msgs];
        [updatePushAmountsApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
            
            NSDictionary *result = (NSDictionary *)request.responseJSONObject;
            
            if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
                
                [[AppDelegate sharedAppDelegate].window.rootViewController dismissTips];
                
                
            }else{
                 [[AppDelegate sharedAppDelegate].window.rootViewController presentFailureTips:result[@"reason"]];
            }
            
        } failure:^(__kindof YTKBaseRequest *request) {
            if (request.responseStatusCode == 0) {
                [[AppDelegate sharedAppDelegate].window.rootViewController presentFailureTips:@"网络不可用，请检查网络链接"];
            }else{
                [[AppDelegate sharedAppDelegate].window.rootViewController presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
            }
          
        }];
        

    }
}

#pragma mark - 获取所有未读气泡
-(int)getUnReadBadgleCount
{
    
    NSMutableArray *pushArray = [self getPushArray];
    
    if (pushArray) {
        
        int total = 0;
        
        for (PushModel *subItem in pushArray) {
            
//            int count = [subItem.c1 intValue]+[subItem.c3 intValue]+[subItem.c4 intValue]+[subItem.c5 intValue]+
//            [subItem.c7 intValue]+[subItem.c9 intValue]+[subItem.c10 intValue]+[subItem.c11 intValue]+
//            [subItem.c12 intValue]+[subItem.c13 intValue]+[subItem.c14 intValue]+[subItem.c15 intValue]+[subItem.c5 intValue]+
//            [subItem.c6 intValue];
            
            int count = [subItem.c1 intValue]+[subItem.c5 intValue] + [subItem.c7 intValue] + [subItem.c14 intValue] + [subItem.c15 intValue] +[subItem.c13 intValue];
            
            total+=count;
        }
        
        return total;
    }
    
    return 0;
    
}

#pragma mark - 清除一个卡按数组移除
-(void)removeBudgleCardId:(NSString *)cardId KindArray:(NSArray *)kindArray
{
    
    NSMutableArray *pushArray = [self getPushArray];
    
    if (pushArray) {
        
        
        PushModel *subItem = nil;
        
        for (PushModel *item in pushArray) {
            
            if ([item.cardid isEqualToString:cardId]) {
                
                subItem = item;
                
                break;
            }
            
        }
        
        if (subItem) {
            
            NSMutableDictionary *postDic = [NSMutableDictionary dictionaryWithCapacity:2];
            NSMutableDictionary *msgs = [NSMutableDictionary dictionaryWithCapacity:2];
            
            for (NSString *kind in kindArray) {
                
                if ([kind isEqualToString:CardMsg]) {
   
                    [postDic setObject:subItem.c1 forKey:kind];
                    
                    subItem.c1=@"0";
                }
                
                else if ([kind isEqualToString:ChargeMoney]) {
                    
                   [postDic setObject:subItem.c3 forKey:kind];
                    subItem.c3=@"0";
                }
                else if ([kind isEqualToString:DeductMoney]) {
                    
                    [postDic setObject:subItem.c4 forKey:kind];
                    subItem.c4=@"0";
                }
                
                else if ([kind isEqualToString:BookConfirm]) {
                    
                    [postDic setObject:subItem.c5 forKey:kind];
                    subItem.c5=@"0";
                }
                else if ([kind isEqualToString:FeedbackReturn]) {
                    
                    [postDic setObject:subItem.c7 forKey:kind];
                    subItem.c7=@"0";
                }
                else if ([kind isEqualToString:ChargePoints]) {
                    
                    [postDic setObject:subItem.c9 forKey:kind];
                    subItem.c9=@"0";
                }
                else if ([kind isEqualToString:DeductPoints]) {
                    
                    [postDic setObject:subItem.c10 forKey:kind];
                    subItem.c10=@"0";
                }
                else if ([kind isEqualToString:CancelMoney]) {
                    
                   [postDic setObject:subItem.c11 forKey:kind];
                    subItem.c11=@"0";
                }
                else if ([kind isEqualToString:CancelPoints]) {
                    
                   [postDic setObject:subItem.c12 forKey:kind];
                    subItem.c12=@"0";
                }
                else if ([kind isEqualToString:GetCoupon]) {
                    
                    [postDic setObject:subItem.c13 forKey:kind];
                    subItem.c13=@"0";
                }
                else if ([kind isEqualToString:Events]) {
                    
                    [postDic setObject:subItem.c14 forKey:kind];
                    subItem.c14=@"0";
                }
                else if ([kind isEqualToString:Votes]) {
                    
                    [postDic setObject:subItem.c15 forKey:kind];
                    subItem.c15=@"0";
                }
                else if ([kind isEqualToString:GetOrder]) {
                    
                    [postDic setObject:subItem.c16 forKey:kind];
                    subItem.c16=@"0";
                }
                
            }
            
            
            [self updatePushArray:pushArray];
            
            
            if ([[postDic allKeys] count]>0) {
                
                [msgs setObject:postDic forKey:cardId];
                
                [[BaseNetConfig shareInstance]configGlobalAPI:KAKATOOL];
                UpdatePushAmountsAPI *updatePushAmountsApi = [[UpdatePushAmountsAPI alloc]initWithMsgDic:msgs];
                [updatePushAmountsApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
                    
                  
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMessage" object:nil];
                    
                    
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMsgCenterBadgle" object:nil];
                    
                      [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshHomeBadgle" object:nil];
                    
                    
                } failure:^(__kindof YTKBaseRequest *request) {
                    
                }];

                
                //重新刷新界面
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshHomeBadgle" object:nil];
            }
            
        }
       
    }
    
}


@end

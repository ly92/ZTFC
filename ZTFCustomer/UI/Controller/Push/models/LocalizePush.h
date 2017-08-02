//
//  LocalizePush.h
//  CardToon
//
//  Created by fengwanqi on 13-11-15.
//  Copyright (c) 2013年 com.coortouch.ender. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PushName.h"

@interface LocalizePush : NSObject
/*
 1）商户信息（软卡信息）C1 +cardid+mid
 2）商户信息（硬卡信息）C2 +bid+mid
 3）商户充值 C3 +cardid
 4）商户扣款 C4 +cardid
 5）预约确认 C5 +cardid
 6)重复登陆 C6
 7)反馈回复 C5 +cardid
 8)删除会员
 9)积分充值 C5 +cardid
 */

//卡包信息
-(void)cardBagMsg;
//重复登录
-(void)relogin;
//删除会员
-(void)deleteMember;

+(LocalizePush *)shareLocalizePush;

-(void)updateCardId:(NSString *)cardId Kind:(NSString *)kind Amounts:(NSString *)amouts;
-(NSString *)getAmountCardId:(NSString *)cardId Kind:(NSString *)kind;

//移除气泡本地存储
-(void)removePushDic;

//根据cardId获取首页气泡
-(int)getHomeBadgle:(NSString *)cardId;

//-(int)updataMessageCountCardId:(NSString *)cardId Kind:(NSString *)kind;

//2014-4-4
//当删除卡片时，移除该卡片气泡本地存储
-(void)removePushDicWhenDelCard:(NSString *)cardId;

//获取设置优惠券气泡
-(int)getSettingBadgleWithCoupon;

//移除设置优惠券气泡本地存储
-(void)removeSettingWithCouponPushDic;

//获取所有未读气泡
-(int)getUnReadBadgleCount;

//清除一个卡按数组移除
-(void)removeBudgleCardId:(NSString *)cardId KindArray:(NSArray *)kindArray;

#pragma mark - 执行本地气泡减1操作
-(void)updateLoaclCardId:(NSString *)cardId Kind:(NSString *)kind;

@end

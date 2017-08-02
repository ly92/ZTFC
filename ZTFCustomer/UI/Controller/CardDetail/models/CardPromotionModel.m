//
//  CardPromotionModel.m
//  EstateBiz
//
//  Created by ly on 16/6/15.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "CardPromotionModel.h"
//PromotionMsg,Msg_Extinfo,PromotionInfo,PromotionItem;
@implementation CardPromotionModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"CardList" : @"PromotionModel"
             };
}
@end

@implementation PromotionModel

@end

@implementation BizTransactionInfo

@end

@implementation PromotionMsg

@end

@implementation Msg_Extinfo

+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"item" : @"PromotionItem"
             };
}
@end

@implementation PromotionInfo
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"ID" : @"id"
             };
}
@end

@implementation PromotionItem
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"ID" : @"id"
             };
}
@end




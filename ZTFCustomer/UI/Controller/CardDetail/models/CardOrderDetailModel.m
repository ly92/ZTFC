//
//  CardOrderDetailModel.m
//  EstateBiz
//
//  Created by ly on 16/6/16.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "CardOrderDetailModel.h"

@implementation CardOrderDetailModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"detaillist" : @"OrderDetailModel"
             };
}
@end
@implementation OrderDetailModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
        return @{
                 @"id" : @"ID"
                 };
}

@end

@implementation OrderInfo

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"id" : @"ID"
             };
}

@end
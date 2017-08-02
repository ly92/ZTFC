//
//  CardOrderModel.m
//  EstateBiz
//
//  Created by ly on 16/6/16.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "CardOrderModel.h"

@implementation CardOrderModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"orderlist" : @"OrderModel"
             };
}

@end

@implementation OrderModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{
             @"ID" : @"id"
             };
}
@end
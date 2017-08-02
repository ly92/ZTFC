//
//  CardTransactionDetailModel.m
//  EstateBiz
//
//  Created by ly on 16/6/15.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "CardTransactionDetailModel.h"

@implementation CardTransactionDetailModel

@end

@implementation TransactionDetailData
+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"transaction_coupon" : @"TransactionCoupon"
             };
}

@end

@implementation TransactionCoupon

@end
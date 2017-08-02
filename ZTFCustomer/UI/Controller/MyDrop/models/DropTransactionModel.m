//
//  DropTransactionModel.m
//  ZTFCustomer
//
//  Created by mac on 16/9/20.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "DropTransactionModel.h"

@implementation DropTransactionModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"typeName" : @"typename",
             };
}
@end

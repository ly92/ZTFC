//
//  ComplaintModel.m
//  ztfCustomer
//
//  Created by mac on 16/9/13.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "ComplaintModel.h"

@implementation ComplaintModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"typeName" : @"typename",
             };
}

@end

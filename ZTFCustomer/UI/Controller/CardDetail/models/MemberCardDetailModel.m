
//
//  MemberCardDetailModel.m
//  EstateBiz
//
//  Created by wangshanshan on 16/6/2.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "MemberCardDetailModel.h"


@implementation MemberCardDetailResultModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"branch" : @"Branch"
             };
}
@end

@implementation Card
@end

@implementation Businessinfo
@end

@implementation Cardinfo
@end

@implementation Bizswitch
@end

@implementation Branch
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"ID" : @"id"
             };
}
@end

@implementation MemberCardDetailModel

@end

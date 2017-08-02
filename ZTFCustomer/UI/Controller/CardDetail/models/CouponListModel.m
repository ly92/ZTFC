//
//  CouponListModel.m
//  EstateBiz
//
//  Created by ly on 16/6/14.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "CouponListModel.h"
@implementation CouponListModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"List" : @"CouponModel"
             };
}
@end
@implementation CouponModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"sns" : @"SnModel"
             };
}
@end
@implementation SnModel

@end

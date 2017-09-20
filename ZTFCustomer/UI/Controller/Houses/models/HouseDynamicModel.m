//
//  HouseDynamicModel.m
//  ZTFCustomer
//
//  Created by 李勇 on 2017/9/20.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "HouseDynamicModel.h"

@implementation HouseDynamicModel

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        [self mj_decode:aDecoder];
    }
    return self;
    
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [self mj_encode:aCoder];
}

//+(NSDictionary *)mj_objectClassInArray{
//    return @{@"progress_imgs":@"NSString"};
//}

@end

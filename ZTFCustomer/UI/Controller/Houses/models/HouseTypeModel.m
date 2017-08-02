//
//  HouseTypeModel.m
//  ztfCustomer
//
//  Created by mac on 16/7/14.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "HouseTypeModel.h"

@implementation HouseTypeModel

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        [self mj_decode:aDecoder];
    }
    return self;
    
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [self mj_encode:aCoder];
}



@end

//
//  HousesModel.m
//  ztfCustomer
//
//  Created by mac on 16/7/14.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "HousesModel.h"

@implementation HousesModel

+(NSDictionary *)mj_objectClassInArray{
    return @{@"housetypeList":@"HouseTypeModel",
             @"imageUrlList":@"ImageModel"};
}

@end

@implementation AreaOprionModel

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self == [super init]) {
        [self mj_decode:aDecoder];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [self mj_encode:aCoder];
}

@end

@implementation HouseTypeOptionModel
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self == [super init]) {
        [self mj_decode:aDecoder];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [self mj_encode:aCoder];
}

@end

@implementation PriceOptionModel

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self == [super init]) {
        [self mj_decode:aDecoder];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [self mj_encode:aCoder];
}

@end

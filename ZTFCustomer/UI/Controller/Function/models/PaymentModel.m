//
//  PaymentModel.m
//  ZTFCustomer
//
//  Created by mac on 16/9/21.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "PaymentModel.h"

@implementation PaymentModel

@end

@implementation PaymentAddressModel


@end


@implementation RegionModel

+(NSDictionary *)mj_objectClassInArray{
    return @{@"citys":@"RegionModel",
             @"districts":@"RegionModel"};
}
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

@implementation CommunityModel
+(NSDictionary *)mj_objectClassInArray{
    return @{@"build":@"BuildModel"};
}

@end

@implementation BuildModel

@end

@implementation AddressModel

@end


@implementation AppearModel
@end

@implementation OrderInfoModel



@end

//
//  SelectAddressAPI.m
//  ZTFCustomer
//
//  Created by mac on 16/9/21.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "SelectAddressAPI.h"


@interface SelectAddressAPI ()
{
    NSString *_id;
}
@end

@implementation SelectAddressAPI

-(instancetype)initWithId:(NSString *)id{
    if(self = [super init]){
        _id = id;
    }
    return self;
}
-(NSString *)requestUrl{
    switch (self.addressType) {
        case SELECTADDRESS_REGION:
            return @"payment/getRegion";
            break;
        case SELECTADDRESS_COMMUNITY:
           return @"payment/getCommunity";
            break;
        case SELECTADDRESS_BUILD:
            return @"payment/getBuild";
            break;
        case SELECTADDRESS_UNIT:
            return @"payment/getUnit";
            break;
            
        default:
            break;
    }
    
    
}
-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

-(id)requestArgument{
    
    switch (self.addressType) {
        case SELECTADDRESS_REGION:
            return nil;
            break;
        case SELECTADDRESS_COMMUNITY:
            
            return @{@"regionId":_id};
            break;
            
        case SELECTADDRESS_BUILD:
             return @{@"communityId":_id};
            break;
        case SELECTADDRESS_UNIT:
             return @{@"buildId":_id};
            break;
            
        default:
            break;
    }
    }


@end

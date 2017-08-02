//
//  HouseDetailAPI.m
//  ztfCustomer
//
//  Created by mac on 16/7/14.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "HouseDetailAPI.h"

@interface HouseDetailAPI ()
{
    NSString *_houseId;
}
@end

@implementation HouseDetailAPI

-(instancetype)initWithHoustId:(NSString *)houseId{
    if (self == [super init]) {
        _houseId = houseId;
    }
    return self;
}

-(NSString *)requestUrl{
    switch (self.operateHouse) {
            
        case HOUSEDETAIL:
            return PROJECT_DETAIL;
            break;
        case COLLECTHOUSE:
            return PROJECT_COLLECT;
            break;
        case CANCELCOLLECTHOUSE:
            return PROJECT_CANCELCOLLECT;
            break;
        case HOUSETYPEDETAIL:
            return @"housetype/detail";
            break;
        default:
            break;
            
    }
    
}

-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

-(id)requestArgument{
    switch (self.operateHouse) {
            
        case HOUSEDETAIL:
            return @{@"project_id":_houseId};
            break;
        case COLLECTHOUSE:
            return @{@"project_id":_houseId};
            break;
        case CANCELCOLLECTHOUSE:
            return @{@"project_id":_houseId};
            break;
        case HOUSETYPEDETAIL:
            return @{@"houseTypeId":_houseId};
            break;
        default:
            break;
            
    }
}
@end

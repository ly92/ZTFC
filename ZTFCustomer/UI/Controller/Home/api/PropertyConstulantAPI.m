//
//  PropertyConstulantAPI.m
//  ztfCustomer
//
//  Created by mac on 16/7/14.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "PropertyConstulantAPI.h"

@interface PropertyConstulantAPI ()
{
    NSString *_salemanIM;
   
    
    NSString *_communityId;
    NSString *_projectId;
    NSString *_key;
    NSString *_skip;
    NSString *_limit;
    
    
}
@end

@implementation PropertyConstulantAPI

-(instancetype)initWithSalemanIM:(NSString *)salemanIM{
    if (self == [super init]) {
        _salemanIM = salemanIM;
    }
    return self;
}


-(instancetype)initWithProjectId:(NSString *)projectId communityId:(NSString *)communityId key:(NSString *)key skip:(NSString *)skip limit:(NSString *)limit{
    if (self == [super init]) {
        _communityId = communityId;
        _projectId = projectId;
        _key = key;
        _skip = skip;
        _limit = limit;
    }
    return self;
}

-(NSString *)requestUrl{
    switch (self.propertyType) {
        case ISBINDPROPERTY:
            return HOME_MYEMPLOYEE;
            break;
        case CHATUSERINFO:
             return @"consultant/chatUser";
            break;
            
        default:
            break;
    }
   
}

-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

-(id)requestArgument{

    
    switch (self.propertyType) {
        case ISBINDPROPERTY:
            return @{@"community_id":_communityId,
                     @"project_id":_projectId,
                     @"key":_key,
                     @"skip":_skip,
                     @"limit":_limit};
            break;
        case CHATUSERINFO:
            return @{@"salemanIM":_salemanIM};
            break;
            
        default:
            break;
    }
    
   
}

@end

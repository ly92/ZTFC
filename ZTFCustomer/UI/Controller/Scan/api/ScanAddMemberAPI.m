//
//  ScanAddMemberAPI.m
//  EstateBiz
//
//  Created by wangshanshan on 16/6/15.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "ScanAddMemberAPI.h"

@interface ScanAddMemberAPI ()
{
    NSString *_recommendId;
    NSString *_bid;
}
@end

@implementation ScanAddMemberAPI

-(instancetype)initWithRecommendId:(NSString *)recommendId bid:(NSString *)bid{
    if (self == [super init]) {
        
        if ([ISNull isNilOfSender:recommendId]) {
            _recommendId = @"-1";
        }else{
            _recommendId = recommendId;
        }
        _bid = bid;
        
    }
    return self;
}


-(NSString *)requestUrl{
    return SHOP_DETAIL_URL;
}

-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

-(id)requestArgument{
    return @{@"recommendId":_recommendId,
             @"bid":_bid};
}

@end

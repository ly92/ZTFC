//
//  NoMemberCardDetailAPI.m
//  EstateBiz
//
//  Created by wangshanshan on 16/6/2.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "NoMemberCardDetailAPI.h"

@interface NoMemberCardDetailAPI ()
{
    NSString *_bid;
}
@end

@implementation NoMemberCardDetailAPI

-(instancetype)initWithBid:(NSString *)bid{
    if (self == [super init]) {
       
        _bid = bid;
        
    }
    return self;
}

-(NSString *)requestUrl{
    return HOME_RECOMMEND_CARD;
}

-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

-(id)requestArgument{
    return @{@"bid":_bid};
}

@end

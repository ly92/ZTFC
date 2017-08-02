//
//  AddMemberCardAPI.m
//  EstateBiz
//
//  Created by ly on 16/6/17.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "AddMemberCardAPI.h"

@interface AddMemberCardAPI()
{
    NSString *_cardId;
    NSString *_bid;
    NSString *_recommendId;
}

@end

@implementation AddMemberCardAPI
- (instancetype)initWithCardId:(NSString *)cardId Bid:(NSString *)bid RecommandId:(NSString *)recommendId{
    if (self = [super init]){
        _cardId = cardId;
        _bid = bid;
        _recommendId = recommendId;
    }
    return self;
}

-(NSString *)requestUrl{
    return ADDONLINECARD_URL;
}

-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

-(id)requestArgument{
    return @{@"cardId" : _cardId,
             @"bid" : _bid,
             @"recommendId" : _recommendId
             };
}

@end

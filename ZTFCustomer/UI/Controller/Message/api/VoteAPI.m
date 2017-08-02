//
//  VoteAPI.m
//  EstateBiz
//
//  Created by wangshanshan on 16/6/6.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "VoteAPI.h"


@interface VoteAPI ()
{
    NSString *_bid;
    NSString *_voteId;
    NSString *_itemId;
}
@end

@implementation VoteAPI

-(instancetype)initWithBid:(NSString *)bid voteId:(NSString *)voteId itemId:(NSString *)itemId{
    if (self == [super init]) {
        _bid = bid;
        _voteId = voteId;
        _itemId = itemId;
    }
    return self;
}

-(NSString *)requestUrl{
    return CARDMSG_VOTE_URL;
}
-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

-(id)requestArgument{
    return @{@"bid":_bid,
             @"vote_id":_voteId,
             @"item_id":_itemId};
}

@end

//
//  VoteAPI.h
//  EstateBiz
//
//  Created by wangshanshan on 16/6/6.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface VoteAPI : YTKRequest

-(instancetype)initWithBid:(NSString *)bid voteId:(NSString *)voteId itemId:(NSString *)itemId;

@end

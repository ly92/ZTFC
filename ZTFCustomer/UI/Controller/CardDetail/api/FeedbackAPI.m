//
//  FeedbackAPI.m
//  EstateBiz
//
//  Created by ly on 16/6/16.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "FeedbackAPI.h"

@interface FeedbackAPI ()
{
    NSString *_bid;
    NSString *_content;
    NSString *_contact;
}
@end

@implementation FeedbackAPI
- (instancetype)initWithBid:(NSString *)bid Content:(NSString *)content Contact:(NSString *)contact{
    if (self = [super init]){
        _bid = bid;
        _content = content;
        _contact = contact;
    }
    return self;
}

-(NSString *)requestUrl{
    return MEMBERFEEDBACK_ADD_URL;
}

-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

-(id)requestArgument{
    return @{@"bid" : _bid,
             @"content" : _content,
             @"contact" : _contact
             };
}


@end

//
//  OperateMemberCardAPI.m
//  ZTFCustomer
//
//  Created by mac on 2016/12/6.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "OperateMemberCardAPI.h"

@interface OperateMemberCardAPI ()
{
    NSString *_cardId;
    NSString *_cardType;
}
@end
@implementation OperateMemberCardAPI

-(instancetype)initWithCardId:(NSString *)cardId cardType:(NSString *)cardType{
    if (self == [super init]) {
        _cardId = cardId;
        _cardType = cardType;
    }
    return self;
}

-(NSString *)requestUrl{
    switch (self.operateMemberCardType) {
        case collectMemberCardType:
            return COLLECTCARD_ADD;
            break;
        case cancnelCollectMemberCardType:
            return COLLECTCARD_REMOVE;
        default:
            break;
    }
}

-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}
-(id)requestArgument{
    return @{@"cardId":_cardId,
             @"cardType":_cardType};
}

@end

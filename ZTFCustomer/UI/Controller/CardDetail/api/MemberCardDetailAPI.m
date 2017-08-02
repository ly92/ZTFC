//
//  MemberCardDetailAPI.m
//  EstateBiz
//
//  Created by wangshanshan on 16/6/2.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "MemberCardDetailAPI.h"

@interface MemberCardDetailAPI ()
{
    NSString *_cardId;
    NSString *_cardType;
}
@end

@implementation MemberCardDetailAPI

-(instancetype)initWithCardId:(NSString *)cardId cardType:(NSString *)cardType{
    if (self == [super init]) {
        
        _cardId = cardId;
        _cardType = cardType;
        
    }
    return self;
}

-(NSString *)requestUrl{
    return GETCARDINFO;
}

-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

-(id)requestArgument{
    return @{@"cardID":_cardId,
             @"cardType":_cardType};
}
@end

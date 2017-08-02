//
//  DeleteMemberCardAPI.m
//  EstateBiz
//
//  Created by wangshanshan on 16/6/20.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "DeleteMemberCardAPI.h"

@interface DeleteMemberCardAPI ()
{
    NSString *_cardId;
}
@end
@implementation DeleteMemberCardAPI

-(instancetype)initWithCardID:(NSString *)cardId{
    if (self == [super init]) {
        _cardId = cardId;
    }
    return self;
}

-(NSString *)requestUrl{
    return HOME_CARD_DELETE;
}

-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

-(id)requestArgument{
    return @{@"cardId":_cardId};
}

@end

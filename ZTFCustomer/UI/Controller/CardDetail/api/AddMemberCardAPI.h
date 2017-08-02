//
//  AddMemberCardAPI.h
//  EstateBiz
//
//  Created by ly on 16/6/17.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface AddMemberCardAPI : YTKRequest
- (instancetype)initWithCardId:(NSString *)cardId Bid:(NSString *)bid RecommandId:(NSString *)recommendId;
@end

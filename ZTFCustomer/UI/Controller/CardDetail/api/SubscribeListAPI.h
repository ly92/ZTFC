//
//  SubscribeListAPI.h
//  EstateBiz
//
//  Created by ly on 16/6/14.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface SubscribeListAPI : YTKRequest
- (instancetype)initWithBid:(NSString *)bid LastId:(NSString *)last_id Pagesize:(NSString *)pagesize;
@end

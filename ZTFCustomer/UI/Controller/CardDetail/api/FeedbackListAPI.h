//
//  FeedbackListAPI.h
//  EstateBiz
//
//  Created by ly on 16/6/16.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface FeedbackListAPI : YTKRequest
- (instancetype)initWithPagesize:(NSString *)pagesize LastId:(NSString *)last_id Bid:(NSString *)bid;
@end

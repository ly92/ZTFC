//
//  CardTransactionAPI.h
//  EstateBiz
//
//  Created by ly on 16/6/15.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface CardTransactionAPI : YTKRequest
- (instancetype)initWithBid:(NSString *)bid Limits:(NSString *)limits LastId:(NSString *)last_id LastDatetime:(NSString *)last_datetime;

@end

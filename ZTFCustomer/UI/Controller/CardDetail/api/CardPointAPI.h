//
//  CardPointAPI.h
//  EstateBiz
//
//  Created by ly on 16/6/16.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface CardPointAPI : YTKRequest
- (instancetype)initWithBid:(NSString *)bid Limits:(NSString *)limits LastId:(NSString *)last_id LastDatetime:(NSString *)last_datetime Cid:(NSString *)cid;
@end

//
//  SubscribeMerchantAPI.h
//  EstateBiz
//
//  Created by ly on 16/6/13.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface SubscribeMerchantAPI : YTKRequest
- (instancetype)initWithBid:(NSString *)bid BookTime:(NSString *)booktime Content:(NSString *)content;
@end

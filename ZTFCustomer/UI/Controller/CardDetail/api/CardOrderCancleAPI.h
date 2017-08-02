//
//  CardOrderCancleAPI.h
//  EstateBiz
//
//  Created by ly on 16/6/16.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface CardOrderCancleAPI : YTKRequest
- (instancetype)initWithOrderId:(NSString *)orderId;
@end

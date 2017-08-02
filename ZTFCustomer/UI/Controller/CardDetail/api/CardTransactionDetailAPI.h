//
//  CardTransactionDetailAPI.h
//  EstateBiz
//
//  Created by ly on 16/6/15.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface CardTransactionDetailAPI : YTKRequest
- (instancetype)initWithTid:(NSString *)tid;
@end

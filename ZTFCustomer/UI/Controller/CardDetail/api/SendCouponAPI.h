//
//  SendCouponAPI.h
//  EstateBiz
//
//  Created by ly on 16/6/14.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface SendCouponAPI : YTKRequest
- (instancetype)initWithSn:(NSString *)sn Mobile:(NSString *)mobile;
@end

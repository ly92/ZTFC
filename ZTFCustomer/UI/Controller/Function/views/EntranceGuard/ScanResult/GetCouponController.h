//
//  GetCouponController.h
//  colourlife
//
//  Created by 成运 on 16/3/3.
//  Copyright © 2016年 liuyadi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EntranceGuardController.h"
@interface GetCouponController : UIViewController

@property (nonatomic, strong) EntranceGuardController *entranceGuard;

- (id)initWithBid:(NSString *)aBid couponId:(NSString *)aCouponId;

@end

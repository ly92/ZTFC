//
//  VoucherTableViewController.h
//  colourlife
//
//  Created by ly on 16/1/6.
//  Copyright © 2016年 liuyadi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^RefreshBadgeBlock)();

@interface VoucherTableViewController : UIViewController

@property (nonatomic,assign) BOOL isCouponTicket;//门票跳转进来

- (instancetype)initWithBid:(NSString *)bid;

@property (nonatomic, copy) RefreshBadgeBlock refreshBadgeBlock;

@end

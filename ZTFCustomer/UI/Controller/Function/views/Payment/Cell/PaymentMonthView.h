//
//  PaymentMonthView.h
//  colourlife
//
//  Created by liuyadi on 16/1/8.
//  Copyright © 2016年 liuyadi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlertView.h"

@interface PaymentMonthView : UIView <AlertContentView>

@property (nonatomic, copy) void (^confirmOrder)(NSArray * orders);

@end

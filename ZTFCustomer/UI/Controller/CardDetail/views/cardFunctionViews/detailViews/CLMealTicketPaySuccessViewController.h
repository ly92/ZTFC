//
//  CLMealTicketPaySuccessViewController.h
//  colourlife
//
//  Created by 李勇 on 16/1/1.
//  Copyright © 2016年 Hairon. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BackWithoutPay)();

@interface CLMealTicketPaySuccessViewController : UIViewController

@property (nonatomic, copy) BackWithoutPay backWithPay;

- (instancetype)initWithOrderid:(NSString *)orderid;

@end

//
//  PayPasswordView.h
//  colourlife
//
//  Created by liuyadi on 16/1/14.
//  Copyright © 2016年 liuyadi. All rights reserved.
//

#import <UIKit/UIKit.h>

/* 
    Usage:
 
     PayPasswordView * passView = [PayPasswordView loadFromNib];
     
     @weakify(self);
     @weakify(passView);
     passView.confirmPay = ^(NSString * password) {
         @strongify(self);
         @strongify(passView);
 
         [passView endInput];
         // do checkPasswordRequest...
 
     };
     passView.hidden = YES;
     [self.view addSubview:passView];
 
 */

@interface PayPasswordView : UIView

@property (nonatomic, copy) void (^confirmPay)(NSString * password);

- (void)clear;

- (void)beginInput;
- (void)endInput;

@end

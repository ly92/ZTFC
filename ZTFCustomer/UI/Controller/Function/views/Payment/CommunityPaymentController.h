//
//  CommunityPaymentController.h
//  ZTFCustomer
//
//  Created by mac on 16/9/21.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^DidSelct)(PaymentAddressModel *address);

//缴费地址
@interface CommunityPaymentController : UIViewController

@property (nonatomic, copy) DidSelct didSelect;

@end

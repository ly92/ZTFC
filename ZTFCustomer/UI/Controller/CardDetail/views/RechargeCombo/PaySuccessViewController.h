//
//  PaySuccessViewController.h
//  WeiTown
//
//  Created by kakatool on 15/11/30.
//  Copyright © 2015年 Hairon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaySuccessViewController : UIViewController



- (instancetype)initWithPrice:(NSString *)price Payway:(NSString *)payway Orderid:(NSString *)orderid;


- (IBAction)goToOrderDetail:(id)sender;

@end

//
//  RechargeComboDetailViewController.h
//  WeiTown
//
//  Created by 李勇 on 16/3/2.
//  Copyright © 2016年 Hairon. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^payBlock)(NSString *price, NSString *payway,NSString *tnum);

@interface RechargeComboDetailViewController : UIViewController

@property (nonatomic, copy) payBlock paySuccess;

- (IBAction)payClick:(id)sender;

- (instancetype)initWithRechargeid:(NSString *)rechargeid;

@end

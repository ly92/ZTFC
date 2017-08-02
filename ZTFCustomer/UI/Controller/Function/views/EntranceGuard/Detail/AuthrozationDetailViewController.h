//
//  AuthrozationDetailViewController.h
//  colourlife
//
//  Created by mac on 16/1/8.
//  Copyright © 2016年 liuyadi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AuthrozationViewController.h"
@interface AuthrozationDetailViewController : UIViewController

@property (strong, nonatomic) ApplyModel *apply;
@property (nonatomic, strong) AuthrozationViewController *authController;

@property (nonatomic, strong) NSMutableArray *allowAuthArr;

@end

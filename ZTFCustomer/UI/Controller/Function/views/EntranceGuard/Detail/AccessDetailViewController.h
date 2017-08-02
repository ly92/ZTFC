//
//  AccessDetailViewController.h
//  colourlife
//
//  Created by mac on 16/1/14.
//  Copyright © 2016年 liuyadi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AuthrozationViewController.h"

typedef void (^RefreshAccessDetailBlock)();
@interface AccessDetailViewController : UIViewController

@property (nonatomic, copy) RefreshAccessDetailBlock refreshBlock;

@property (nonatomic, strong) ApplyModel *apply;

@property (nonatomic, strong) NSMutableArray *allowAuthArr;

@property (nonatomic, strong) AuthrozationViewController *authController;

@end

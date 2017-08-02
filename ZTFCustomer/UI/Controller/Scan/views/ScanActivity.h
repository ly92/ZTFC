//
//  ScanActivity.h
//  gaibianjia
//
//  Created by PURPLEPENG on 9/17/15.
//  Copyright (c) 2015 Geek Zoo Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EntranceGuardController.h"
#import "HomeViewController.h"
@interface ScanActivity : UIViewController

@property (nonatomic, copy) void (^whenGetScan)(NSString * scanValue);  // 扫一扫的结果

@property (nonatomic, strong) EntranceGuardController *entranceGuard;
@property (nonatomic, strong) HomeViewController *homeController;


@end

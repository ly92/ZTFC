//
//  OpenSuccessViewController.h
//  colourlife
//
//  Created by mac on 16/1/9.
//  Copyright © 2016年 liuyadi. All rights reserved.
//


#import <UIKit/UIKit.h>

#import "EntranceGuardController.h"

@interface OpenSuccessViewController : UIViewController


-(instancetype)initWithQrcodeByNet:(NSString *)qrcode;
-(instancetype)initWithQrcodebyBle:(NSString *)qrcode;

//@property (nonatomic, strong) EntranceGuardController *entranceGuard;

@end

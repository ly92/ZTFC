//
//  SubscribeMerchantViewController.h
//  colourlife
//
//  Created by ly on 16/1/14.
//  Copyright © 2016年 liuyadi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubscribeMerchantViewController : UIViewController
- (instancetype)initWithBid:(NSString *)bid Tel:(NSString *)tel;

@property (nonatomic, assign) BOOL isHouseDetail;

@end

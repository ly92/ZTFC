//
//  VoucherDetailViewController.h
//  colourlife
//
//  Created by ly on 16/1/12.
//  Copyright © 2016年 liuyadi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CouponModel;
typedef void(^ReloadTable)();

@interface VoucherDetailViewController : UIViewController

- (instancetype)initWithVOUCHER:(CouponModel *)voucher;

@property (nonatomic, copy) ReloadTable reloadTable;

@end

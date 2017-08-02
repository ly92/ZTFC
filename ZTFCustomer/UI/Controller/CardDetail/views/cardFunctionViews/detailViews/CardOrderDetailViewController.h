//
//  CardOrderDetailViewController.h
//  colourlife
//
//  Created by ly on 16/1/18.
//  Copyright © 2016年 liuyadi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ CancelBlock)();
@interface CardOrderDetailViewController : UIViewController

@property (nonatomic, copy) CancelBlock cancelBlock;

- (instancetype)initWithOrderId:(NSString *)orderid;
@end

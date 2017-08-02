//
//  CardPromotionDetailViewController.h
//  colourlife
//
//  Created by ly on 16/1/18.
//  Copyright © 2016年 liuyadi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PromotionModel;

@interface CardPromotionDetailViewController : UIViewController
- (instancetype)initWithBusName:(NSString *)name Promotion:(PromotionModel *)promotion;
@end

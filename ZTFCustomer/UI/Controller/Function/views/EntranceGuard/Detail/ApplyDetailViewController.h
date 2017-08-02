//
//  ApplyDetailViewController.h
//  colourlife
//
//  Created by mac on 16/1/6.
//  Copyright © 2016年 liuyadi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^RefreshApplyBlock)();

@interface ApplyDetailViewController : UIViewController

@property (strong, nonatomic) ApplyModel *apply;


@property (nonatomic, copy) RefreshApplyBlock refreshBlock;

@end

//
//  SelectCommunityController.h
//  EstateBiz
//
//  Created by mac on 16/7/1.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SelectCommunityBlock)(NSDictionary *str);

@interface SelectCommunityController : UIViewController

@property (nonatomic, copy) SelectCommunityBlock selectCommunity;

@end

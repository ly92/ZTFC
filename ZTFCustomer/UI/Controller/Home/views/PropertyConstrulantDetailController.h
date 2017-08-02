//
//  PropertyConstrulantDetailController.h
//  ztfCustomer
//
//  Created by mac on 16/7/4.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CancelBindingBlock) ();

@interface PropertyConstrulantDetailController : UIViewController

@property (nonatomic, assign) BOOL isSteward;

@property (nonatomic, copy) NSString *communityId;

@property (nonatomic, copy) CancelBindingBlock cancelBindingBlock;

@property (nonatomic, strong) PropertyConstrulantModel *propertyModel;

@end

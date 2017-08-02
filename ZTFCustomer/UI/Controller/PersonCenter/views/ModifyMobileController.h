//
//  ModifyMobileController.h
//  EstateBiz
//
//  Created by wangshanshan on 16/6/16.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^MobileBlock)(NSString *mobileString);

@interface ModifyMobileController : UITableViewController

@property (nonatomic, copy) MobileBlock mobileBlock;


@end

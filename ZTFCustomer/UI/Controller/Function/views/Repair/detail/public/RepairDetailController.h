//
//  RepairDetailController.h
//  WeiTown
//
//  Created by Ender on 8/28/15.
//  Copyright (c) 2015 Hairon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectCommunityController.h"
#import "SelectRepairSubtypeController.h"

@interface RepairDetailController : UIViewController


- (instancetype)initWithMainType:(NSString *)aType Order:(ComplaintModel *)item;


@end

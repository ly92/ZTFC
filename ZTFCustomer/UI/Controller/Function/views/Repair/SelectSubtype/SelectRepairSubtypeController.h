//
//  SelectRepairSubtypeController.h
//  WeiTown
//
//  Created by Ender on 8/29/15.
//  Copyright (c) 2015 Hairon. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SelectRepairSubtypeBlock)(RepairSubtypeModel *selectModel);

//@protocol SelectRepairSubtypeControllerDelegate <NSObject>
//
//-(void)selectRepairSubtypeCompleted:(RepairSubtypeModel *)selectItem;
//
//@end

@interface SelectRepairSubtypeController : UIViewController<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic, copy) SelectRepairSubtypeBlock selectSubtype;

//@property(assign,nonatomic) id<SelectRepairSubtypeControllerDelegate> delegate;
- (instancetype)initWithMainType:(NSString *)aType;


@end

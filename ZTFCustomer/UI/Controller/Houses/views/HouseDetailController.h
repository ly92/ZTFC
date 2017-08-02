//
//  HouseDetailController.h
//  ztfCustomer
//
//  Created by mac on 16/7/8.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HouseDetailController : UIViewController

@property (nonatomic, assign) BOOL isCollect;
@property (nonatomic, assign) BOOL isHouseList;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) HousesModel *houseModel;
@property (nonatomic, strong) NSMutableArray *houseArr;

@end

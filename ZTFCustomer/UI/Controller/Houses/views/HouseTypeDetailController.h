//
//  HouseTypeDetailController.h
//  ztfCustomer
//
//  Created by mac on 16/7/11.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface HouseTypeDetailController : UIViewController

@property (nonatomic, assign) BOOL isCollect;
@property (nonatomic, copy) NSString *projectId;
@property (nonatomic, strong) HouseTypeModel *houseTypeModel;


@end

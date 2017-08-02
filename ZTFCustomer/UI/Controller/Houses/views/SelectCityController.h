//
//  SelectCityController.h
//  ZTFCustomer
//
//  Created by mac on 16/9/23.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectCityController : UIViewController

@property (nonatomic, copy) void (^whenUpdated)(RegionModel * region);   // 选中城市，切换天气

@end

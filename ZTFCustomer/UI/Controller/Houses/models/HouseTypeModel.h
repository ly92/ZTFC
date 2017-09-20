//
//  HouseTypeModel.h
//  ztfCustomer
//
//  Created by mac on 16/7/14.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HouseTypeModel : NSObject<NSCoding>

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *name;//名字
@property (nonatomic, copy) NSString *covered_area;// 面积
@property (nonatomic, copy) NSString *model;//户型
@property (nonatomic, copy) NSString *orientation;//朝向
@property (nonatomic, strong) AlbumModel *album;
@property (nonatomic, copy) NSString *downpayment;
@property (nonatomic, copy) NSString *intro;
@property (nonatomic, copy) NSString *monthly_payment;
@property (nonatomic, copy) NSString *mobile;

@property (nonatomic, copy) NSString *is_favorite;


@property (nonatomic, copy) NSString *covered_price;

@property (nonatomic, strong) HousesModel *project;
@property (nonatomic, copy) NSString *project_id;
@end







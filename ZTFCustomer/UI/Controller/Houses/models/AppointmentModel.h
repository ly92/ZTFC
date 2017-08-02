//
//  AppointmentModel.h
//  ZTFCustomer
//
//  Created by mac on 16/9/19.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PropertyConstrulantModel;
@class HousesModel;

@interface AppointmentModel : NSObject

@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *creationtime;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *employee_id;
@property (nonatomic, copy) NSString *modifiedtime;
@property (nonatomic, copy) NSString *order_time;
@property (nonatomic, copy) NSString *project_id;
@property (nonatomic, copy) NSString *status;


@property (nonatomic, strong) PropertyConstrulantModel *employee;
@property (nonatomic, strong) HousesModel *project;

@end

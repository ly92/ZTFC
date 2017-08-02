//
//  HouseBookAPI.h
//  ZTFCustomer
//
//  Created by mac on 16/9/19.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>

//预约看房
@interface HouseBookAPI : YTKRequest


-(instancetype)initWithEmployyId:(NSString *)employeeId PojectId:(NSString *)projectid appointmenttime:(NSString *)appointmenttime memo:(NSString *)memo;

@end

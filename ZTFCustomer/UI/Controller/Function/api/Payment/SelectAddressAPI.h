//
//  SelectAddressAPI.h
//  ZTFCustomer
//
//  Created by mac on 16/9/21.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>
typedef NS_ENUM(NSInteger,SELECTADDRESSTYPE) {
    SELECTADDRESS_REGION, //获取省市区
    SELECTADDRESS_COMMUNITY,  //获取小区
    SELECTADDRESS_BUILD,//获取所有楼栋
    SELECTADDRESS_UNIT,//获取楼栋下的所有门牌号
};
@interface SelectAddressAPI : YTKRequest

@property (nonatomic, assign) SELECTADDRESSTYPE addressType;
-(instancetype)initWithId:(NSString *)id;

@end

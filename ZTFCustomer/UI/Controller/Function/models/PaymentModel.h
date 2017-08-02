//
//  PaymentModel.h
//  ZTFCustomer
//
//  Created by mac on 16/9/21.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PaymentModel : NSObject

@end

//缴费地址model
@interface PaymentAddressModel : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *communityName;
@property (nonatomic, copy) NSString *communityId;;

@property (nonatomic, copy) NSString *build;
@property (nonatomic, copy) NSString *room;
@property (nonatomic, copy) NSString *roomId;
@property (nonatomic, copy) NSString *buildId;


@end



@interface RegionModel : NSObject<NSCoding>

@property (nonatomic, strong) NSString * id;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * parent_id;
@property (nonatomic, strong) NSString * state;
@property (nonatomic, strong) NSString * is_deleted;
@property (nonatomic, strong) NSString * initial;
@property (nonatomic, strong) NSArray * citys;
@property (nonatomic, strong) NSArray * districts;
@property (nonatomic, copy) NSString *pid;
@property (nonatomic, copy) NSString *key;

@property (nonatomic, copy) NSString *lng;
@property (nonatomic, copy) NSString *lat;

//@property (nonatomic, copy) NSString *cityid;
//@property (nonatomic, copy) NSString *cityname;
//@property (nonatomic, copy) NSString *provinceid;





@end


@interface CommunityModel : NSObject
@property (nonatomic, strong) NSString * id;
@property (nonatomic, strong) NSString * region_id;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * alpha;
@property (nonatomic, strong) NSString * lat;
@property (nonatomic, strong) NSString * lng;

@property (nonatomic, strong) NSArray * build; //

@end

@interface BuildModel : NSObject

@property (nonatomic, strong) NSString * id;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * community_id;
@property (nonatomic, strong) NSString * colorcloud;

@end



@interface AddressModel : NSObject

@property (nonatomic, strong) NSString * id;
@property (nonatomic, strong) NSString * province_name; //省
@property (nonatomic, strong) NSString * citys_name;    //市
@property (nonatomic, strong) NSString * districts_name;//区
@property (nonatomic, strong) NSNumber * community_id;  //小区id
@property (nonatomic, strong) NSString * community_name;  //小区名称
@property (nonatomic, strong) NSString * colorcloud_id; //ERP小区id
@property (nonatomic, strong) NSString * build;         //楼栋名
@property (nonatomic, strong) NSString * build_id;      //楼栋id
@property (nonatomic, strong) NSString * room;          //门牌号
@property (nonatomic, strong) NSString * room_id;       //门牌号id

@end

@interface AppearModel : NSObject
@property (nonatomic, strong) NSString * billid;    // 欠费id
@property (nonatomic, strong) NSString * yearmonth; // 年月
@property (nonatomic, strong) NSString * itemname;  // 欠费项目
@property (nonatomic, strong) NSString * state; // 欠费状态
@property (nonatomic, strong) NSString * fee;   // 欠费金额
@property (nonatomic, strong) NSString * normalfee;
@property (nonatomic, strong) NSString * latefeerate;
@property (nonatomic, strong) NSString * latefee;
@property (nonatomic, strong) NSString * actualfee;
@property (nonatomic, strong) NSString * lastpaydate;
@property (nonatomic, strong) NSString * receivedfee;
@property (nonatomic, strong) NSString * category;
@end

@interface OrderInfoModel : NSObject
@property (nonatomic, strong) NSString * time;
@property (nonatomic, strong) NSString * totalMoney;

@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, assign) BOOL isSelected;
@end

//
//  CardOrderDetailModel.h
//  EstateBiz
//
//  Created by ly on 16/6/16.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
@class OrderInfo;
@interface CardOrderDetailModel : NSObject
@property (nonatomic, strong) NSArray *detaillist;
@property (nonatomic, strong) OrderInfo *orderinfo;
@property (nonatomic, strong) NSString * reason;
@property (nonatomic, strong) NSNumber * result;
@end


@interface OrderDetailModel : NSObject
@property (nonatomic, strong) NSString * amount;
@property (nonatomic, strong) NSString * ID;
@property (nonatomic, strong) NSString * orderid;
@property (nonatomic, strong) NSString * price;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * totalprice;

@end


@interface OrderInfo : NSObject
@property (nonatomic, strong) NSString * address;
@property (nonatomic, strong) NSString * advice;
@property (nonatomic, strong) NSString * alerttimes;
@property (nonatomic, strong) NSString * amount;
@property (nonatomic, strong) NSString * bid;
@property (nonatomic, strong) NSString * canceltime;
@property (nonatomic, strong) NSString * cid;
@property (nonatomic, strong) NSString * completetime;
@property (nonatomic, strong) NSString * confirmtime;
@property (nonatomic, strong) NSString * creationtime;
@property (nonatomic, strong) NSString * ID;
@property (nonatomic, strong) NSString * memo;
@property (nonatomic, strong) NSString * mobile;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * orderno;
@property (nonatomic, strong) NSString * ordertime;
@property (nonatomic, strong) NSString * ordertype;
@property (nonatomic, strong) NSString * rejecttime;
@property (nonatomic, strong) NSString * status;
@property (nonatomic, strong) NSString * tcid;
@property (nonatomic, strong) NSString * tid;
@property (nonatomic, strong) NSString * totalprice;

@end
//
//  CardOrderModel.h
//  EstateBiz
//
//  Created by ly on 16/6/16.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CardOrderModel : NSObject
@property (nonatomic, strong) NSString * last_id;
@property (nonatomic, strong) NSArray * orderlist;
@property (nonatomic, strong) NSString * reason;
@property (nonatomic, strong) NSNumber * result;
@end

@interface OrderModel: NSObject
@property (nonatomic, strong) NSString * advice;
@property (nonatomic, strong) NSString * amount;
@property (nonatomic, strong) NSString * creationtime;
@property (nonatomic, strong) NSString * memo;
@property (nonatomic, strong) NSString * ID;
@property (nonatomic, strong) NSString * orderno;
@property (nonatomic, strong) NSString * ordertype;
@property (nonatomic, strong) NSString * status;
@property (nonatomic, strong) NSString * totalprice;

@end
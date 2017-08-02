//
//  mydrop-module.h
//  ZTFCustomer
//
//  Created by mac on 16/9/19.
//  Copyright © 2016年 mac. All rights reserved.
//


typedef NS_ENUM(NSUInteger, PROPERTY_ORDER_STATUS) {
    PROPERTY_ORDER_STATUS_WAIT_PAY = 0, // 未处理
    PROPERTY_ORDER_STATUS_CANCEL = 98, // 订单已取消
    PROPERTY_ORDER_STATUS_PAY_SUCCESS = 99, //付款成功
};

typedef NS_ENUM(NSUInteger, PAYMENT_TYPE) {
    PAYMENT_TYPE_PROPERTY = 1,
    PAYMENT_TYPE_MANAGEMENT = 2,
    PAYMENT_TYPE_PARKING = 3,
    PAYMENT_TYPE_PLAN = 4,
};

typedef NS_ENUM(NSUInteger, PROPERTY_ORDER_STATE) {
    PROPERTY_ORDER_STATE_CLOSE = 0,
    PROPERTY_ORDER_STATE_OPEN = 1,
};

typedef NS_ENUM(NSUInteger, BIND_USER_TYPE) {
    BIND_USER_TYPE_BIND = 0,
    BIND_USER_TYPE_FORGET = 1,
};

typedef NS_ENUM(NSUInteger, SETTING_PASSWORD_TYPE) {
    SETTING_PASSWORD_TYPE_OLD = 0,
    SETTING_PASSWORD_TYPE_NEW = 1,
    SETTING_PASSWORD_TYPE_CONFIRM = 2,
};

typedef NS_ENUM(NSUInteger, PASSWORD_TYPE) {
    PASSWORD_TYPE_RESET = 0,
    PASSWORD_TYPE_SET = 1,
};

#import "GetDropAPI.h"
#import "DropModel.h"
#import "TransactionListAPI.h"
#import "DropTransactionModel.h"
#import "CheckOldPayPwdAPI.h"
#import "ResetPayPwdAPI.h"
#import "GetRechargeListAPI.h"
#import "CreateOrderAPI.h"
#import "RechargeModel.h"
#import "GiveDropAPI.h"
#import "GetUserInfoAPI.h"
#import "DropPayAPI.h"
#import "GetPayGalleryAPI.h"


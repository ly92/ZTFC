//
//  PushName.h
//  CardToon
//
//  Created by fengwanqi on 13-11-15.
//  Copyright (c) 2013年 com.coortouch.ender. All rights reserved.
//

#ifndef CardToon_PushName_h
#define CardToon_PushName_h

/*
 1）商户信息（软卡信息）
 2）商户信息（硬卡信息）
 3）商户充值
 4）商户扣款
 5）预约确认
 6）重复登录
 7）反馈回复 ###
 8）删除会员片 ###
 9）积分充值 ###
 10）积分消费 ###
 11）卡交易取消 ##
 12）积分交易取消 ##
 13）优惠券
 14）发送活动 ##
 15）发送投票 ##
 16）订单 ##
 */

//硬卡信息 c2
//
//重复登录 c6
//
//删除会员 c8
//
//BookConfirm c5
//
//CancelMoney = c11
//
//CancelPoints = c12
//
//CardMsg c1
//
//ChargeMoney c3
//
//ChargePoints c9
//
//DeductMoney c4
//
//DeductPoints c10
//
//Events = c14
//
//FeedbackReturn c7
//
//GetCoupon c13
//
//GetOrder c16
//
//Votes = c15



/**
 *  旧的方式，已废弃
 */

////卡信息
//#define CardMsg @"CardMsg"
////活动
//#define Events @"Events"
////投票
//#define Votes @"Votes"
////充钱
//#define ChargeMoney @"ChargeMoney"
////扣钱
//#define DeductMoney @"DeductMoney"
////预约确认
//#define BookConfirm @"BookConfirm"
////反馈回复
//#define FeedbackReturn @"FeedbackReturn"
////充积分
//#define ChargePoints @"ChargePoints"
////扣积分
//#define DeductPoints @"DeductPoints"
////积分取消
//#define CancelPoints @"CancelPoints"
////接收优惠券
//#define GetCoupon @"GetCoupon"
////卡交易取消
//#define CancelMoney @"CancelMoney"
////订单
//#define GetOrder @"GetOrder"


#define PUSHDATA @"PUSHDATANEW2.0" //本地存储键


//卡信息
#define CardMsg @"c1"
//充钱
#define ChargeMoney @"c3"
//扣钱
#define DeductMoney @"c4"
//预约确认
#define BookConfirm @"c5"
//反馈回复
#define FeedbackReturn @"c7"
//充积分
#define ChargePoints @"c9"
//扣积分
#define DeductPoints @"c10"
//卡交易取消
#define CancelMoney @"c11"
//积分取消
#define CancelPoints @"c12"
//接收优惠券
#define GetCoupon @"c13"
//活动
#define Events @"c14"
//投票
#define Votes @"c15"
//订单
#define GetOrder @"c16"
//在线支付
#define OnlinePay @"c17"
//小区公告
#define CommunityNotice @"c18"
//开门送优惠券
#define OpenCoupon @"c19"
//开门送钱
#define OpenMoney @"c20"

#endif

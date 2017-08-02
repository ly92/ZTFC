//
//  MessageDetailModel.h
//  EstateBiz
//
//  Created by wangshanshan on 16/6/3.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ActivityMsg_extinfoModel;
@class ActivityInfoModel;
@class VoteItemModel;

@interface MessageDetailModel : NSObject

@end

//卡信息详情
@interface CardMsgDetailModel : NSObject

@property (nonatomic, copy) NSString *bid;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *creationtime;
@property (nonatomic, copy) NSString *imageurl;
@property (nonatomic, copy) NSString *istime;
@property (nonatomic, copy) NSString *mid;
@property (nonatomic, copy) NSString *msg_obj_id;
@property (nonatomic, copy) NSString *msg_type;
@property (nonatomic, copy) NSString *outlink;
@property (nonatomic, copy) NSString *sendtime;
@property (nonatomic, copy) NSString *title;

@end

//活动详情
@interface ActivityDetailResultModel : NSObject

@property (nonatomic, copy) NSString *result;
@property (nonatomic, copy) NSString *reason;
@property (nonatomic, strong) CardMsgDetailModel *Msg;

@property (nonatomic, strong) ActivityMsg_extinfoModel *msg_extinfo;




@end

@interface ActivityMsg_extinfoModel : NSObject

@property (nonatomic, copy) NSString *is_join;

@property (nonatomic, strong) ActivityInfoModel *info;
//投票详情
@property (nonatomic, strong) NSArray *item;


@end

@interface ActivityInfoModel : NSObject

//公用的
@property (nonatomic, copy) NSString *bid;
@property (nonatomic, copy) NSString *creationtime;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *intro;
@property (nonatomic, copy) NSString *isdeleted;

//活动
@property (nonatomic, copy) NSString *joinmembers;
@property (nonatomic, copy) NSString *name;

//投票
@property (nonatomic, copy) NSString *option_type;
@property (nonatomic, copy) NSString *voted_users;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *votes;

@end

//投票详情
@interface VoteItemModel : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *item_name;
@property (nonatomic, copy) NSString *votes;

@end

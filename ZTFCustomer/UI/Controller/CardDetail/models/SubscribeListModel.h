//
//  SubscribeListModel.h
//  EstateBiz
//
//  Created by ly on 16/6/14.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SubscribeUserInfo,SubscribeRecordModel,SubscribeListModel;

@interface SubscribeListModel : NSObject
@property (copy, nonatomic) NSString *reason;//
@property (copy, nonatomic) NSString *result;//
@property (copy, nonatomic) NSString *last_id;//

@property (strong, nonatomic) NSArray *list;//

@end

@interface SubscribeRecordModel : NSObject
@property (copy, nonatomic) NSString *aid;//
@property (copy, nonatomic) NSString *anum;//
@property (copy, nonatomic) NSString *bid;//
@property (copy, nonatomic) NSString *bizmemo;//
@property (copy, nonatomic) NSString *booktime;//
@property (copy, nonatomic) NSString *cid;//
@property (copy, nonatomic) NSString *content;//
@property (copy, nonatomic) NSString *creationtime;//
@property (copy, nonatomic) NSString *status;//
@property (strong, nonatomic) SubscribeUserInfo *userinfo;//

@end

@interface SubscribeUserInfo : NSObject
@property (nonatomic, copy) NSString *cid;
@property (nonatomic, copy) NSString *access_token;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *birthday;
@property (nonatomic, copy) NSString *contactel;
@property (nonatomic, copy) NSString *creationtime;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *gender;
@property (nonatomic, copy) NSString *iconurl;
@property (nonatomic, copy) NSString *identityid;
@property (nonatomic, assign) BOOL ispaypswopen;
@property (nonatomic, copy) NSString *loginname;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *paypsw;
@property (nonatomic, copy) NSString *realname;
@property (nonatomic, copy) NSString *reg_type;
@property (nonatomic, copy) NSString *isforbidded;
@property (nonatomic, copy) NSString *last_update;
@property (nonatomic, copy) NSString *passwd;
@property (nonatomic, copy) NSString *pwd_reset_code;
@property (nonatomic, copy) NSString *pwd_reset_time;
@property (nonatomic, copy) NSString *rankid;

@end


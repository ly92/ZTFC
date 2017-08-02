//
//  UserModel.h
//  EstateBiz
//
//  Created by wangshanshan on 16/5/30.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject

@property (nonatomic, copy) NSString *cid;
@property (nonatomic, copy) NSString *access_token;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *birthday;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *gender;
@property (nonatomic, copy) NSString *iconurl;
@property (nonatomic, copy) NSString *identityid;
@property (nonatomic, assign) BOOL isinstall;
@property (nonatomic, assign) BOOL ispaypswopen;
@property (nonatomic, copy) NSString *loginname;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *paypsw;
@property (nonatomic, copy) NSString *realname;
@property (nonatomic, copy) NSString *reg_type;

@property (nonatomic, copy) NSString *easemob_account;
@property (nonatomic, copy) NSString *easemob_password;

@end

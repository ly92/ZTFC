//
//  MessageModel.h
//  EstateBiz
//
//  Created by wangshanshan on 16/6/3.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface MessageResultModel : NSObject

@property (nonatomic, copy) NSString *result;
@property (nonatomic, copy) NSString *reason;

@property (nonatomic, copy) NSString *LastDateTime;
@property (nonatomic, copy) NSString *LastID;
@property (nonatomic, strong) NSArray *MList;


@end


@interface MessageModel : NSObject

@property (nonatomic, copy) NSString *bid;
@property (nonatomic, copy) NSString *cardid;
@property (nonatomic, copy) NSString *cardtype;
@property (nonatomic, copy) NSString *cid;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *creationtime;
@property (nonatomic, copy) NSString *extra;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *imageurl;//只属商家信息
@property (nonatomic, copy) NSString *isdeleted;
@property (nonatomic, copy) NSString *isread;
@property (nonatomic, copy) NSString *maintype;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *outlink;
@property (nonatomic, copy) NSString *relatedid;
@property (nonatomic, copy) NSString *subtype;
@property (nonatomic, copy) NSString *title;


@property (nonatomic, copy) NSString *appid;
@property (nonatomic, copy) NSString *contact;
@property (nonatomic, copy) NSString *image_md5;
@property (nonatomic, copy) NSString *outerurl;
@property (nonatomic, copy) NSString *ownerid;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *tel;
@property (nonatomic, copy) NSString *type;

@property (nonatomic, strong) NSArray *imageArr;


@end

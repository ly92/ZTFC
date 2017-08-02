//
//  FeedbackListmodel.h
//  EstateBiz
//
//  Created by ly on 16/6/16.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SubscribeUserInfo;
@interface FeedbackListmodel : NSObject
@property (nonatomic, copy) NSString *last_id;
@property (nonatomic, copy) NSArray *list;
@property (nonatomic, copy) NSString *result;
@property (nonatomic, copy) NSString *reason;
@end

@interface FeedbackModel : NSObject
@property (nonatomic, copy) NSString *bid;
@property (nonatomic, copy) NSString *cid;
@property (nonatomic, copy) NSString *contact;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *creationtime;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *replycontent;
@property (nonatomic, strong) SubscribeUserInfo *userinfo;
@end


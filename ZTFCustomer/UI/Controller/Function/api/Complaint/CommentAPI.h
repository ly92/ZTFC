//
//  CommentAPI.h
//  ztfCustomer
//
//  Created by mac on 16/9/13.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

typedef NS_ENUM(NSInteger,COMMENTTYPE) {
    COMPLAINT, //投诉建议
    REPAIR,  //维修
};

@interface CommentAPI : YTKRequest

@property (nonatomic, assign) COMMENTTYPE commentType;

-(instancetype)initWithOrderNO:(NSString *)orderNo satisfied:(NSString *)satisfied reason:(NSString *)reason;

@end

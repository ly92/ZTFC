//
//  OperatePropertyConstulantAPI.h
//  ztfCustomer
//
//  Created by mac on 16/7/14.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

//顾问操作API

typedef NS_ENUM(NSInteger,OPERATETYPE) {
    CANCEL, //取消绑定
    BINDING,  //绑定
    EMPLOYEEDETAIL //顾问详情
};

@interface OperatePropertyConstulantAPI : YTKRequest

@property (nonatomic, assign) OPERATETYPE operateType;

-(instancetype)initWithSaleid:(NSString *)saleid ProjectId:(NSString *)projectId communityId:(NSString *)communityId;

@end

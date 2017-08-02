//
//  OperateBookAPI.h
//  ZTFCustomer
//
//  Created by mac on 16/11/22.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>

typedef NS_ENUM(NSInteger, OperateBooKType) {
    completeBookType,//完成预约
    cancelBookType//取消预约
};

@interface OperateBookAPI : YTKRequest

@property (nonatomic, assign) OperateBooKType operateBookType;

-(instancetype)initWithBookId:(NSString *)bookId projectId:(NSString *)projectId;

@end

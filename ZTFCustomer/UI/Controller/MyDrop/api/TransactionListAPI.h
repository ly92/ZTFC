//
//  TransactionListAPI.h
//  ZTFCustomer
//
//  Created by mac on 16/9/20.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>


typedef NS_ENUM(NSInteger,TransactionType) {
    InclomeType,//收入
    ExpendType//支出
};

//获取交易列表，包括收入，支出
@interface TransactionListAPI : YTKRequest

@property (nonatomic, assign) TransactionType transcationType;


-(instancetype)initWithLimit:(NSString *)limit skip:(NSString *)skip;

@end

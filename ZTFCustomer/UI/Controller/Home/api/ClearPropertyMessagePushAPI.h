//
//  ClearPropertyMessagePushAPI.h
//  ZTFCustomer
//
//  Created by mac on 16/11/15.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>

@interface ClearPropertyMessagePushAPI : YTKRequest

-(instancetype)initWithMessageId:(NSString *)messageId count:(NSString *)count;

@end

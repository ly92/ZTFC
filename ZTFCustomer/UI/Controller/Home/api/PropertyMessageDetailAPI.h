//
//  PropertyMessageDetailAPI.h
//  ZTFCustomer
//
//  Created by mac on 16/11/15.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>

@interface PropertyMessageDetailAPI : YTKRequest


-(instancetype)initWithMessageId:(NSString *)messageId;

@end

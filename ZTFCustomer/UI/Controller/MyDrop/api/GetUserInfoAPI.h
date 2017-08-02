//
//  GetUserInfoAPI.h
//  ZTFCustomer
//
//  Created by mac on 2016/12/9.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>

@interface GetUserInfoAPI : YTKRequest


-(instancetype)initWithMobile:(NSString *)mobile;

@end

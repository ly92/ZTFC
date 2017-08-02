//
//  CheckOldPayPwdAPI.h
//  ZTFCustomer
//
//  Created by mac on 16/9/20.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface CheckOldPayPwdAPI : YTKRequest
-(instancetype)initWithOldPayPwd:(NSString *)oldPayPwd;
@end

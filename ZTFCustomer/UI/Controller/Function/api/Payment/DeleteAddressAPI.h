//
//  DeleteAddressAPI.h
//  ZTFCustomer
//
//  Created by mac on 16/9/21.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface DeleteAddressAPI : YTKRequest

-(instancetype)initWithAddressId:(NSString *)addressId;

@end

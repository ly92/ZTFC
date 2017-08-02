//
//  GiveDropAPI.h
//  ZTFCustomer
//
//  Created by mac on 16/11/25.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>

//赠送铁豆
@interface GiveDropAPI : YTKRequest

-(instancetype)initWithTel:(NSString *)tel money:(NSString *)money password:(NSString *)password;

@end

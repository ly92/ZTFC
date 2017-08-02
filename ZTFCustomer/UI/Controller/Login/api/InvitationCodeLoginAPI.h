//
//  InvitationCodeLoginAPI.h
//  EstateBiz
//
//  Created by wangshanshan on 16/6/17.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface InvitationCodeLoginAPI : YTKRequest

-(instancetype)initWithCode:(NSString *)code;

@end

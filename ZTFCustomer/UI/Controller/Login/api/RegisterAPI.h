//
//  RegisterAPI.h
//  EstateBiz
//
//  Created by wangshanshan on 16/6/17.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface RegisterAPI : YTKRequest

-(instancetype)initWithRealname:(NSString *)realname mobile:(NSString *)mobile gender:(NSString *)gender psw:(NSString *)psw birthday:(NSString *)birthday;

@end

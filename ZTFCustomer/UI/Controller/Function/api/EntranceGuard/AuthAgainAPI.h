//
//  AuthAgainAPI.h
//  EstateBiz
//
//  Created by wangshanshan on 16/6/13.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface AuthAgainAPI : YTKRequest

-(instancetype)initWithAutype:(NSString *)autype toid:(NSString *)toid bid:(NSString *)bid usertype:(NSString *)usertype granttype:(NSString *)granttype starttime:(NSString *)starttime stoptime:(NSString *)stoptime memo:(NSString *)memo;

@end

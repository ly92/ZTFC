//
//  ApplyApproveAPI.h
//  EstateBiz
//
//  Created by wangshanshan on 16/6/14.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface ApplyApproveAPI : YTKRequest


-(instancetype)initWithApplyid:(NSString *)applyid approve:(NSString *)approve autype:(NSString *)autype usertype:(NSString *)usertype granttype:(NSString *)granttype bid:(NSString *)bid starttime:(NSString *)starttime stoptime:(NSString *)stoptime memo:(NSString *)memo;

@end

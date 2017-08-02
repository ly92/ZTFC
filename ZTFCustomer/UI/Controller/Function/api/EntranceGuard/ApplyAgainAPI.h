//
//  ApplyAgainAPI.h
//  EstateBiz
//
//  Created by wangshanshan on 16/6/13.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface ApplyAgainAPI : YTKRequest

//再次申请
-(instancetype)initWithCid:(NSString *)cid memo:(NSString *)memo;

@end

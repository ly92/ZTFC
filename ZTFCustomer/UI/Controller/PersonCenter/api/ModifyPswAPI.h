//
//  ModifyPswAPI.h
//  EstateBiz
//
//  Created by wangshanshan on 16/6/16.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface ModifyPswAPI : YTKRequest

-(instancetype)initWithPldPsw:(NSString *)oldPsw newPsw:(NSString *)newPsw;

@end

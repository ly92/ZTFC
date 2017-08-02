//
//  BaseModel.m
//  EstateBiz
//
//  Created by wangshanshan on 16/5/31.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

@end


@implementation Location


@end

@implementation Region

+(NSDictionary *)mj_objectClassInArray{
    return @{@"citys":@"Region",
             @"districts":@"Region"};
}

@end
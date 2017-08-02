//
//  UserModel.m
//  EstateBiz
//
//  Created by wangshanshan on 16/5/30.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self == [super init]) {
        [self mj_decode:aDecoder];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    
    [self mj_encode:aCoder];
}
@end

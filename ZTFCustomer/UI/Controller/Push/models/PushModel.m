//
//  PushModel.m
//  EstateBiz
//
//  Created by mac on 16/7/5.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "PushModel.h"

@implementation PushModel
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

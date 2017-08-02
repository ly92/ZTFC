//
//  SurroundingModel.m
//  EstateBiz
//
//  Created by wangshanshan on 16/5/30.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "SurroundingModel.h"

//根据经纬度请求得到的数据字典
@implementation SurroundingCommunityResultModel

+(NSDictionary *)mj_objectClassInArray{
    return @{@"shoplist":@"Shop"};
}

@end

//根据条件筛选请求得到的数据字典
@implementation SurroundingListResultModel

+(NSDictionary *)mj_objectClassInArray{
    return @{@"shoplist":@"Shop"};
}

@end

//小区
@implementation Community

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

//周边列表实体
@implementation Shop


@end


//筛选小区列表结果
@implementation CommunityListResultModel

+(NSDictionary *)mj_objectClassInArray{
    return @{@"communitylist":@"Community"};
}

@end



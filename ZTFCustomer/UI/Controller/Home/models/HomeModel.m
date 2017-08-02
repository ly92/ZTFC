//
//  HomeModel.m
//  EstateBiz
//
//  Created by wangshanshan on 16/6/2.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "HomeModel.h"

@implementation HomeModel

@end

@implementation AuthoriseCommunityResultModel

+(NSDictionary *)mj_objectClassInArray{
    return @{@"list":@"Community"};
}

@end


@implementation MemberCardResultModel

+(NSDictionary *)mj_objectClassInArray{
    return @{@"CardList":@"MemberCardModel",
             @"list" : @"MemberCardModel"};
}

@end

@implementation AdModel

@end

@implementation MoreFunctionModel

+(NSDictionary *)mj_objectClassInArray{
    return @{@"modules":@"FunctionModel"};
}

@end

@implementation FunctionModel

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        [self mj_decode:aDecoder];
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [self mj_encode:aCoder];
}

@end


@implementation LimitActivityModel

+(NSDictionary *)mj_objectClassInArray{
    return @{@"list":@"AttrModel"};
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        [self mj_decode:aDecoder];
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [self mj_encode:aCoder];
}

@end

@implementation AttrModel
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        [self mj_decode:aDecoder];
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [self mj_encode:aCoder];
}
@end



@implementation MemberCardModel

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        [self mj_decode:aDecoder];
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [self mj_encode:aCoder];
}


@end


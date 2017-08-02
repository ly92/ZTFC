//
//  PropertyConstrulantModel.m
//  ztfCustomer
//
//  Created by mac on 16/7/14.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "PropertyConstrulantModel.h"

@implementation PropertyConstrulantModel

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

@implementation PropertyMessageModel



@end

@implementation AlbumModel

+(NSDictionary *)mj_objectClassInArray{
    return @{@"resources":@"ResourceModel"};
}

@end

@implementation ResourceModel



@end


@implementation TeamModel


@end

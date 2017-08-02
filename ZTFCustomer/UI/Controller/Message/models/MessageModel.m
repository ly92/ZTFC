//
//  MessageModel.m
//  EstateBiz
//
//  Created by wangshanshan on 16/6/3.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "MessageModel.h"

@implementation MessageResultModel

+(NSDictionary *)mj_objectClassInArray{
    return @{@"MList":@"MessageModel"};
}

@end

@implementation MessageModel
+(NSDictionary *)mj_objectClassInArray{
    return @{@"imageArr":@"ImageModel"};
}
@end

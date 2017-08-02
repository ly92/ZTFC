//
//  FeedbackListmodel.m
//  EstateBiz
//
//  Created by ly on 16/6/16.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "FeedbackListmodel.h"

@implementation FeedbackListmodel
+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"list" : @"FeedbackModel"
             };
}
@end
@implementation FeedbackModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{
             @"id" : @"ID"
             };
}

@end
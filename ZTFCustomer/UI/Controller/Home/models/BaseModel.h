//
//  BaseModel.h
//  EstateBiz
//
//  Created by wangshanshan on 16/5/31.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Location;
@class Region;


@interface BaseModel : NSObject

@end

@interface Location : NSObject
@property (nonatomic, strong) NSNumber * lat;
@property (nonatomic, strong) NSNumber * lon;
@end

@interface Region : NSObject
@property (nonatomic, strong) NSString * id;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * parent_id;
@property (nonatomic, strong) NSString * state;
@property (nonatomic, strong) NSString * is_deleted;
@property (nonatomic, strong) NSString * initial;
@property (nonatomic, strong) NSArray * citys;
@property (nonatomic, strong) NSArray * districts;
@end
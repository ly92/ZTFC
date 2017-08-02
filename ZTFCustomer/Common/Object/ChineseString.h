//
//  ChineseString.h
//  ChineseSort
//
//  Created by Bill on 12-8-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChineseString : NSObject<NSCoding>

@singleton(ChineseString)

@property(nonatomic, copy) NSString * string;
@property(nonatomic, copy) NSString * pinYin;
@property(nonatomic, strong) RegionModel * data;

+ (NSMutableArray *)getChineseStringArr:(NSArray *)arrToSort;

@end

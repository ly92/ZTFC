//
//  SurroundingDatabase.h
//  YiDa
//
//  Created by 沿途の风景 on 14-10-13.
//  Copyright (c) 2014年 Hairon. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FMDatabase.h"

@interface SurroundingDatabase : NSObject

+ (SurroundingDatabase *)shareSurroundingDB;

//查询区域
- (NSMutableArray *)selectDistrictWithProvinceid:(NSString *)provinceid cityid:(NSString *)cityid;

@end

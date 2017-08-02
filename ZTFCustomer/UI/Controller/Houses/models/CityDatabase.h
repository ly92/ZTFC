//
//  CityDatabase.h
//  BizKaKaTool
//
//  Created by 沿途の风景 on 14-5-27.
//  Copyright (c) 2014年 HaironYoung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface CityDatabase : NSObject

+ (CityDatabase *)shareCityDatabase;

//查询不同的首字母并排序（升序）
- (NSMutableArray *)selectDistinctFirstLetterOrderByAsc;

//查询不同的首字母分组
- (NSMutableArray *)selectCityNameGroupByDistinctFirstLetter:(NSMutableArray *)lettersArray;

//根据关键字查询城市名
- (NSMutableArray *)selectCityNameBySearchwords:(NSString *)words;

//根据城市名称查询城市详细信息
- (NSDictionary *)selectCityDetailByCityName:(NSString *)name;

//根据城市id查询城市
- (NSString *)selectCityNameByCityid:(NSString *)cityid;

@end

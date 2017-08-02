//
//  CityDatabase.m
//  BizKaKaTool
//
//  Created by 沿途の风景 on 14-5-27.
//  Copyright (c) 2014年 HaironYoung. All rights reserved.
//

//#define FMDBQuickCheck(SomeBool) { if (!(SomeBool)) { NSLog(@"Failure on line %d", __LINE__); abort(); } }

#define FMDBQuickCheck(SomeBool) { if (!(SomeBool)) { NSLog(@"Failure on line %d, error = %@, func = %s", __LINE__,[db lastErrorMessage],__FUNCTION__); abort(); } }

#import "CityDatabase.h"
#import "FMDatabaseQueue.h"
#import "NSFileManager+PerfUtilities.h"


static CityDatabase *cityDatabase;

@implementation CityDatabase
{
    FMDatabaseQueue *queue;
}

+ (CityDatabase *)shareCityDatabase
{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        cityDatabase = [[CityDatabase alloc] init];
    });
    
    return cityDatabase;
}

-(id)init
{
    if (self = [super init]) {
        
        
        NSString* w_dbPath = [NSFileManager spPathForFileInDocumentNamed:@"city.db"];
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:w_dbPath])
        {
            NSString* w_bundlePath = [NSFileManager spPathForBundleDocumentNamed:@"city.db"];
            NSError *error = nil;
            [[NSFileManager defaultManager] copyItemAtPath:w_bundlePath toPath:w_dbPath error:&error];
            
            NSLog(@"w_bundlePath:%@",w_bundlePath);
        }
        NSLog(@"w_dbPath:%@",w_dbPath);
        
        queue = [FMDatabaseQueue databaseQueueWithPath:w_dbPath];

//        NSLog(@"w_dbPath:%@",w_dbPath);
//        
//        queue = [FMDatabaseQueue databaseQueueWithPath:w_dbPath];
//        
//        NSFileManager *manager = [NSFileManager defaultManager];
//        
//        NSString *path = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"db"];
//        NSLog(@"path = %@",path);
//        
//        BOOL fileExit = [manager fileExistsAtPath:path];
//        
//        if (!fileExit) {
//            FMDBQuickCheck(fileExit)
//        }
//        else {
//            queue = [FMDatabaseQueue databaseQueueWithPath:path] ;
//        }
    }
    
    return self;
}

//查询不同的首字母并排序（升序）
- (NSMutableArray *)selectDistinctFirstLetterOrderByAsc
{
//    NSString *sql = @"select distinct index_keys from city order by index_keys asc";
    NSString *sql = @"select * from city ";
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    
    [queue inDatabase:^(FMDatabase *db) {
        FMResultSet *set = [db executeQuery:sql];
        if (set) {
            while ([set next]) {
                
                NSString *cityname = [set stringForColumn:@"cityname"];
//                NSString *provinceid = [set stringForColumn:@"provinceid"];
//                NSString *cityid = [set stringForColumn:@"cityid"];
                
                 RegionModel *region = [[RegionModel alloc]init];
                
                region.name = cityname;
//                region.provinceid = provinceid;
//                region.cityid = cityid;
                
                [array addObject:region];
            }
        }
        else {
            NSLog(@"error = %@,line = %d,func = %s",[db lastErrorMessage],__LINE__,__FUNCTION__);
//            FMDBQuickCheck(![db hadError])
             FMDBQuickCheck(set);
        }
        
        [set close];
    }];
    
    //NSLog(@"array = %@",array);
    
    return array;
}

//查询不同的首字母分组
- (NSMutableArray *)selectCityNameGroupByDistinctFirstLetter:(NSMutableArray *)lettersArray
{
    if (lettersArray == nil || lettersArray.count == 0) {
        return nil;
    }
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    
    for (int i = 0; i < lettersArray.count; i++) {
        
        NSString *sql = [NSString stringWithFormat:@"select * from city where index_keys = '%@' order by cityid asc",[lettersArray objectAtIndex:i]];
        
        NSMutableArray *cityArray = [self selectCityNameBySameFirstLetter:sql];
        [array addObject:cityArray];
    }
    
    //NSLog(@"array = %@",array);
    
    return array;
}


//查询同一个首字母的城市名称
- (NSMutableArray *)selectCityNameBySameFirstLetter:(NSString *)sql
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    
    [queue inDatabase:^(FMDatabase *db) {
        
        FMResultSet *set = [db executeQuery:sql];
        if (set) {
            while ([set next]) {
                NSString *cityname = [set stringForColumn:@"cityname"];
                NSString *cityid = [NSString stringWithFormat:@"%d",[set intForColumn:@"cityid"]];
                NSString *provinceid = [NSString stringWithFormat:@"%d",[set intForColumn:@"provinceid"]];
                
                NSDictionary *city = [NSDictionary dictionaryWithObjectsAndKeys:cityname,@"cityname",cityid,@"cityid",provinceid,@"provinceid", nil];
                //NSLog(@"city = %@",city);
                
                [array addObject:city];
            }
        }
        else {
            NSLog(@"error = %@,line = %d,func = %s",[db lastErrorMessage],__LINE__,__FUNCTION__);
        }
        [set close];
    }];
    
    //NSLog(@"array = %@",array);
    
    return array;
}

//根据关键字查询城市名
- (NSMutableArray *)selectCityNameBySearchwords:(NSString *)words
{
    if (!words || [words trim].length == 0) {
        return nil;
    }
    
    NSString *sql = [NSString stringWithFormat:@"select * from city where cityname like '%@%%' order by cityid asc",words];
    //NSLog(@"sql = %@",sql);
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    
    [queue inDatabase:^(FMDatabase *db) {
        
        FMResultSet *set = [db executeQuery:sql];
        
        if (set) {
            while ([set next]) {
                
                NSString *cityname = [set stringForColumn:@"cityname"];
                NSString *cityid = [NSString stringWithFormat:@"%d",[set intForColumn:@"cityid"]];
                NSString *provinceid = [NSString stringWithFormat:@"%d",[set intForColumn:@"provinceid"]];
                
                NSDictionary *city = [NSDictionary dictionaryWithObjectsAndKeys:cityname,@"cityname",cityid,@"cityid",provinceid,@"provinceid", nil];
                //NSLog(@"city = %@",city);
            
                [array addObject:city];
            }
        }
        else {
            NSLog(@"error = %@,line = %d,func = %s",[db lastErrorMessage],__LINE__,__FUNCTION__);
        }
        
        [set close];
    }];
    
    //NSLog(@"array = %@",array);
    
    if (array.count == 0) {
        return nil;
    }
    
    return array;
}

//根据城市名称查询城市详细信息
- (NSDictionary *)selectCityDetailByCityName:(NSString *)name
{
    if (!name || [name trim].length == 0) {
        return nil;
    }
    
    NSString *sql = [NSString stringWithFormat:@"select * from city where cityname = '%@' order by cityid asc",name];
    
    __block NSDictionary *dic = nil;
    
    [queue inDatabase:^(FMDatabase *db) {
        
        FMResultSet *set = [db executeQuery:sql];
        
        if (set) {
            while ([set next]) {
                
                NSString *cityname = [set stringForColumn:@"cityname"];
                NSString *cityid = [NSString stringWithFormat:@"%d",[set intForColumn:@"cityid"]];
                NSString *provinceid = [NSString stringWithFormat:@"%d",[set intForColumn:@"provinceid"]];
                
                dic = [NSDictionary dictionaryWithObjectsAndKeys:cityname,@"cityname",cityid,@"cityid",provinceid,@"provinceid", nil];
            }
        }
        else {
            NSLog(@"error = %@,line = %d,func = %s",[db lastErrorMessage],__LINE__,__FUNCTION__);
        }
        
        [set close];
    }];
    
    //NSLog(@"dic = %@",dic);
    
    return dic;
}

//根据城市id查询城市
- (NSString *)selectCityNameByCityid:(NSString *)cityid
{
    if (!cityid || [cityid trim].length == 0) {
        return nil;
    }
    
    NSString *sql = @"select * from city where cityid = ? order by cityid asc";
    
    __block NSString *name = nil;
    
    [queue inDatabase:^(FMDatabase *db) {
        
        FMResultSet *set = [db executeQuery:sql,cityid];
        
        if (set) {
            while ([set next]) {
                
                name = [set stringForColumn:@"cityname"];
                
            }
        }
        else {
            NSLog(@"error = %@,line = %d,func = %s",[db lastErrorMessage],__LINE__,__FUNCTION__);
        }
        
        [set close];
    }];
    
    //NSLog(@"name = %@",name);
    
    return name;
}

@end

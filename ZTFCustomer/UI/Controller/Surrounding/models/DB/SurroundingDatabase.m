//
//  SurroundingDatabase.m
//  YiDa
//
//  Created by 沿途の风景 on 14-10-13.
//  Copyright (c) 2014年 Hairon. All rights reserved.
//

#import "SurroundingDatabase.h"

#import "FMDatabaseQueue.h"

#import "NSFileManager+PerfUtilities.h"

#define FMDBQuickCheck(SomeBool) { if (!(SomeBool)) { NSLog(@"Failure on line %d, error = %@, func = %s", __LINE__,[db lastErrorMessage],__FUNCTION__); abort(); } }

static SurroundingDatabase *surroundingDB;

@implementation SurroundingDatabase
{
    FMDatabaseQueue *queue;
}

+ (SurroundingDatabase *)shareSurroundingDB
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        surroundingDB = [[SurroundingDatabase alloc] init];
    });
    
    return surroundingDB;
}

- (id)init
{
    if (self = [super init]) {
        [self openDatabase];
    }
    return self;
}

- (void)openDatabase
{
    NSString* w_dbPath = [NSFileManager spPathForFileInDocumentNamed:@"surrounding.db"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:w_dbPath])
    {
        NSString* w_bundlePath = [NSFileManager spPathForBundleDocumentNamed:@"surrounding.db"];
        NSError *error = nil;
        [[NSFileManager defaultManager] copyItemAtPath:w_bundlePath toPath:w_dbPath error:&error];
        
         NSLog(@"w_bundlePath:%@",w_bundlePath);
    }
    
    NSLog(@"w_dbPath:%@",w_dbPath);
    
    queue = [FMDatabaseQueue databaseQueueWithPath:w_dbPath];
}

//查询区域
- (NSMutableArray *)selectDistrictWithProvinceid:(NSString *)provinceid cityid:(NSString *)cityid
{
    NSMutableArray *districtArray = [NSMutableArray arrayWithCapacity:0];
    
    NSString *sql = @"select * from district where cityid = ? and provinceid = ? order by districtid asc";
    
    [queue inDatabase:^(FMDatabase *db) {
        FMResultSet *set = [db executeQuery:sql,cityid,provinceid];
        if (set) {
            while ([set next]) {
                
                NSString *districtid = [NSString stringWithFormat:@"%d",[set intForColumn:@"districtid"]];
                NSString *districtname = [NSString stringWithFormat:@"%@",[set stringForColumn:@"districtname"]];
                
                NSDictionary *district = [NSDictionary dictionaryWithObjectsAndKeys:districtid,@"districtid",districtname,@"districtname", nil];
                [districtArray addObject:district];
            }
        }
        else {
         
            FMDBQuickCheck(set);
           
        }
        
        [set close];
    }];
    
    //PRINT(@"districtArray : %@",districtArray);
    return districtArray;
}

- (void)closeDatabase
{
    [queue close];
}

@end

//
//  SurroundingModel.h
//  EstateBiz
//
//  Created by wangshanshan on 16/5/30.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Community;

//根据经纬度请求得到的数据字典
@interface SurroundingCommunityResultModel : NSObject

@property (nonatomic, copy) NSString *radius;
@property (nonatomic, copy) NSString *total;
@property (nonatomic, copy) NSString *reason;
@property (nonatomic, copy) NSString *result;

@property (nonatomic, strong) Community *community;
@property (nonatomic, strong) NSArray *shoplist;

@end

//根据条件筛选请求得到的数据字典
@interface SurroundingListResultModel : NSObject

@property (nonatomic, copy) NSString *reason;
@property (nonatomic, copy) NSString *result;

@property (nonatomic, strong) Community *biz;
@property (nonatomic, strong) NSArray *shoplist;
@property (nonatomic, copy) NSString *total;

@end

//小区
@interface Community : NSObject<NSCoding>

@property (nonatomic, copy) NSString *bid;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *latitude;
@property (nonatomic, copy) NSString *longitude;
@property (nonatomic, copy) NSString *districtid;
@property (nonatomic, copy) NSString *provinceid;
@property (nonatomic, copy) NSString *cityid;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *intro;
@property (nonatomic, copy) NSString *tel;

@property (nonatomic, assign) BOOL selected;

@end


//周边列表实体
@interface Shop : NSObject

@property (nonatomic, copy) NSString *cid;
@property (nonatomic, copy) NSString *bid;
@property (nonatomic, copy) NSString *cardnum;
@property (nonatomic, copy) NSString *cardtype;
@property (nonatomic, copy) NSString *extra;
@property (nonatomic, copy) NSString *frontimageurl;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *industryname;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *distance;
@property (nonatomic, copy) NSString *cardid;
@property (nonatomic, copy) NSString *coupon;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *intro;
@property (nonatomic, copy) NSString *latitude;
@property (nonatomic, copy) NSString *longitude;
@property (nonatomic, copy) NSString *membercount;
@property (nonatomic, copy) NSString *memo;
@property (nonatomic, copy) NSString *subindustryname;
@property (nonatomic, copy) NSString *tel;

@end


//筛选小区列表结果
@interface CommunityListResultModel : NSObject

@property (nonatomic, copy) NSString *reason;
@property (nonatomic, copy) NSString *result;

@property (nonatomic, strong) NSArray *communitylist;

@end


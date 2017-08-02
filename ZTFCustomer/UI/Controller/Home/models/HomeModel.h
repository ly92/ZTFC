//
//  HomeModel.h
//  EstateBiz
//
//  Created by wangshanshan on 16/6/2.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Bizcard;
@interface HomeModel : NSObject

@end


@interface AuthoriseCommunityResultModel : NSObject

@property (nonatomic, copy) NSString *reason;
@property (nonatomic, copy) NSString *result;
@property (nonatomic, strong) NSArray *list;

@end

//小区广告
@interface AdModel : NSObject


@property (nonatomic, copy) NSString *android_activity;
@property (nonatomic, copy) NSString *attribute;//属性 1为全局 2为原生
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *ios_controller;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *param;
@property (nonatomic, copy) NSString *project_id;
@property (nonatomic, copy) NSString *sort;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *type;//1 为原生 2H5
@property (nonatomic, copy) NSString *url;//H5的跳转链接
@property (nonatomic, copy) NSString *creationtime;

@end

@interface MoreFunctionModel : NSObject
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) NSArray *modules;

@end

//function模块
@interface FunctionModel : NSObject<NSCoding>

@property (nonatomic, copy) NSString *actionandroid;
@property (nonatomic, copy) NSString *actionios;
@property (nonatomic, copy) NSString *actiontype;
@property (nonatomic, copy) NSString *actionurl;
@property (nonatomic, copy) NSString *appid;
@property (nonatomic, copy) NSString *bno;
@property (nonatomic, copy) NSString *bsecret;
@property (nonatomic, copy) NSString *extra;
@property (nonatomic, copy) NSString *iconurl;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *mtype;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *weight;


@end

//小区活动
@interface LimitActivityModel : NSObject<NSCoding>

@property (nonatomic, strong) NSArray * list; //

@property (nonatomic, strong) NSString * title;
@property (nonatomic, assign) LIMITYACTIVITY_STYLE style_num;


@end

@interface AttrModel : NSObject<NSCoding>

//@property (nonatomic, copy) NSString *img;
//@property (nonatomic, copy) NSString *name;
//@property (nonatomic, copy) NSString *url;
//@property (nonatomic, copy) NSString *actiontype;
//@property (nonatomic, copy) NSString *actionios;

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *appid;
@property (nonatomic, copy) NSString *attribute;
@property (nonatomic, copy) NSString *project_id;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *sort;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *ios_controller;
@property (nonatomic, copy) NSString *style_id;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *creationtime;
@property (nonatomic, copy) NSString *modifiedtime;
@property (nonatomic, copy) NSString *param;

@end



//我的会员卡列表
@interface MemberCardResultModel : NSObject

@property (nonatomic, copy) NSString *result;
@property (nonatomic, copy) NSString *reason;
@property (nonatomic, copy) NSString *last_datetime;
@property (nonatomic, copy) NSString *last_id;

@property (nonatomic, strong) NSArray *CardList;
@property (nonatomic, strong) NSArray *list;

@end

@interface MemberCardModel : NSObject<NSCoding>


@property (nonatomic, copy) NSString *amounts;
@property (nonatomic, copy) NSString *backimageurl;
@property (nonatomic, copy) NSString *barcodeurl;
@property (nonatomic, copy) NSString *bid;
@property (nonatomic, copy) NSString *biz_address;
@property (nonatomic, copy) NSString *bizmemo;
@property (nonatomic, copy) NSString *card_category;
@property (nonatomic, copy) NSString *cardid;
@property (nonatomic, copy) NSString *cardname;
@property (nonatomic, copy) NSString *cardnum;
@property (nonatomic, copy) NSString *cardtype;
@property (nonatomic, copy) NSString *cardtypes;
@property (nonatomic, copy) NSString *cid;
@property (nonatomic, copy) NSString *clientname;
@property (nonatomic, copy) NSString *coupon_num;
@property (nonatomic, copy) NSString *creationtime;
@property (nonatomic, copy) NSString *discounts;
@property (nonatomic, copy) NSString *expriationtime;
@property (nonatomic, copy) NSString *extra;
@property (nonatomic, copy) NSString *frontimageurl;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *isfav;
@property (nonatomic, copy) NSString *istop;
@property (nonatomic, copy) NSString *points;
@property (nonatomic, copy) NSString *tcid;
@property (nonatomic, copy) NSString *thirdpartmemo;
@property (nonatomic, copy) NSString *updatetimes;

@property (nonatomic, copy) NSString *pushcount;
@property (nonatomic, copy) NSString *clickCount;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *address;


@property (nonatomic, strong) Bizcard *bizcard;


@end




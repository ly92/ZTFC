//
//  MemberCardDetailModel.h
//  EstateBiz
//
//  Created by wangshanshan on 16/6/2.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Card,Branch;
@class Businessinfo;
@class Cardinfo;
@class Bizswitch;

@interface MemberCardDetailResultModel : NSObject

@property (nonatomic, copy) NSString *reason;
@property (nonatomic, copy) NSString *result;

//是否有在线支付
@property (nonatomic, copy) NSString *kakapay;

//分店
@property (nonatomic, strong) NSArray *branch;

@property (nonatomic, strong) Bizswitch *bizswitch;

@property (nonatomic, strong) Card *Card;

@end


@interface Card : NSObject

@property (nonatomic, copy) NSString *amounts;
@property (nonatomic, copy) NSString *backimageurl;
@property (nonatomic, copy) NSString *barcodeurl;
@property (nonatomic, copy) NSString *bid;
@property (nonatomic, copy) NSString *bizmemo;
@property (nonatomic, copy) NSString *cardid;
@property (nonatomic, copy) NSString *cardname;
@property (nonatomic, copy) NSString *cardnum;
@property (nonatomic, copy) NSString *cid;
@property (nonatomic, copy) NSString *clientname;
@property (nonatomic, copy) NSString *creationtime;
@property (nonatomic, copy) NSString *discounts;
@property (nonatomic, copy) NSString *expriationtime;
@property (nonatomic, copy) NSString *frontimageurl;
@property (nonatomic, copy) NSString *points;
@property (nonatomic, copy) NSString *tcid;
@property (nonatomic, copy) NSString *thirdpartmemo;

@property (nonatomic, strong) Businessinfo *businessinfo;
@property (nonatomic, strong) Cardinfo *cardinfo;

//c扫b加会员
@property (nonatomic, copy) NSString *extra;
@property (nonatomic, copy) NSString *isdeleted;
@property (nonatomic, copy) NSString *cardtype;
@property (nonatomic, copy) NSString *modifiedtime;


@end


@interface Businessinfo : NSObject

@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *balance;
@property (nonatomic, copy) NSString *bid;
@property (nonatomic, copy) NSString *bizno;
@property (nonatomic, copy) NSString *biztype;
@property (nonatomic, copy) NSString *cityid;
@property (nonatomic, copy) NSString *creationtime;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *industryid;
@property (nonatomic, copy) NSString *industryname;
@property (nonatomic, copy) NSString *intro;
@property (nonatomic, copy) NSString *ischarge;
@property (nonatomic, copy) NSString *isforbidded;
@property (nonatomic, copy) NSString *isrecommend;
@property (nonatomic, copy) NSString *last_update;
@property (nonatomic, copy) NSString *latitude;
@property (nonatomic, copy) NSString *logourl;
@property (nonatomic, copy) NSString *longitude;
@property (nonatomic, copy) NSString *memo;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *provinceid;
@property (nonatomic, copy) NSString *rank;
@property (nonatomic, copy) NSString *rankname;
@property (nonatomic, copy) NSString *recommendcode;
@property (nonatomic, copy) NSString *reg_invite_code;
@property (nonatomic, copy) NSString *sphour;
@property (nonatomic, copy) NSString *subindustryname;
@property (nonatomic, copy) NSString *tel;
@property (nonatomic, copy) NSString *website;
@property (nonatomic, copy) NSString *wifi_portal;


@end


@interface Cardinfo : NSObject

@property (nonatomic, copy) NSString *backimageurl;
@property (nonatomic, copy) NSString *bid;
@property (nonatomic, copy) NSString *cardid;
@property (nonatomic, copy) NSString *cardname;
@property (nonatomic, copy) NSString *creationtime;
@property (nonatomic, copy) NSString *frontimageurl;
@property (nonatomic, copy) NSString *isdeleted;
@property (nonatomic, copy) NSString *modifiedtime;


//c扫b加会员
@property (nonatomic, copy) NSString *cardnum;
@property (nonatomic, copy) NSString *amounts;
@property (nonatomic, copy) NSString *barcodeurl;
@property (nonatomic, copy) NSString *bizmemo;
@property (nonatomic, copy) NSString *cid;
@property (nonatomic, copy) NSString *clientname;
@property (nonatomic, copy) NSString *discounts;
@property (nonatomic, copy) NSString *expriationtime;
@property (nonatomic, copy) NSString *points;
@property (nonatomic, copy) NSString *tcid;
@property (nonatomic, copy) NSString *thirdpartmemo;

@end


@interface Bizswitch : NSObject

@property (nonatomic, copy) NSString *p2p;
@property (nonatomic, copy) NSString *production;

@end

@interface Branch : NSObject

@property (nonatomic, copy) NSString *addr;
@property (nonatomic, copy) NSString *bid;
@property (nonatomic, copy) NSString *creationtime;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *isdeleted;
@property (nonatomic, copy) NSString *isshow;
@property (nonatomic, copy) NSString *last_update;
@property (nonatomic, copy) NSString *latitude;
@property (nonatomic, copy) NSString *longitude;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *tel;

@end

@interface MemberCardDetailModel : NSObject

@end

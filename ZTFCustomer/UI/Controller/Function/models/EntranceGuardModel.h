//
//  EntranceGuardModel.h
//  EstateBiz
//
//  Created by wangshanshan on 16/6/12.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EntranceGuardModel : NSObject

@end


@interface ApplyModel : NSObject

@property (nonatomic, copy) NSString *adminid;
@property (nonatomic, copy) NSString *applyid;
@property (nonatomic, copy) NSString *autype;
@property (nonatomic, copy) NSString *bid;
@property (nonatomic, copy) NSString *cancelcid;
@property (nonatomic, copy) NSString *cid;
@property (nonatomic, copy) NSString *creationtime;
@property (nonatomic, copy) NSString *fromid;
@property (nonatomic, copy) NSString *fromname;
@property (nonatomic, copy) NSString *granttype;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *isdeleted;
@property (nonatomic, copy) NSString *memo;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *modifiedtime;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *starttime;
@property (nonatomic, copy) NSString *stoptime;
@property (nonatomic, copy) NSString *times;
@property (nonatomic, copy) NSString *toid;
@property (nonatomic, copy) NSString *toname;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *usertype;


@end

@interface GetDoorInfoModel : NSObject

@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *bid;
@property (nonatomic, copy) NSString *conntype;
@property (nonatomic, copy) NSString *doorcode;
@property (nonatomic, copy) NSString *doortype;
@property (nonatomic, copy) NSString *dynamic;
@property (nonatomic, copy) NSString *dynamicqr;
@property (nonatomic, copy) NSString *extra;
@property (nonatomic, copy) NSString *factorytype;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *modifiedtime;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *qrcode;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *unitid;
@property (nonatomic, copy) NSString *version;
@property (nonatomic, copy) NSString *wificode;
@property (nonatomic, copy) NSString *wifienable;


@end

//
//  CardPointModel.h
//  EstateBiz
//
//  Created by ly on 16/6/16.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CardPointModel : NSObject
@property (nonatomic, copy) NSString * reason;//""
@property (nonatomic, copy) NSString * result;//0
@property (nonatomic, copy) NSString * last_datetime;
@property (nonatomic, copy) NSString * last_id;
@property (nonatomic, strong) NSMutableArray *data;
@end


@interface CardPointData: NSObject
@property (nonatomic, copy) NSString * adminid;//""
@property (nonatomic, copy) NSString * bid;//0
@property (nonatomic, copy) NSString * cid;
@property (nonatomic, copy) NSString * clientpointsid;
@property (nonatomic, copy) NSString * content;
@property (nonatomic, copy) NSString * cptypes;
@property (nonatomic, copy) NSString * creationtime;
@property (nonatomic, copy) NSString * membercardid;
@property (nonatomic, copy) NSString *memo;
@property (nonatomic, copy) NSString *points;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *subtype;
@property (nonatomic, copy) NSString *tcid;
@property (nonatomic, copy) NSString *maintype;

@end


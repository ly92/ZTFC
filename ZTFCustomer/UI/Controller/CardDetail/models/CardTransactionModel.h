//
//  CardTransactionModel.h
//  EstateBiz
//
//  Created by ly on 16/6/15.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CardTransactionModel : NSObject
@property (copy, nonatomic) NSString *last_datetime;//
@property (copy, nonatomic) NSString *last_id;//
@property (copy, nonatomic) NSString *reason;//
@property (copy, nonatomic) NSString *result;//
@property (strong, nonatomic) NSMutableArray *data;//

@end

@interface TransactionModel : NSObject
@property (copy, nonatomic) NSString *adminid;//
@property (copy, nonatomic) NSString *amount;//
@property (copy, nonatomic) NSString *bid;//
@property (copy, nonatomic) NSString *cid;//
@property (copy, nonatomic) NSString *content;//
@property (copy, nonatomic) NSString *creationtime;//
@property (copy, nonatomic) NSString *maintype;//
@property (copy, nonatomic) NSString *membercardid;//
@property (copy, nonatomic) NSString *modifiedtime;//
@property (copy, nonatomic) NSString *receipt;//
@property (copy, nonatomic) NSString *subtype;//
@property (copy, nonatomic) NSString *tcid;//
@property (copy, nonatomic) NSString *tid;//
@property (copy, nonatomic) NSString *tmemo;//
@property (copy, nonatomic) NSString *tnum;//
@property (copy, nonatomic) NSString *tstatus;//
@property (copy, nonatomic) NSString *itemlist;//

@end

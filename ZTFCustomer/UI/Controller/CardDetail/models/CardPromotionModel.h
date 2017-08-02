//
//  CardPromotionModel.h
//  EstateBiz
//
//  Created by ly on 16/6/15.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BizTransactionInfo,PromotionMsg,Msg_Extinfo,PromotionInfo,PromotionItem;
@interface CardPromotionModel : NSObject
@property (copy, nonatomic) NSString *result;//
@property (copy, nonatomic) NSString *reason;//
@property (copy, nonatomic) NSString *last_datetime;//
@property (copy, nonatomic) NSString *last_id;//
@property (strong, nonatomic) NSArray *CardList;//

@end

@interface PromotionModel : NSObject
@property (copy, nonatomic) NSString *bid;//
@property (strong, nonatomic) BizTransactionInfo *biztransactioninfo;//
@property (copy, nonatomic) NSString *content;//
@property (copy, nonatomic) NSString *creationtime;//
@property (copy, nonatomic) NSString *imageurl;//
@property (copy, nonatomic) NSString *istime;//
@property (copy, nonatomic) NSString *mid;//
@property (copy, nonatomic) NSString *msg_obj_id;//
@property (copy, nonatomic) NSString *msg_type;//
@property (copy, nonatomic) NSString *outlink;//
@property (copy, nonatomic) NSString *sendtime;//
@property (copy, nonatomic) NSString *tid;//
@property (copy, nonatomic) NSString *title;//

@property (strong, nonatomic) Msg_Extinfo *msg_extinfo;//
@property (strong, nonatomic) PromotionMsg *Msg;//

@end


@interface BizTransactionInfo : NSObject
@property (copy, nonatomic) NSString *adminid;//
@property (copy, nonatomic) NSString *amount;//
@property (copy, nonatomic) NSString *bid;//
@property (copy, nonatomic) NSString *creationtime;//
@property (copy, nonatomic) NSString *desc;//
@property (copy, nonatomic) NSString *modifiedtime;//
@property (copy, nonatomic) NSString *tid;//
@property (copy, nonatomic) NSString *tnum;//
@property (copy, nonatomic) NSString *tstatus;//
@property (copy, nonatomic) NSString *ttype;//
@end

@interface Msg_Extinfo: NSObject
@property (nonatomic, strong) PromotionInfo * info;
@property (nonatomic, strong) NSString * is_join;
@property (nonatomic, strong) NSArray * item;
@end

@interface PromotionMsg: NSObject
@property (nonatomic, strong) NSString * adminid;
@property (nonatomic, strong) NSString * amount;
@property (nonatomic, strong) NSString * bid;
@property (nonatomic, strong) NSString * creationtime;
@property (nonatomic, strong) NSString * desc;
@property (nonatomic, strong) NSString * modifiedtime;
@property (nonatomic, strong) NSString * tid;
@property (nonatomic, strong) NSString * tnum;
@property (nonatomic, strong) NSString * tstatus;
@property (nonatomic, strong) NSString * ttype;

@property (nonatomic, copy) NSString *is_join;
@property (nonatomic, strong) PromotionInfo *info;
@end

@interface PromotionInfo: NSObject
@property (nonatomic, strong) NSString * bid;
@property (nonatomic, strong) NSString * creationtime;
@property (nonatomic, strong) NSString * ID;
@property (nonatomic, strong) NSString * intro;
@property (nonatomic, strong) NSString * isdeleted;
@property (nonatomic, strong) NSString * joinmembers;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * option_type;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * voted_users;
@property (nonatomic, strong) NSString * votes;

@end

@interface PromotionItem: NSObject
@property (nonatomic, strong) NSString * ID;
@property (nonatomic, strong) NSString * item_name;
@property (nonatomic, strong) NSString * votes;
@end



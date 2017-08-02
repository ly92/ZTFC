//
//  CouponListModel.h
//  EstateBiz
//
//  Created by ly on 16/6/14.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface CouponListModel : NSObject
@property (nonatomic, copy) NSString * reason;//""
@property (nonatomic, copy) NSString * result;//

@property (strong, nonatomic) NSArray *List;//
@end

@interface CouponModel : NSObject
@property (nonatomic, copy) NSString * address;//
@property (nonatomic, copy) NSString * amount;//
@property (nonatomic, copy) NSString * bid;//
@property (nonatomic, copy) NSString * biz_coupon_id;//
@property (nonatomic, copy) NSString * cardid;//
@property (nonatomic, copy) NSString * cardnum;//
@property (nonatomic, copy) NSString * cardtype;//
@property (nonatomic, copy) NSString * contents;//
@property (nonatomic, copy) NSString * expire;//
@property (nonatomic, copy) NSString * extra;//
@property (nonatomic, copy) NSString * imageurl;//
@property (nonatomic, copy) NSString * isalliance;//
@property (nonatomic, copy) NSString * lasttime;//
@property (nonatomic, copy) NSString * name;//
@property (nonatomic, strong) NSArray * sns;//
@property (nonatomic, copy) NSString * tel;//
@property (nonatomic, copy) NSString * title;//
@property (nonatomic, copy) NSString * unuse;//
@property (nonatomic, copy) NSString * used;//

@property (nonatomic, copy) NSString *nums;
@property (nonatomic, copy) NSString *use_nums;





@end

@interface SnModel : NSObject
@property (nonatomic, copy) NSString * end_date;//""
@property (nonatomic, copy) NSString * orguser;//""
@property (nonatomic, copy) NSString * sn;//""
@property (nonatomic, copy) NSString * start_date;//""
@property (nonatomic, copy) NSString * status;//""

@end



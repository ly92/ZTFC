//
//  DropModel.h
//  ZTFCustomer
//
//  Created by mac on 16/9/20.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DropModel : NSObject

@property (nonatomic, copy) NSString *income;
@property (nonatomic, copy) NSString *pay;
@property (nonatomic, copy) NSString *left;
@end

@interface DropPayBizInfoModel : NSObject
@property (nonatomic, copy) NSString *bid;
@property (nonatomic, copy) NSString *name;

@end

@interface DropPayGalleryModel : NSObject

@property (nonatomic, copy) NSString *atid;
@property (nonatomic, copy) NSString *destatid;
@property (nonatomic, copy) NSString *discount;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *pano;
@property (nonatomic, copy) NSString *payid;

@end

//
//  HousesModel.h
//  ztfCustomer
//
//  Created by mac on 16/7/14.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AlbumModel;

@interface HousesModel : NSObject

@property (nonatomic, copy) NSString *project_id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *lat;
@property (nonatomic, copy) NSString *lng;
@property (nonatomic, copy) NSString *intro;
@property (nonatomic, copy) NSString *average_price;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *mid;
@property (nonatomic, copy) NSString *team_id;
@property (nonatomic, copy) NSString *employee_id;
@property (nonatomic, copy) NSString *tel;

@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *is_favorite;
@property (nonatomic, copy) NSString *is_join;
@property (nonatomic, copy) NSString *advertisement;
@property (nonatomic, copy) NSString *favorites;
@property (nonatomic, copy) NSString *community_id;


@property (nonatomic, strong) AlbumModel *album;

@end

@interface AreaOprionModel : NSObject<NSCoding>

@property (nonatomic, copy) NSString *area_id;
@property (nonatomic, copy) NSString *max_value;
@property (nonatomic, copy) NSString *min_value;
@property (nonatomic, copy) NSString *name;

@end

@interface HouseTypeOptionModel : NSObject<NSCoding>

@property (nonatomic, copy) NSString *hall;
@property (nonatomic, copy) NSString *house_type_id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *room;
@property (nonatomic, copy) NSString *toilet;

@end

@interface PriceOptionModel : NSObject<NSCoding>

@property (nonatomic, copy) NSString *max_value;
@property (nonatomic, copy) NSString *min_value;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *price_id;

@end


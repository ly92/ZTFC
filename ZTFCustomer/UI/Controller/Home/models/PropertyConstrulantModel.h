//
//  PropertyConstrulantModel.h
//  ztfCustomer
//
//  Created by mac on 16/7/14.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AlbumModel;
@class HousesModel;
@class TeamModel;

//楼栋管家模型
@interface PropertyConstrulantModel : NSObject<NSCoding>


@property (nonatomic, copy) NSString *easemob;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *star;
@property (nonatomic, copy) NSString *employee_number;
@property (nonatomic, copy) NSString *star_name;
@property (nonatomic, copy) NSString *department;
@property (nonatomic, copy) NSString *community_id;

@property (nonatomic, strong) HousesModel *project;
@property (nonatomic, strong) TeamModel *team;




@end

@interface PropertyMessageModel : NSObject

@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *creationtime;
@property (nonatomic, copy) NSString *is_read;
@property (nonatomic, copy) NSString *link;
@property (nonatomic, copy) NSString *message_id;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, strong) AlbumModel *album;
@property (nonatomic, strong) PropertyConstrulantModel *employee;

@end

@interface AlbumModel : NSObject

@property (nonatomic, copy) NSString *creationtime;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSArray *resources;

@end

@interface ResourceModel : NSObject

@property (nonatomic, copy) NSString *creationtime;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *weight;

@end

@interface TeamModel : NSObject

@property (nonatomic, copy) NSString *appid;
@property (nonatomic, copy) NSString *createontime;
@property (nonatomic, copy) NSString *employee_id;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *modifyontime;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *project_id;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *team_id;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *type_id;

@end

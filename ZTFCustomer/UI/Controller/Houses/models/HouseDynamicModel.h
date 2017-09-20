//
//  HouseDynamicModel.h
//  ZTFCustomer
//
//  Created by 李勇 on 2017/9/20.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HouseDynamicModel : NSObject<NSCoding>

/***/
@property (nonatomic, copy) NSString *create_at;//": "2017-09-17 16:32:35", 创建时间
@property (nonatomic, copy) NSString *progress_introduce_img;//": 详情列表展示主图
@property (nonatomic, copy) NSString *progress_title;//": "我的进展9月170",  楼盘进展标题
@property (nonatomic, copy) NSString *project_progress_id;// 楼盘进展id
@property (nonatomic, copy) NSString *project_id;//": 36, 项目id
@property (nonatomic, copy) NSString *progress_introduce;//": "简介", 楼盘进展简介

/**
 
 上面的是列表的，下面的是详情的
 **/

/***/


@property (nonatomic, copy) NSString *progress_content;//": "内容", 楼盘进展内容

@property (nonatomic, copy) NSString *update_at;//": "2017-09-17 16:32:35", 更新时间
@property (nonatomic, strong) NSArray * progress_imgs;//" 楼盘进展详情轮播图


@end


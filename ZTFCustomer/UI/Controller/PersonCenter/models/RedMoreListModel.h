//
//  RedMoreListModel.h
//  ZTFCustomer
//
//  Created by mac on 16/9/19.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RedMoreListModel : NSObject
@property (nonatomic, strong) NSNumber * id; //ID
@property (nonatomic, strong) NSString * title; //名称
@property (nonatomic, strong) NSString * icon_url; //图片链接URL
@property (nonatomic, strong) NSString * url;   //跳转URL
@property (nonatomic, strong) NSString * image; //图片
@end

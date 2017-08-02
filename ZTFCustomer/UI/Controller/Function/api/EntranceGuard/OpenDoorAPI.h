//
//  OpenDoorAPI.h
//  EstateBiz
//
//  Created by wangshanshan on 16/6/14.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

typedef NS_ENUM(NSInteger,OPENDOORTYPE) {
    OPENDOOR, //开门
    GETDOORINFO,  //获取门信息
};

@interface OpenDoorAPI : YTKRequest

@property (nonatomic, assign) OPENDOORTYPE doorType;

-(instancetype)initWithQrcode:(NSString *)qrcode;

@end

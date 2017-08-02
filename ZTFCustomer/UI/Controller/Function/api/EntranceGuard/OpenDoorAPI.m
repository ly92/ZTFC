//
//  OpenDoorAPI.m
//  EstateBiz
//
//  Created by wangshanshan on 16/6/14.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "OpenDoorAPI.h"

@interface OpenDoorAPI ()
{
    NSString *_qrcode;
}
@end

@implementation OpenDoorAPI

-(instancetype)initWithQrcode:(NSString *)qrcode{
    if (self == [super init]) {
        _qrcode = qrcode;
    }
    return self;
}


-(NSString *)requestUrl{
    switch (self.doorType) {
        case OPENDOOR:
             return ENTRANCE_OPENDOOR;
            break;
        case GETDOORINFO:
            return ENTRANCE_INFO;
            break;
        default:
            break;
    }
   
}

-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

-(id)requestArgument{
    return @{@"qrcode":_qrcode};
}

@end

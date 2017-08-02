//
//  GetPayGalleryAPI.m
//  ZTFCustomer
//
//  Created by mac on 2017/3/16.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "GetPayGalleryAPI.h"

@interface GetPayGalleryAPI ()

{
    NSString *_bid;
}

@end

@implementation GetPayGalleryAPI

-(instancetype)initWithBid:(NSString *)bid{
    if (self == [super init]) {
        _bid = bid;
    }
    return self;
}

-(NSString *)requestUrl{
    return MYDROP_GETGALLERY;
}
-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}
-(id)requestArgument{
    return @{
             @"bid":_bid};
}

@end

//
//  ApplyComplaintAPI.h
//  ztfCustomer
//
//  Created by mac on 16/9/13.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface ApplyComplaintAPI : YTKRequest

-(instancetype)initWithCommunityid:(NSString *)communityid type:(NSString *)type content:(NSString *)content username:(NSString *)username mobile:(NSString *)mobile address:(NSString *)address image:(UIImage *)image;

@end

//
//  ApplyRepairAPI.h
//  ztfCustomer
//
//  Created by mac on 16/9/14.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface ApplyRepairAPI : YTKRequest

-(instancetype)initWithCommunityid:(NSString *)communityid unit:(NSString *)unit maintype:(NSString *)maintype subtype:(NSString *)subtype content:(NSString *)content username:(NSString *)username mobile:(NSString *)mobile address:(NSString *)address image:(UIImage *)image;

@end

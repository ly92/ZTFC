//
//  ScanAddMemberAPI.h
//  EstateBiz
//
//  Created by wangshanshan on 16/6/15.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>


//c端扫描b端加会员
@interface ScanAddMemberAPI : YTKRequest

-(instancetype)initWithRecommendId:(NSString *)recommendId bid:(NSString *)bid;

@end

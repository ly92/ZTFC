//
//  MemberCardDetailAPI.h
//  EstateBiz
//
//  Created by wangshanshan on 16/6/2.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface MemberCardDetailAPI : YTKRequest

-(instancetype)initWithCardId:(NSString *)cardId cardType:(NSString *)cardType;

@end

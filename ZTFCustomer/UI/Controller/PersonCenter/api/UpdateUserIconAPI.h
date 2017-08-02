//
//  UpdateUserIconAPI.h
//  EstateBiz
//
//  Created by wangshanshan on 16/6/16.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

//上传头像
@interface UpdateUserIconAPI : YTKRequest

-(instancetype)initWithImage:(UIImage *)image;

@end

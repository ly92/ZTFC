//
//  UpdateUserIconAPI.m
//  EstateBiz
//
//  Created by wangshanshan on 16/6/16.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "UpdateUserIconAPI.h"


@interface UpdateUserIconAPI ()
{
    UIImage *_image;
}

@end

@implementation UpdateUserIconAPI

-(instancetype)initWithImage:(UIImage *)image{
    if (self == [super init]) {
        _image = image;
    }
    return self;
}

-(NSString *)requestUrl{
    return UPDATE_USER_LOGO;
}
-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

- (AFConstructingBlock)constructingBodyBlock {
    return ^(id<AFMultipartFormData> formData) {
        
        NSData *data = UIImageJPEGRepresentation(_image, 0.5f);
        NSString *name = @"photo.jpg";
        NSString *formKey = @"usericon";
        NSString *type = @"image/jpeg";
        [formData appendPartWithFileData:data name:formKey fileName:name mimeType:type];
        
    };
}

@end

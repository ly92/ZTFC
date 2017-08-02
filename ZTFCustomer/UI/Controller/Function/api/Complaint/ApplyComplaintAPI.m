//
//  ApplyComplaintAPI.m
//  ztfCustomer
//
//  Created by mac on 16/9/13.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "ApplyComplaintAPI.h"

@interface ApplyComplaintAPI ()
{
    NSString *_communityid;
    NSString *_type;
    NSString *_content;
    NSString *_username;
    NSString *_mobile;
    NSString *_address;
    UIImage *_image;

}
@end

@implementation ApplyComplaintAPI

-(instancetype)initWithCommunityid:(NSString *)communityid type:(NSString *)type content:(NSString *)content username:(NSString *)username mobile:(NSString *)mobile address:(NSString *)address image:(UIImage *)image{
    if (self == [super init]) {
        _communityid = communityid;
        _type = type;
        _content = content;
        _username = username;
        _mobile = mobile;
        _address = address;
        _image = image;
    }
    return self;
}

-(NSString *)requestUrl{
    return YSSH_COMPLAINT_APPLY;
}
-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

- (AFConstructingBlock)constructingBodyBlock {
    return ^(id<AFMultipartFormData> formData) {
        if (_image) {
            NSData *data = UIImageJPEGRepresentation(_image, 0.5f);
            NSString *name = @"image.jpg";
            NSString *formKey = @"image";
            NSString *type = @"image/jpeg";
            [formData appendPartWithFileData:data name:formKey fileName:name mimeType:type];
        }
    };
}


-(id)requestArgument{
    return @{@"communityid":_communityid,
             @"type":_type,
             @"content":_content,
             @"username":_username,
             @"mobile":_mobile,
             @"address":_address};
}
@end

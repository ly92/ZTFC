//
//  ApplyRepairAPI.m
//  ztfCustomer
//
//  Created by mac on 16/9/14.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "ApplyRepairAPI.h"

@interface ApplyRepairAPI()
{
    NSString *_communityid;
    NSString *_unit;
    NSString *_maintype;
    NSString *_subtype;
    NSString *_content;
    NSString *_username;
    NSString *_mobile;
    NSString *_address;
    UIImage *_image;
}
@end

@implementation ApplyRepairAPI

-(instancetype)initWithCommunityid:(NSString *)communityid unit:(NSString *)unit maintype:(NSString *)maintype subtype:(NSString *)subtype content:(NSString *)content username:(NSString *)username mobile:(NSString *)mobile address:(NSString *)address image:(UIImage *)image{
    if (self == [super init]) {
        _communityid = communityid;
        _unit = unit;
        _maintype = maintype;
        _subtype = subtype;
        _content = content;
        _username = username;
        _mobile = mobile;
        _address = address;
        _image = image;
    }
    return self;
}
-(NSString *)requestUrl{
    return YSSH_REPAIR_APPLY;
}

-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}
- (AFConstructingBlock)constructingBodyBlock {
    return ^(id<AFMultipartFormData> formData) {
        if(_image){
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
             @"unit":_unit,
             @"maintype":_maintype,
             @"subtype":_subtype,
             @"content":_content,
             @"username":_username,
             @"mobile":_mobile,
             @"address":_address};
}


@end

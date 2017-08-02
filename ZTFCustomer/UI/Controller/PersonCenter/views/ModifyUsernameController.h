//
//  ModifyUsernameController.h
//  EstateBiz
//
//  Created by wangshanshan on 16/6/16.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum
{
    nameType = 0, //真实姓名
    addressType = 1 , //地址
    emailType = 2  //邮箱
    
}ActivityType;

typedef void (^nameInfoBlock)(NSString *infoString);

@interface ModifyUsernameController : UITableViewController

-(void)infoWithName:(NSString*)name  activityType:(ActivityType)activityType Then:(nameInfoBlock)block;

@end

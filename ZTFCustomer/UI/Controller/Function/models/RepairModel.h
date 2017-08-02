//
//  RepairModel.h
//  ztfCustomer
//
//  Created by mac on 16/9/14.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface RepairModel : YTKRequest

@end


@interface RepairSubtypeModel : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *maintype;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *status;
@end
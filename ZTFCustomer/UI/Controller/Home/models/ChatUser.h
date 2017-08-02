//
//  ChatUser.h
//  EstateBiz
//
//  Created by Ender on 4/27/16.
//  Copyright © 2016 Magicsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatUser : NSObject<NSCoding>

@property(nonatomic,copy) NSString *im;
@property(nonatomic,copy) NSString *name;
@property(nonatomic,copy) NSString *avatar;

@end

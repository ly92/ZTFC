//
//  ChatUser.m
//  EstateBiz
//
//  Created by Ender on 4/27/16.
//  Copyright © 2016 Magicsoft. All rights reserved.
//

#import "ChatUser.h"

@implementation ChatUser

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self=[super init]) {
        
        [self mj_decode:aDecoder];
//        self.im = [aDecoder decodeObjectForKey:@"im"];
//        self.name = [aDecoder decodeObjectForKey:@"name"];
//        self.avatar = [aDecoder decodeObjectForKey:@"avatar"];
        
    }
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    
    [self mj_encode:aCoder];
//    [aCoder encodeObject:self.im forKey:@"im"];
//    [aCoder encodeObject:self.name forKey:@"name"];
//    [aCoder encodeObject:self.avatar forKey:@"avatar"];
}

@end

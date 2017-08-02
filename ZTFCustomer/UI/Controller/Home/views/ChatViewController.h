//
//  ChatViewController.h
//  ztfCustomer
//
//  Created by mac on 16/7/13.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "EaseMessageViewController.h"

@interface ChatViewController : EaseMessageViewController

- (instancetype)initWithConversationChatter:(NSString *)conversationChatter
                           conversationType:(EMConversationType)conversationType FromOther:(BOOL)yesOrNo;

@end

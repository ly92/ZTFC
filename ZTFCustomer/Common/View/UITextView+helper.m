//
//  UITextView+helper.m
//  EstateBiz
//
//  Created by Ender on 10/21/15.
//  Copyright © 2015 Magicsoft. All rights reserved.
//

#import "UITextView+helper.h"

@implementation UITextView(helper)

//多语言
-(void)textLocalizedText:(NSString *)text
{
    self.text = NSLocalizedString(text, nil);
}

/**
 *  真正才计算高度的函数
 */
-(void)autoCalculateTextViewFrame
{
    CGRect frame = self.frame;
    
    float fPadding = 16.0; // 8.0px x 2
    
    CGSize constraint = CGSizeMake(self.contentSize.width - fPadding, CGFLOAT_MAX);
    
//    CGSize size = [self.text sizeWithFont: self.font constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    
    CGSize size = [self.text boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.font} context:nil].size;
    
    frame.size.height = size.height + 16.0;
    
    self.frame = frame;
}
@end

//
//  UITextField+helper.m
//  EstateBiz
//
//  Created by Ender on 10/21/15.
//  Copyright © 2015 Magicsoft. All rights reserved.
//

#import "UITextField+helper.h"

@implementation UITextField(helper)
-(void)textLocalizedText:(NSString *)text
{
    self.text = NSLocalizedString(text, nil);
}

-(void)placeHolderLocalized:(NSString *)placeHoder
{
    self.placeholder = NSLocalizedString(placeHoder, nil);
}
@end

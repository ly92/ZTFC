//
//  ComplaintDetailController.h
//  WeiTown
//
//  Created by Ender on 8/29/15.
//  Copyright (c) 2015 Hairon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ComplaintDetailController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate>


- (instancetype)initWithMainType:(NSString *)aType Order:(ComplaintModel *)item;

- (IBAction)submit:(id)sender;
- (IBAction)hideKeyboardClicked:(id)sender;

@end

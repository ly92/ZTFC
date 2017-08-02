//
//  AddressBookViewController.h
//  ZTFCustomer
//
//  Created by mac on 16/11/25.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol AddressBookViewDelegate <NSObject>
@optional

-(void)passValue:(NSString *)phoneNum KeyName:(NSString *)keyName;

@end

@interface AddressBookViewController : UITableViewController

@property (nonatomic) id <AddressBookViewDelegate> delegate;

@end

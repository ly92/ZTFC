//
//  BindingPropertyConstrulantCell.h
//  ztfCustomer
//
//  Created by mac on 16/7/5.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

//没有管家、有顾问或者没有顾问

@protocol BindingPropertyConstrulantCellDelegate <NSObject>

-(void)bindingClickWithStr:(id)modelData;

@end

@interface BindingPropertyConstrulantCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *bindingButton;

@property (nonatomic,weak)id<BindingPropertyConstrulantCellDelegate> delegate;
@end

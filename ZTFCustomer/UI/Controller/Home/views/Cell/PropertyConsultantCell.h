//
//  PropertyConsultantCell.h
//  ztfCustomer
//
//  Created by mac on 16/7/1.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

//楼栋管家列表cell
@protocol PropertyConsultantCellDelegate <NSObject>

-(void)chatClick;
-(void)bindingClick;
-(void)iconImgClick;

@end

@interface PropertyConsultantCell : UITableViewCell
@property (nonatomic,weak)id<PropertyConsultantCellDelegate> delegate;
@end

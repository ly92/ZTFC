//
//  PropertyConstrulantDetailHeaderCell.h
//  ztfCustomer
//
//  Created by mac on 16/7/4.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PropertyConstrulantDetailHeaderCellDelegate <NSObject>

-(void)mobileClick;
-(void)chatClick;

@end

@interface PropertyConstrulantDetailHeaderCell : UITableViewCell

@property (nonatomic, assign) BOOL isSteward;


@property (nonatomic,weak)id<PropertyConstrulantDetailHeaderCellDelegate> delegate;



@end

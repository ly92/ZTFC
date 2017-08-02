//
//  PropertyConstrulantDetailCell.h
//  ztfCustomer
//
//  Created by mac on 16/7/4.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

//顾问信息列表cell
@protocol PropertyConstrulantDetailCellDelegate <NSObject>

-(void)changePropertyClick;
-(void)mobileClick;
-(void)smsClick;

@end

@interface PropertyConstrulantDetailCell : UITableViewCell

@property (nonatomic,weak)id<PropertyConstrulantDetailCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cotentLbltrailing;
@property (weak, nonatomic) IBOutlet UILabel *contentLbl;

@property (weak, nonatomic) IBOutlet UIButton *mobileButton;
@property (weak, nonatomic) IBOutlet UIButton *smsButton;
//更换置业顾问
@property (weak, nonatomic) IBOutlet UIButton *changePropertyButton;

@end

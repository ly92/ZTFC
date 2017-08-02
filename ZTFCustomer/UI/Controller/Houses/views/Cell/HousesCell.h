//
//  HousesCell.h
//  ztfCustomer
//
//  Created by mac on 16/7/1.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HousesCellDelegate <NSObject>

-(void)loveButtonClick:(id)modelData;

@end

@interface HousesCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *loveButton;

@property (nonatomic,weak) id<HousesCellDelegate> delegate;


@end

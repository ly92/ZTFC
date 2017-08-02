//
//  PayTypeTableViewCell.h
//  WeiTown
//
//  Created by kakatool on 15/12/1.
//  Copyright © 2015年 Hairon. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "NoHitButton.h"
@interface PayTypeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (retain, nonatomic) IBOutlet UILabel *name;
@property (retain, nonatomic) IBOutlet UIButton *selectedIcon;
@property (retain, nonatomic) IBOutlet UILabel *memoLbl;

@end

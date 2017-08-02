//
//  VoteResultTableViewCell.h
//  colourlife
//
//  Created by ly on 16/1/22.
//  Copyright © 2016年 liuyadi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VoteResultTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *introL;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *VW;
@property (weak, nonatomic) IBOutlet UILabel *lab;
@property (weak, nonatomic) IBOutlet UIView *botView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@end

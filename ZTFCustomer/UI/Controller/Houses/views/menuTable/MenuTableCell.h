//
//  MenuTableCell.h
//  MenuTable
//
//  Created by mac on 16/10/18.
//  Copyright © 2016年 shanshan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *contentLbl;

@property (nonatomic, strong) id data;

@end

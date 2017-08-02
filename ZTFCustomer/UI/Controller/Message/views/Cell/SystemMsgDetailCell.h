//
//  SystemMsgDetailCell.h
//  EstateBiz
//
//  Created by wangshanshan on 16/6/3.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SystemMsgDetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLbl;

@property (weak, nonatomic) IBOutlet UILabel *contentLbl;

@property (weak, nonatomic) IBOutlet UILabel *dateTimeLbl;

//@property (nonatomic, strong) MessageModel *systemMsgModel;

@end

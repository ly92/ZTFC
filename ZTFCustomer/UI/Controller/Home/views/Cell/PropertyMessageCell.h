//
//  PropertyMessageCell.h
//  ZTFCustomer
//
//  Created by wangshanshan on 16/11/6.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PropertyMessageCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *bubbleLbl;

@property (nonatomic, assign) BOOL isList;//是列表
@property (nonatomic, assign) BOOL isSteward;

@property (nonatomic, strong) PropertyMessageModel *propertyMessageModel;

@property (nonatomic, strong) PropertyMessageModel *propertyMessageDetailModel;

@end

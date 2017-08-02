//
//  HomeServiceCell.h
//  EstateBiz
//
//  Created by wangshanshan on 16/6/7.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol HomeServiceCellDelegate <NSObject>

-(void)functionDidSelectCell:(id)data;

@end

@interface HomeServiceCell : UITableViewCell

@property (nonatomic, weak) id <HomeServiceCellDelegate> delegate;


@end

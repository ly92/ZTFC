//
//  HomeActivityCell.h
//  EstateBiz
//
//  Created by wangshanshan on 16/6/7.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol HomeActivityCellDelegate <NSObject>

-(void)activityDidSelectCell:(id)data;

@end

@interface HomeActivityCell : UITableViewCell

@property (nonatomic, weak) id <HomeActivityCellDelegate> delegate;

+ (CGFloat)heightForHomeActivityWithDataCount:(NSInteger)count cardStyle:(LIMITYACTIVITY_STYLE)cardStyle;

@end

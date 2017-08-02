//
//  HomeMemberCardCell.h
//  ZTFCustomer
//
//  Created by mac on 2016/12/6.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HomeMemberCardCellDelegate <NSObject>

-(void)didselectMemberCardWithData:(id)data;
-(void)didDeleteMemberCardwithArr:(NSMutableArray *)arr;
-(void)didCollectMemberCardWithArr:(NSMutableArray *)arr;

@end

@interface HomeMemberCardCell : UITableViewCell

@property (nonatomic, weak) id<HomeMemberCardCellDelegate> delegate;

@end

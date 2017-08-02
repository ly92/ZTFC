//
//  StewardCell.h
//  ZTFCustomer
//
//  Created by mac on 16/11/4.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol StewardCellDelegate <NSObject>

-(void)clickWithTag:(NSInteger)tag;

//-(void)propertyViewClick;
//-(void)propertyImgClick;
//-(void)stewardViewClick;
//-(void)stewardImgClick;


@end

@interface StewardCell : UITableViewCell

@property (nonatomic, weak) id<StewardCellDelegate> delegate;

@end

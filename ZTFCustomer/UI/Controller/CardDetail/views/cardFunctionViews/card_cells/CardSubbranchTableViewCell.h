//
//  CardSubbranchTableViewCell.h
//  colourlife
//
//  Created by 李勇 on 16/1/14.
//  Copyright © 2016年 liuyadi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CallShop)();

@interface CardSubbranchTableViewCell : UITableViewCell

@property (nonatomic, copy) CallShop call;

-(CGFloat)cellHeight;

@end

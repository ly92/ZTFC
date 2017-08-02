//
//  WeatherCell.h
//  EstateBiz
//
//  Created by wangshanshan on 16/6/7.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MsgDetail)(AdModel *messageModel);
typedef void(^MsgUrlClick) (AdModel *messageModel);

@interface WeatherCell : UITableViewCell

@property (copy, nonatomic) MsgDetail msgDetail;//
@property (nonatomic, copy) MsgUrlClick msgUrlClick;
//@property (nonatomic, strong) MessageModel *msgDetail;

@end

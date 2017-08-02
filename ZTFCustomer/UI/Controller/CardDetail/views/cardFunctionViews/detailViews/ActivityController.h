//
//  ActivityController.h
//  KaKaTool
//
//  Created by fengwanqi on 13-12-25.
//  Copyright (c) 2013年 com.coortouch.ender. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Msg_Extinfo;
@protocol ActivityControllerDelegate <NSObject>

@optional
-(void)refreshData;

@end

@interface ActivityController : UIViewController

@property (nonatomic,assign)id <ActivityControllerDelegate>activityDelegate;

-(instancetype)initWithMsgInfo:(Msg_Extinfo *)msgInfo creationtime:(PromotionModel *)creationtime;
@end

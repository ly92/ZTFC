//
//  MsgDetailController.h
//  CardToon
//
//  Created by fengwanqi on 13-11-13.
//  Copyright (c) 2013年 com.coortouch.ender. All rights reserved.
//

@class Msg_Extinfo;

@protocol VoteDetailControllerDelegate <NSObject>

@optional
-(void)refreshData;

@end

@interface VoteDetailController : UIViewController

@property (nonatomic,assign)id <VoteDetailControllerDelegate>voteDelegate;
- (instancetype)initWithMsgInfo:(Msg_Extinfo *)msgInfo promotion:(PromotionModel *)promotion;


@end

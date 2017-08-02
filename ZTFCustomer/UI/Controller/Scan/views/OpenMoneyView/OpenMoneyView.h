//
//  OpenMoneyView.h
//  WeiTown
//
//  Created by kakatool on 15/10/28.
//  Copyright © 2015年 Hairon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OpenMoneyView : UIView
@property(nonatomic,assign) UIViewController *parentCtrl;
@property(nonatomic,retain) UIView *bgView;
@property (nonatomic, retain) UIImageView *bgImageView;
@property (nonatomic, retain) UILabel *nameLbl;
//金币的图标
@property (nonatomic, retain) UIImageView *moneyImageView;
@property (nonatomic, retain) UILabel *countLbl;
@property (nonatomic, retain) UILabel *counDescLbl;
@property (nonatomic, retain) UILabel *shopLbl;
@property (nonatomic, retain) UIButton *cancelBtn;
@property (nonatomic, retain) UIButton *confirmBtn;

@property(nonatomic,retain) NSString *snid;

-(id)initWithParentController:(UIViewController *)aParentCtrl;

-(void)show:(NSString *)content;

-(void)hide;

@end

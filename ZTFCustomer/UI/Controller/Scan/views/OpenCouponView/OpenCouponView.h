//
//  OpenCouponView.h
//  WeiTown
//
//  Created by Ender on 8/30/15.
//  Copyright (c) 2015 Hairon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OpenCouponView : UIView

@property(nonatomic,assign) UIViewController *parentCtrl;
@property(nonatomic,retain) UIView *bgView;
@property (nonatomic, retain) UIImageView *bgImageView;
@property (nonatomic, retain) UILabel *nameLbl;
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

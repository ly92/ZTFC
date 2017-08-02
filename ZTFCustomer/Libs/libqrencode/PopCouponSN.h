//
//  PopCouponSN.h
//  WeiTown
//
//  Created by 沿途の风景 on 14-9-10.
//  Copyright (c) 2014年 Hairon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopCouponSN : UIView

@property(nonatomic,assign) UIViewController *parentCtrl;
@property(nonatomic,strong) UIView *qrView;

@property (nonatomic, strong) UIImageView *qrImageView;
@property (nonatomic, strong) UILabel *snLbl;

-(id)initWithParentController:(UIViewController *)aParentCtrl;

-(void)show:(NSString *)qrCode;

-(void)showCard:(NSString *)qrCode;

-(void)showQR:(NSString *)qrCode WithSN:(NSString *)sn;

-(void)hide;

@end

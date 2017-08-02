//
//  NSObject+Tips.m
//  Foomoo
//
//  Created by QFish on 6/6/14.
//  Copyright (c) 2014 QFish.inc. All rights reserved.
//

#import "NSObject+Tips.h"
#import "MMBProgressHUD.h"
#import <objc/runtime.h>

static const char kUIViewMBProgressHUDKey;
static const char kUIViewBgViewKey;

@interface UIView (PrivateTips)
@property (nonatomic, strong) UIView * bgView;
@property (nonatomic, strong) MMBProgressHUD * mb_hud;
@end

@implementation UIView (PrivateTips)

@dynamic mb_hud;
@dynamic bgView;

- (void)setMb_hud:(MMBProgressHUD *)mb_hud
{
	objc_setAssociatedObject(self, &kUIViewMBProgressHUDKey, mb_hud, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (MMBProgressHUD *)mb_hud
{
	return objc_getAssociatedObject(self, &kUIViewMBProgressHUDKey);
}

- (void)setBgView:(UIView *)bgView
{
    objc_setAssociatedObject(self, &kUIViewBgViewKey, bgView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)bgView
{
    return objc_getAssociatedObject(self, &kUIViewBgViewKey);
}
	
@end

#pragma mark-

@implementation UIView (Tips)

- (void)showTips:(NSString *)message autoHide:(BOOL)autoHide
{
    [self dismissTips];
	UIView * container = self;
	
	if ( container )
	{
		if ( nil != self.mb_hud )
		{
			[self.mb_hud hide:NO];
		}
        
        if ( nil != self.bgView )
        {
            self.bgView.hidden = YES;
            [self.bgView removeFromSuperview];
            self.bgView = nil;
        }
		
		UIView * view = self;
		MMBProgressHUD *hud = [MMBProgressHUD showHUDAddedTo:view animated:YES];
		hud.mode = MBProgressHUDModeText;
		hud.yOffset -= 64;
		hud.detailsLabelText = message;
		hud.detailsLabelFont = [UIFont systemFontOfSize:15];
		self.mb_hud = hud;
		
		if ( autoHide )
		{
			[hud hide:YES afterDelay:2.0f];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
               [self dismissTips];
            });
		}
	}
}

- (void)presentMessageTips:(NSString *)message
{
	[self showTips:message autoHide:YES];
}

- (void)presentSuccessTips:(NSString *)message
{
    [self showTips:message autoHide:YES];
}

- (void)cLPresentSuccessTips:(NSString *)message {
    [self showpresentSuccessTips:message];
}

- (void)presentFailureTips:(NSString *)message
{
	[self showTips:message autoHide:YES];
}

- (void)presentLoadingTips:(NSString *)message
{
    [self dismissTips];
	UIView * container = self;
	
	if ( container )
	{
		if ( nil != self.mb_hud )
		{
			[self.mb_hud hide:NO];
		}
        
        if ( nil != self.bgView )
        {
            self.bgView.hidden = YES;
            [self.bgView removeFromSuperview];
            self.bgView = nil;
        }
        
        UIView * bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        bgView.backgroundColor = [UIColor blackColor];
        bgView.alpha = 0.6;
        self.bgView = bgView;
        
        [container addSubview:self.bgView];
        
		MMBProgressHUD *hud = [MMBProgressHUD showHUDAddedTo:container animated:YES];
        hud.color = [UIColor whiteColor];
		hud.mode = MBProgressHUDModeCustomView;
        hud.cornerRadius = 5;
        hud.size = CGSizeMake(100, 100);
        
        NSMutableArray * images = [NSMutableArray array];

        for ( int i = 0; i < 12; i++ )
        {
            NSString * imageStr = [NSString stringWithFormat:@"loading_000%.2d", i];
            [images addObject:[UIImage imageNamed:imageStr]];
        }

        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 63, 63)];
        imageView.backgroundColor = [UIColor whiteColor];
        imageView.animationImages = images;
        imageView.animationDuration = 0.9;
        imageView.animationRepeatCount = 0;
        [imageView startAnimating];

        hud.customView = imageView;
		self.mb_hud = hud;
	}
}

- (void)showpresentSuccessTips:(NSString *)message
{
    [self dismissTips];
    UIView * container = self;
    
    if ( container )
    {
        if ( nil != self.mb_hud )
        {
            [self.mb_hud hide:NO];
        }
        
        if ( nil != self.bgView )
        {
            self.bgView.hidden = YES;
            [self.bgView removeFromSuperview];
            self.bgView = nil;
        }
        
        UIView * bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        bgView.backgroundColor = [UIColor blackColor];
        bgView.alpha = 0.6;
        bgView.layer.cornerRadius = 5;
        self.bgView = bgView;
        [container addSubview:self.bgView];
       MMBProgressHUD *HUD = [[MMBProgressHUD alloc] initWithView:self];
        [self addSubview:HUD];
        HUD.labelText = message;
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pw_sucess"]];
        HUD.size = CGSizeMake(150, 90);
        [HUD show:YES];
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [imageView setImage:[UIImage imageNamed:@"pw_sucess"]];
        HUD.customView = imageView;
        self.mb_hud = HUD;
    }
}


- (void)dismissTips
{
	[self.mb_hud hide:YES];
    self.bgView.hidden = YES;
    [self.bgView removeFromSuperview];
    for (UIView * view in self.subviews)
    {
        if ( [view isEqual:self.bgView] )
        {
            [view removeFromSuperview];
        }
    }
    self.bgView = nil;
	self.mb_hud = nil;
}

@end

@implementation UIViewController (Tips)

- (void)presentMessageTips:(NSString *)message
{
	[self.view showTips:message autoHide:YES];
}

- (void)presentSuccessTips:(NSString *)message
{
    [self.view showTips:message autoHide:YES];
}

- (void)cLPresentSuccessTips:(NSString *)message {
    [self.view showpresentSuccessTips:message];
}

- (void)presentFailureTips:(NSString *)message
{
	[self.view showTips:message autoHide:YES];
}

- (void)presentLoadingTips:(NSString *)message
{
	[self.view presentLoadingTips:message];
}

- (void)dismissTips
{
	[self.view dismissTips];
}

@end

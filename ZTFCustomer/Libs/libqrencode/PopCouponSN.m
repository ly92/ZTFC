//
//  PopCouponSN.m
//  WeiTown
//
//  Created by 沿途の风景 on 14-9-10.
//  Copyright (c) 2014年 Hairon. All rights reserved.
//

#import "PopCouponSN.h"
#import "QRCodeGenerator.h"

#define TEXTGRAY UIColorFromRGB(0x848484)   //灰色

@interface PopCouponSN ()
@property (nonatomic,strong) UILabel *tipsLbl;
@property (nonatomic,strong) UIImageView *snImageView;

@end

@implementation PopCouponSN

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithParentController:(UIViewController *)aParentCtrl
{
    if (self=[super init]) {
        
        self.parentCtrl = aParentCtrl;
        
        [self prepareView];
    }
    
    return self;
}

-(void)prepareView
{
    
    if (self.parentCtrl) {
        
        self.frame = self.parentCtrl.view.frame;
//        if (IS_IPHONE_5) {
//            [self fixYForIPhone5:NO addHight:YES];
//        }
        
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.6];
        
        if (_qrView==nil) {
            self.qrView = [[UIView alloc] initWithSize:CGSizeMake(250, 280)];
            _qrView.backgroundColor = [UIColor whiteColor];
            _qrView.center = self.center;
            [self addSubview:_qrView];
            
            //二维码图片
            self.qrImageView = [[UIImageView alloc] initWithFrame:CGRectMake(45, 45, 160, 160)];
            _qrImageView.backgroundColor=[UIColor whiteColor];
            [_qrView addSubview:_qrImageView];
            [self addSubview:_qrView];
            
            
            _tipsLbl = [[UILabel alloc] initWithFrame:CGRectMake(45, 210, 160, 30)];
            _tipsLbl.backgroundColor = [UIColor clearColor];
            _tipsLbl.textColor = TEXTGRAY;
            _tipsLbl.text = @"扫一扫二维码，使用电子优惠券";
            _tipsLbl.textAlignment = NSTextAlignmentCenter;
            _tipsLbl.font = [UIFont systemFontOfSize:11];
            [_qrView addSubview:_tipsLbl];
            
            //优惠码
            _snImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 250, 250, 30)];
            _snImageView.backgroundColor = TEXTGRAY;
            [_qrView addSubview:_snImageView];
            
            self.snLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 210, 30)];
            _snLbl.backgroundColor = [UIColor clearColor];
            _snLbl.textColor = [UIColor blackColor];
            _snLbl.textAlignment = NSTextAlignmentCenter;
            _snLbl.font = [UIFont systemFontOfSize:15];
            [_snImageView addSubview:_snLbl];
        }
        
        [self addTapAction:@selector(hideByClick:) forTarget:self];
        
    }
}

-(void)show:(NSString *)qrCode
{
    if (self.parentCtrl) {
        if ([self.parentCtrl.view.subviews containsObject:self]==NO) {
            
            UIImage *qrImage = [QRCodeGenerator qrImageForString:qrCode imageSize:160];
            
            if (qrImage) {
                _qrImageView.contentMode = UIViewContentModeCenter;
                _qrImageView.image=qrImage;
            }
            
            _snLbl.text = [NSString stringWithFormat:@"电子优惠码  %@",qrCode];
            
            [self.parentCtrl.view addSubview:self];
            
            [self showBubble];
            
        }
    }
}

-(void)showCard:(NSString *)qrCode{
    if (self.parentCtrl) {
        if ([self.parentCtrl.view.subviews containsObject:self]==NO) {
            
            UIImage *qrImage = [QRCodeGenerator qrImageForString:qrCode imageSize:160];
            
            if (qrImage) {
                _qrImageView.contentMode = UIViewContentModeCenter;
                _qrImageView.image=qrImage;
            }
            
            [self.tipsLbl removeFromSuperview];
            [self.snImageView removeFromSuperview];
            self.qrView.height = 250;
            self.qrView.layer.cornerRadius = 10;
            
            [self.parentCtrl.view addSubview:self];
            
            [self showBubble];
            
        }
    }

}

-(void)showQR:(NSString *)qrCode WithSN:(NSString *)sn
{
    if (self.parentCtrl) {
        if ([self.parentCtrl.view.subviews containsObject:self]==NO) {
            
            UIImage *qrImage = [QRCodeGenerator qrImageForString:qrCode imageSize:160];
            
            if (qrImage) {
                _qrImageView.contentMode = UIViewContentModeCenter;
                _qrImageView.image=qrImage;
            }
            
            _snLbl.text = [NSString stringWithFormat:@"电子优惠码  %@",sn];
            
            [self.parentCtrl.view addSubview:self];
            
            [self showBubble];
            
        }
    }
}

-(void)hide
{
    if (self.parentCtrl) {
        //[[AppPlusAppDelegate sharedAppDelegate].leveyTabBarController hidesTabBar:NO animated:YES];
        [self removeFromSuperview];
    }
}

-(void)showBubble
{
    self.qrView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
    
    [UIView animateWithDuration:0.15 animations:^{
        
        self.qrView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
        self.qrView.hidden = NO;
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.15 animations:^{
            
            self.qrView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
            
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.15 animations:^{
                
                self.qrView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
                
            } completion:^(BOOL finished) {
                
                
            }];
            
        }];
        
        
    }];
    
    
    
}

-(void)hideByClick:(id)sender
{
    // NSLog(@"hideByClick");
    [self hide];
}


@end

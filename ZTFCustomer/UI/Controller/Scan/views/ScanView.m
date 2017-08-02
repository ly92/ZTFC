//
//  ScanView.m
//  gaibianjia
//
//  Created by PURPLEPENG on 9/17/15.
//  Copyright (c) 2015 Geek Zoo Studio. All rights reserved.
//

#import "ScanView.h"

@interface ScanView ()
{
    NSTimer *   _timer;
    BOOL        _shouldStop;
    BOOL        _start;
    int			_orderInSkip;
    int			_orderOutSkip;
}

@property (strong, nonatomic) UIImageView *stick;

@end

@implementation ScanView

#pragma mark -

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        UIView *containerView = [[[UINib nibWithNibName:@"ScanView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        CGRect newFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        containerView.frame = newFrame;
        [self addSubview:containerView];
        self.stick = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"b0_scanning"]];
        self.stick.frame = CGRectMake( 0, 0, self.width, 14 );
        [self addSubview:self.stick];
    }
    return self;
}

#pragma mark -

- (void)checkStopped
{
    if ( _shouldStop )
    {
//        INFO( @"scanner shuold stop." );
        _animating = NO;
        [self stopTimer];
    }
}

- (void)stopTimer
{
//    INFO( @"scanner timer stopped ." );
    
    [_timer invalidate];
    _timer = nil;
    
    _start = NO;
    _shouldStop = NO;
}

- (void)reachBottom
{
//    INFO( @"scanner reachBottom: %.2f", _stick.top );
    
    if ( _animating == NO )
    {
        [self stopTimer];
        return;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        
        _stick.layer.transform = CATransform3DMakeRotation(M_PI, 1, 0, 0);
        _stick.top = self.height - 22.f;
        
    } completion:^(BOOL finished) {
        
        if ( finished )
        {
            [UIView beginAnimations:nil context:nil];
            //			[UIView setAnimationBeginsFromCurrentState:YES];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationDuration:2.0f];
            
            _stick.top = 8.f;
            
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(reachTop)];
            [UIView commitAnimations];
        }
    }];
}

- (void)reachTop
{    
    if ( _animating == NO )
    {
        [self stopTimer];
        return;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        
        _stick.layer.transform = CATransform3DMakeRotation( 2 * M_PI, 1, 0, 0);
        _stick.top = 8.0f;
        
    } completion:^(BOOL finished) {
        
        if ( finished )
        {
            [UIView beginAnimations:nil context:nil];
            //			[UIView setAnimationBeginsFromCurrentState:YES];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationDuration:2.0f];
            
            _stick.top = self.height - 22.f;
            
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(reachBottom)];
            
            [UIView commitAnimations];
        }
    }];
}

- (void)startAnimation;
{
    _start = YES;
    _shouldStop = NO;
    _animating = YES;
    
    if ( [_timer isValid] )
        return;
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(reachTop) withObject:nil afterDelay:0.1f];
}

- (void)stopAnimation
{
    if ( _start )
    {
        _shouldStop = YES;
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.0000001f];
        [UIView setAnimationDelegate:nil];
        [UIView setAnimationDidStopSelector:nil];
        
        _stick.top = _stick.top + 0.00001f;
        
        [UIView commitAnimations];
    }
}

@end

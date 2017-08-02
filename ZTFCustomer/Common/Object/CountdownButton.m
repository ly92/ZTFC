//
//  CTButton.m
//  buttonDemo
//
//  Created by Chenyun on 14/11/23.
//  Copyright (c) 2014年 geek-zoo. All rights reserved.
//

#import "CountdownButton.h"

@interface CountdownButton ()
{
	int _count;
	NSTimer * _timer;
	UILabel * _label;
}

@end

@implementation CountdownButton

- (void)awakeFromNib
{
	[super awakeFromNib];

	[self setTitle:@"" forState:UIControlStateDisabled];
	[self setTitle:@"发送验证码" forState:UIControlStateNormal];
	
	_count = 60;

	_label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
	_label.textAlignment = NSTextAlignmentCenter;
	_label.textColor = [UIColor grayColor];
    _label.backgroundColor = [UIColor clearColor];
	_label.font = self.titleLabel.font;
	_label.adjustsFontSizeToFitWidth = YES;
	[self addSubview:_label];
}

#pragma amrk -

- (void)start
{
	self.enabled = NO;

	NSString * time = [NSString stringWithFormat:@"重新发送 ( %d )", _count];

	_label.text = time;

	if ( _timer )
	{
		[_timer invalidate];
		_timer = nil;
	}

	_timer = [NSTimer scheduledTimerWithTimeInterval:1.f
											  target:self
											selector:@selector(updateLabel)
											userInfo:nil
											 repeats:YES];
}

- (void)updateLabel
{
	_count--;
	
	if ( _count < 0 )
	{
		[self stop];
	}
	else
	{
		NSString * time = [NSString stringWithFormat:@"重新发送 ( %d )", _count];
		_label.text = time;
	}
}

- (void)stop
{
	[_timer invalidate];
	_count = 60;

	self.enabled = YES;
	_label.text = @"";
	[self setTitle:@"重新发送" forState:UIControlStateNormal];
}

#pragma mark - 

- (void)dealloc
{
	[self stop];
}

#pragma mark - 

- (void)layoutSubviews
{
	[super layoutSubviews];
	_label.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

@end
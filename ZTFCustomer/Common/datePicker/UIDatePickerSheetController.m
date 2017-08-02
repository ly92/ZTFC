//
//  UIDatePickerSheetController.m
//
//  Created by Kristijan Sedlak on 1/26/11.
//  Copyright 2011 AppStrides. All rights reserved.
//
//  FIX: http://www.llamagraphics.com/developer/using-uidatepicker-landscape-mode
//

#import "UIDatePickerSheetController.h"


@interface UIDatePickerSheetController()

@property (nonatomic, retain) IBOutlet UIDatePicker *datePicker_;
@property (nonatomic, retain) IBOutlet UIToolbar *toolbar_;
@property (nonatomic, retain) UIView *curtainView_;

- (IBAction)selectButtonHandler;
- (IBAction)clearButtonHandler;
- (IBAction)cancelButtonHandler;

@end


@implementation UIDatePickerSheetController

@synthesize delegate;
@synthesize tag;

@synthesize datePicker_;
@synthesize toolbar_;
@synthesize curtainView_;




#pragma mark - Animation delegate

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context 
{
	if ([animationID isEqualToString:@"dismissAnimated"]) 
	{
        [curtainView_ removeFromSuperview];
		[self.view removeFromSuperview];
	}
}


#pragma mark - Delegate callbacks

- (void)invokeDidFinishWithDateDelegateCallback:(NSDate *)date
{
	[self.delegate datePickerSheet:self didFinishWithDate:date];
}

- (void)invokeDidCancelDelegateCallback
{
	[self.delegate datePickerSheetDidCancel:self];
}


#pragma mark - General

- (void)hide
{
	CGRect frame = ((UIViewController *)self.delegate).view.frame;
	frame.origin = CGPointMake(0.0, ((UIViewController *)self.delegate).view.frame.size.height);
	self.view.frame = frame;
	if (curtainView_)
	{
		curtainView_.alpha = 0;
	}
}

- (void)showInViewController:(UIViewController *)parent animated:(BOOL)animated
{
	[self hide];
    [self paintForOrientation:parent.interfaceOrientation];
    
	if (animated)
	{
		[UIView beginAnimations:@"showInView" context:nil];
		[UIView setAnimationDelegate:self];
	}

    [parent.view addSubview:curtainView_];
	[parent.view addSubview:self.view];	
    curtainView_.alpha = 0.6;

	[self paintForOrientation:parent.interfaceOrientation];
	
    if (animated)
	{
		[UIView commitAnimations]; 	
	}
}

- (void)dismissAnimated:(BOOL)animated
{
	[UIView beginAnimations:@"dismissAnimated" context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
	[self hide];
	[UIView commitAnimations];
}

- (void)buildCurtainView
{
	self.curtainView_ = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height)];
    curtainView_.backgroundColor = [UIColor blackColor];
    curtainView_.alpha = 0.0;
}

- (void)updateCurtainViewSize:(UIInterfaceOrientation)orientation 
{
    if (![self isFirstResponder]) 
    {
        return;
    }
    
    CGRect parentFrame = self.view.superview.frame;
	CGRect curtainFrame = curtainView_.frame;
    
    if (UIInterfaceOrientationIsPortrait(orientation)) 
	{
        curtainFrame.size = CGSizeMake(parentFrame.size.width, parentFrame.size.height);
    } 
	else 
	{
        curtainFrame.size = CGSizeMake(parentFrame.size.height, parentFrame.size.width);
    }
	curtainView_.frame = curtainFrame;
}

- (void)updateDatePickerSize:(UIInterfaceOrientation)orientation 
{
	CGRect frame = datePicker_.frame;
    CGRect parentFrame = self.view.superview.frame;
    if (UIInterfaceOrientationIsPortrait(orientation)) 
	{
        frame.size = CGSizeMake(parentFrame.size.width, 216);
    } 
	else 
	{
        frame.size = CGSizeMake(parentFrame.size.height, 162);
    }
	datePicker_.frame = frame;
}

- (void)repositionViewForOrientation:(UIInterfaceOrientation)orientation 
{
    if (![self isFirstResponder]) 
    {
        return;
    }
    
    CGRect parentFrame = self.view.superview.frame;
	CGRect viewFrame = self.view.frame;
    CGRect toolbarFrame = toolbar_.frame;
    CGRect datePickerFrame = datePicker_.frame;
    float contentHeight = datePickerFrame.size.height + toolbarFrame.size.height;

    datePickerFrame.origin.y = 0;
    toolbarFrame.origin.y = datePickerFrame.size.height;
	if (UIInterfaceOrientationIsLandscape(orientation)) 
	{
		viewFrame.origin = CGPointMake(0.0, parentFrame.size.width - contentHeight);
	} 
	else 
	{
		viewFrame.origin = CGPointMake(0.0, parentFrame.size.height - contentHeight);
	}
    
	self.view.frame = viewFrame;
    toolbar_.frame =  toolbarFrame;
    datePicker_.frame = datePickerFrame;
}

- (void)paintForOrientation:(UIInterfaceOrientation)orientation 
{
    [self updateCurtainViewSize:orientation];

	[self updateDatePickerSize:orientation];
	[self repositionViewForOrientation:orientation];
}

- (void)paintForCurrentOrientation 
{
	[self paintForOrientation:[UIApplication sharedApplication].statusBarOrientation];
}

- (BOOL)isFirstResponder
{
    return self.view.superview ? YES : NO;
}

- (void)setDate:(NSDate *)date animated:(BOOL)animated
{
    NSDate *pickerDate = date ? [NSDate dateWithTimeInterval:0 sinceDate:date] : [NSDate date];
    [datePicker_ setDate:pickerDate animated:animated];
}


#pragma mark - Interface handlers

- (IBAction)selectButtonHandler 
{
	[self invokeDidFinishWithDateDelegateCallback:datePicker_.date];
    [self dismissAnimated:YES];
}

- (IBAction)clearButtonHandler 
{
	[self invokeDidFinishWithDateDelegateCallback:nil];
    [self dismissAnimated:YES];
}

- (IBAction)cancelButtonHandler 
{
	[self invokeDidCancelDelegateCallback];
    [self dismissAnimated:YES];
}


#pragma mark - Initialization

- (UIDatePickerSheetController *)initWithDefaultNibName
{
	return [self initWithNibName:@"UIDatePickerSheetDefaultView" bundle:nil];
}


#pragma mark - set date time mode

-(void)setDateTimeMode:(UIDatePickerMode)dateMode
{
    // NSLog(@"setDateTimeMode--------------------------------");
//    if (datePicker_) {
     //   NSLog(@"setDateTimeMode--------------------------------");
        [datePicker_ setDatePickerMode:dateMode];
//    [datePicker_ set]
    
    
    
//    [datePicker_ setLocale: [NSLocale systemLocale]];
    
   
    
    [datePicker_ setMinuteInterval:1];
    
//    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"NL"];
//    [self.datePicker_ setLocale:locale];
//    [locale release];locale=nil;
    
//    }
}

-(void)setMiniumDate:(NSDate *)date
{
    [datePicker_ setMinimumDate:date];
}
-(void)setMaxmunDate:(NSDate *)date{
    [datePicker_ setMaximumDate:date];
}
#pragma mark - Memory management

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    [self buildCurtainView];
	[self paintForOrientation:[UIApplication sharedApplication].statusBarOrientation];
    [self hide];
    
    if (self.dateMode==1) {
        [self setDateTimeMode:UIDatePickerModeDateAndTime];
    }
    
    //btnTimeChooseNormal.png
    //btnTimeChooseHighlighted.png
    [self.selectBtn bgStrechableNormalImageName:nil SelectedImageName:nil HighlightImageName:nil NormalTitle:@"选择" SelectedTitle:nil HighlightTitle:@"选择" StrechaSizeX:10 StrechaSizeY:10 Localize:NO];
    [self.cancelBtn bgStrechableNormalImageName:@"btnTimeChooseNormal.png" SelectedImageName:@"" HighlightImageName:@"btnTimeChooseHighlighted.png" NormalTitle:@"取消" SelectedTitle:nil HighlightTitle:@"取消" StrechaSizeX:10 StrechaSizeY:10 Localize:NO];
    [self.clearBtn bgStrechableNormalImageName:@"btnTimeChooseNormal.png" SelectedImageName:@"" HighlightImageName:@"btnTimeChooseHighlighted.png" NormalTitle:@"清空" SelectedTitle:nil HighlightTitle:@"清空" StrechaSizeX:10 StrechaSizeY:10 Localize:NO];

    
}
-(void)updateViewConstraints{
    self.selectBtnLeading.constant = self.clearBtnLeading.constant = self.cancelBtnLeading.constant = (SCREENWIDTH-78*3)/4.0;
    
    [super updateViewConstraints];
}
- (void)viewDidUnload 
{
    [self setSelectBtn:nil];
    [self setClearBtn:nil];
    [self setCancelBtn:nil];
    [super viewDidUnload];
    
    self.datePicker_ = nil;
    self.toolbar_ = nil;
    self.curtainView_ = nil;
}


@end

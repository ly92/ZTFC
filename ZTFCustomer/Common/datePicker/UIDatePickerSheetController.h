//
//  UIDatePickerSheetController.h
//
//  Created by Kristijan Sedlak on 1/26/11.
//  Copyright 2011 AppStrides. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UIDatePickerSheetController;


@protocol UIDatePickerSheetDelegate

@required
- (void)datePickerSheet:(UIDatePickerSheetController *)datePickerSheet didFinishWithDate:(NSDate *)date;
- (void)datePickerSheetDidCancel:(UIDatePickerSheetController *)datePickerSheet;

@end


@interface UIDatePickerSheetController : UIViewController 
{
//	id <UIDatePickerSheetDelegate> delegate;
	int tag;

	IBOutlet UIDatePicker *datePicker_;
	IBOutlet UIToolbar *toolbar_;
    UIView *curtainView_;
}
@property (retain, nonatomic) IBOutlet UIButton *selectBtn;
@property (retain, nonatomic) IBOutlet UIButton *clearBtn;
@property (retain, nonatomic) IBOutlet UIButton *cancelBtn;

@property (retain, nonatomic) IBOutlet NSLayoutConstraint *selectBtnLeading;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *clearBtnLeading;

@property (retain, nonatomic) IBOutlet NSLayoutConstraint *cancelBtnLeading;

@property (nonatomic, assign) id <UIDatePickerSheetDelegate> delegate;
@property (nonatomic, assign) int tag;
@property (nonatomic, assign) int dateMode;

-(void)setDateTimeMode:(UIDatePickerMode)dateMode;
- (UIDatePickerSheetController *)initWithDefaultNibName;
- (void)dismissAnimated:(BOOL)animated;
- (void)paintForOrientation:(UIInterfaceOrientation)orientation;
- (void)setDate:(NSDate *)date animated:(BOOL)animated;
- (BOOL)isFirstResponder;
- (void)showInViewController:(UIViewController *)parent animated:(BOOL)animated;

-(void)setMiniumDate:(NSDate *)date;
-(void)setMaxmunDate:(NSDate *)date;
@end

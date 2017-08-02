//
//  CLPickerView.m
//  CLPickerViewDemo
//
//  Created by 树坚 on 16/1/3.
//  Copyright © 2016年 ColourLife. All rights reserved.
//

#import "CLPickerView.h"
#import "Masonry.h"

@interface CLPickerView ()
@property (nonatomic, strong)UIPickerView *aPickerView;
@property (nonatomic, strong)id <CLPickerViewDelegate>delegate;

@end

@implementation CLPickerView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
        [self addGestureRecognizer:tap];
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        
        
    }
    return self;
}


-(void)PickerViewDelegate:(id<CLPickerViewDelegate>)delegate Tag:(NSInteger)tag IsShowToobar:(BOOL)toolbar
{
    self.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);

    self.delegate = delegate;
    if (self.aPickerView ==nil) {
        self.aPickerView = [[UIPickerView alloc]init];
//        self.aPickerView.frame = CGRectMake(0, SCREENHEIGHT-216, SCREENHEIGHT, 216);
        [self.aPickerView setBackgroundColor:[UIColor whiteColor]];
        [self.aPickerView setDelegate:self];
        [self.aPickerView setDataSource:self];
        [self.aPickerView setTag:tag];
        [self addSubview:self.aPickerView];
        [self.aPickerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left);
            make.bottom.mas_equalTo(self.mas_bottom);
            make.right.mas_equalTo(self.mas_right);
            make.height.mas_equalTo(@160);
        }];
        if (toolbar) {
//            UIToolbar *toobar= [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 38.0f)];
            UIToolbar *toobar= [[UIToolbar alloc] init];
            toobar.barStyle = UIBarStyleDefault;
            UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
            UIBarButtonItem *doneBarItem    = [[UIBarButtonItem alloc] initWithTitle:@"完成"
                                                                               style:UIBarButtonItemStyleDone target:self action:@selector(tapAction)];
            
            [toobar setItems:[NSArray arrayWithObjects:flexibleSpace,doneBarItem, nil]];
            [self addSubview:toobar];
            
            [toobar mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.mas_left);
                make.bottom.mas_equalTo(self.aPickerView.mas_top);
                make.right.mas_equalTo(self.mas_right);
                make.height.mas_equalTo(@38);
            }];
        }
    }
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self];
}

-(void)seletedDefaultRow:(NSInteger)row InComponent:(NSInteger)component
{
    if (self) {
        [self.aPickerView selectRow:row inComponent:component animated:YES];
    }
}
-(void)removePickerView
{
    [self tapAction];
}

-(void)tapAction
{
    if (self) {
        [self removeFromSuperview];
    }
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [_delegate CLPickerView:pickerView numberOfRowsInComponent:component];
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return [_delegate CLNumberOfComponentsInPickerView:pickerView];
}
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [_delegate CLPickerView:pickerView titleForRow:row forComponent:component];
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [_delegate CLPickerView:pickerView didSelectRow:row inComponent:component];
}

@end

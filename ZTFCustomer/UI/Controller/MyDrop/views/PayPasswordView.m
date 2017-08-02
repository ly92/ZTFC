//
//  PayPasswordView.m
//  colourlife
//
//  Created by liuyadi on 16/1/14.
//  Copyright © 2016年 liuyadi. All rights reserved.
//  支付密码框

#import "PayPasswordView.h"

@interface PayPasswordView ()

@property (weak, nonatomic) IBOutlet UIView *passwordInputView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewTC;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHC;
- (IBAction)confirmPayAction:(id)sender;
- (IBAction)cancelAction:(id)sender;

@property (nonatomic, strong) NSMutableArray * dataSource;
@property (nonatomic, strong) UITextField * mainTextField;

@end

@implementation PayPasswordView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    if (SCREENWIDTH > 375 )
    {
        self.viewTC.constant = -150;
    }
    
    self.frame = [UIScreen mainScreen].bounds;
    
    self.dataSource = [NSMutableArray array];
    
    CGFloat margin = 8;
    CGFloat width = ([UIScreen mainScreen].bounds.size.width - (2 * 45) - 5 * margin) / 6;
    
    self.viewHC.constant = 136 + width;
    
    self.mainTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.passwordInputView.width, width)];
    self.mainTextField.hidden = YES;
    self.mainTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self.mainTextField addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.passwordInputView addSubview:self.mainTextField];
    
    for (int i = 0; i < 6; i++)
    {
        UITextField * textField = [[UITextField alloc] init];
        textField.tag = i;
        textField.enabled = NO;
        textField.secureTextEntry = YES;
        textField.backgroundColor = [UIColor whiteColor];
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.textAlignment = NSTextAlignmentCenter;
        textField.borderStyle = UITextBorderStyleNone;
        textField.layer.borderColor = [AppTheme lineColor].CGColor;
        textField.layer.borderWidth = [AppTheme onePixel];
        textField.frame = CGRectMake(i * (width + margin), 0, width, width);
        [self.passwordInputView addSubview:textField];
        [self.dataSource addObject:textField];
    }

    UIButton * firstButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, (width + margin) * 6, width)];
    [firstButton addTarget:self action:@selector(textFieldBecomeResponder) forControlEvents:UIControlEventTouchUpInside];
    firstButton.backgroundColor = [UIColor clearColor];
    [self.passwordInputView addSubview:firstButton];
    
}

- (void)textFieldBecomeResponder
{
    [self beginInput];
}

- (void)setHidden:(BOOL)hidden
{
    [super setHidden:hidden];
    
    if ( hidden )
    {
        [self.mainTextField resignFirstResponder];
    }
    else
    {
        [self.mainTextField becomeFirstResponder];
        if ( SCREENWIDTH > 375 )
        {
            self.viewTC.constant = -150;
        }
        else
        {
            self.viewTC.constant = -100;
        }
    }
}

#pragma mark 文本框内容改变

- (void)textDidChange:(UITextField *)textField
{
    NSString *password = textField.text;
    
    if ( textField.text.length > 6 )
    {
        textField.text = [textField.text substringToIndex:6];
    }
    
    for (int i = 0; i < self.dataSource.count; i++)
    {
        UITextField *pwdtx = [self.dataSource objectAtIndex:i];
        if (i < password.length)
        {
            NSString *pwd = [password substringWithRange:NSMakeRange(i, 1)];
            pwdtx.text = pwd;
        }
        else
        {
            pwdtx.text = nil;
        }
        
    }
}

// 取消按钮
- (IBAction)cancelAction:(id)sender
{
    [self clear];
    self.hidden = YES;
}

// 确认按钮
- (IBAction)confirmPayAction:(id)sender
{
    if ( self.mainTextField.text.length < 6 )
    {
        return;
    }
    
    if ( self.confirmPay )
    {
        self.confirmPay(self.mainTextField.text);
    }
}

// 清除文本框内的信息
- (void)clear
{
    self.mainTextField.text = @"";
    [self textDidChange:self.mainTextField];
}

// 开始输入
- (void)beginInput
{
    [self.mainTextField becomeFirstResponder];
    if ( SCREENWIDTH > 375 )
    {
        self.viewTC.constant = -150;
    }
    else
    {
        self.viewTC.constant = -100;
    }
}

// 结束输入
- (void)endInput
{
    [self.mainTextField resignFirstResponder];
    self.viewTC.constant = -64;
}

@end

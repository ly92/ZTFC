//
//  presentView.m
//  colourlife
//
//  Created by ly on 16/1/12.
//  Copyright © 2016年 liuyadi. All rights reserved.
//

#import "PresentView.h"

@interface PresentView ()
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *subView;

@property (weak, nonatomic) IBOutlet UITextField *numTF;
@property (nonatomic, assign) int max;
@property (weak, nonatomic) IBOutlet UITextField *amountF;

@property (nonatomic, assign) BOOL isKeyShow;

@end

@implementation PresentView

- (instancetype)initWithMax:(int)max{
    if (self = [super init]){
        self = [[[NSBundle mainBundle] loadNibNamed:@"PresentView" owner:nil options:nil] lastObject];
        self.max = max;
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.view1.layer.cornerRadius = 10;
    self.subView.layer.cornerRadius = 5;
    self.amountF.text = @"1";
    [self.amountF addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self setupKeyboard];
}

- (void)setupKeyboard{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide) name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow) name:UIKeyboardDidShowNotification object:nil];
}
- (void)keyboardHide{
    self.isKeyShow = NO;
}
- (void)keyboardShow{
    self.isKeyShow = YES;
}

- (void)textDidChange:(UITextField *)TF{
    NSInteger count = [self.amountF.text integerValue];
    if (count > self.max){
         [self presentFailureTips:@"不可超过总数"];
        if (TF.text.length == 1){
        TF.text = [NSString stringWithFormat:@"%d",self.max];
        }else{
        TF.text = [TF.text substringToIndex:TF.text.length -1];
        }
    }
}

- (IBAction)plus:(id)sender {
    NSInteger count = [self.amountF.text integerValue];
    if (count < self.max){
        self.amountF.text = [NSString stringWithFormat:@"%ld",count + 1];
    }
}

- (IBAction)minus:(id)sender {
    NSInteger count = [self.amountF.text integerValue];
    if (count > 1){
        self.amountF.text = [NSString stringWithFormat:@"%ld",count - 1];
    }
}

- (IBAction)presentClick:(id)sender {
    [self.amountF resignFirstResponder];
    [self.numTF resignFirstResponder];
    NSInteger count = [self.amountF.text intValue];
    if (count <= 0 || [ISNull isNilOfSender:self.amountF.text]){
         [self presentFailureTips:@"最少选择一张！"];
         return;
    }

    if (!(self.numTF.text.length == 11) || ![self.numTF.text isNumText]){
         [self presentFailureTips:@"请输入11位手机号"];
        return;
    }
    
    if ([self.numTF.text isEqualToString:[LocalData shareInstance].getUserAccount.mobile]){
         [self presentFailureTips:@"不可转赠给自己"];
        self.numTF.text = @"";
        return;
    }
    
    if ([_delegate respondsToSelector:@selector(didClickPresentBtn:Mobile:)]){
        [_delegate didClickPresentBtn:count Mobile:self.numTF.text];
    }
    self.hidden = YES;
}
- (IBAction)bgClick:(UIButton *)btn {
    if (btn.tag == 1 || self.isKeyShow){
        
        [self.amountF resignFirstResponder];
        [self.numTF resignFirstResponder];
        
        return;
    }
    self.hidden = YES;
}

@end

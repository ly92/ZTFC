//
//  RechargeController.m
//  ZTFCustomer
//
//  Created by mac on 16/9/19.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "RechargeController.h"
#import "PayController.h"
#import "CashierViewController.h"

@interface RechargeController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UITextField *moneyTextfield;
@property (nonatomic, strong) NSMutableArray *personListArray;
@property (nonatomic, strong) UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewheight;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

@property (nonatomic, assign) CGFloat topViewHeight;
@property (nonatomic, assign) CGFloat redPrice;
@property (nonatomic, assign) CGFloat priceNum;
@end

@implementation RechargeController

+(instancetype)spawn{
    return [RechargeController loadFromStoryBoard:@"MyDrop"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.confirmButton.backgroundColor = BUTTON_BLUECOLOR;
    [self.confirmButton setTitleColor:BUTTONBLUE_TEXTCOLOR forState:UIControlStateNormal];
    
    [self setNavigationBar];
    
    UIToolbar *toobar= [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 38.0f)];
    toobar.barStyle        = UIBarStyleDefault;
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneBarItem    = [[UIBarButtonItem alloc] initWithTitle:@"完成"
                                                                       style:UIBarButtonItemStyleDone target:self action:@selector(resignKeyboard)];
    
    [toobar setItems:[NSArray arrayWithObjects:flexibleSpace,doneBarItem, nil]];
    _moneyTextfield.inputAccessoryView   = toobar;
    
    _redPrice = 0;
    _priceNum = 0;
    _topViewHeight = 0;
    _personListArray = [NSMutableArray array];
    [self getPercentList];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (![AppDelegate sharedAppDelegate].tabController.tabBarHidden) {
        [[AppDelegate sharedAppDelegate].tabController setTabBarHidden:YES animated:YES];
    }
    
}
#pragma mark-navibar
-(void)setNavigationBar{
    
    self.navigationItem.title = @"充值";
    
    self.navigationItem.leftBarButtonItem = [AppTheme backItemWithHandler:^(id sender) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
}

- (void)resignKeyboard {
    [_moneyTextfield resignFirstResponder];
}
#pragma mark -Request
- (void)getPercentList {
    [self presentLoadingTips:@"正在加载"];
    
    [[BaseNetConfig shareInstance]configGlobalAPI:SIMULATOR];
    GetRechargeListAPI *getRechargeListApi = [[GetRechargeListAPI alloc]init];
    [getRechargeListApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        [self dismissTips];
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
            
            NSArray *list = result[@"list"];
            for (NSDictionary *dic in list) {
                RechargeModel *rechargeModel = [RechargeModel mj_objectWithKeyValues:dic];
                [self.personListArray addObject:rechargeModel];
            }
            
           [self creatView];
        }else{
            [self presentFailureTips:result[@"message"]];
        }

        
        
    } failure:^(__kindof YTKBaseRequest *request) {
        if (request.responseStatusCode == 0) {
            [self presentFailureTips:@"网络不可用，请检查网络链接"];
        }else{
            [self presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
        }
    }];

}

#pragma mark -View
- (void)creatView {
    NSInteger width = 0;
    NSInteger height = 0;
    for (int i = 0; i < [_personListArray count]; i++) {
//        for (int i = 0; i < 5; i++) {
        RechargeModel *listData = [_personListArray objectAtIndex:i];
        
        UIButton *button = [[UIButton alloc] init];
        width = i%3;
        if (i%3 == 0 && i > 0) {
            height++;
            width = 0;
        }
        [button setFrame:CGRectMake(((SCREENWIDTH -24)/3+6)*width, 66*height, (SCREENWIDTH -24)/3, 60)];
        [button.layer setCornerRadius:4];
        [button.layer setMasksToBounds:YES];
        [button setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(0x27AF0)] forState:UIControlStateSelected];
        [button setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(0x27AF0)] forState:UIControlStateHighlighted];
        NSString *value = [NSString stringWithFormat:@"¥%ld",[listData.value integerValue]];
        NSRange valueRange = [value rangeOfString:[NSString stringWithFormat:@"¥"]];
        NSRange Range = [value rangeOfString:[NSString stringWithFormat:@"%ld",[listData.value integerValue]]];
        [button setAttributedTitle:[self makeTheMonthReduceMoneyShowTheOrangeColourWithText:value andRange:valueRange ValueRang:Range Color:[UIColor blackColor] Font:[UIFont systemFontOfSize:12]] forState:UIControlStateNormal];
        [button setAttributedTitle:[self makeTheMonthReduceMoneyShowTheOrangeColourWithText:value andRange:valueRange ValueRang:Range Color:[UIColor whiteColor] Font:[UIFont systemFontOfSize:12]] forState:UIControlStateSelected];
        [button.titleLabel setFont:[UIFont systemFontOfSize:24]];
        [button setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [button setData:listData];
        [button addTarget:self action:@selector(selectMoneyPresson:) forControlEvents:UIControlEventTouchUpInside];
        [_topView addSubview:button];
            
            
        _topViewHeight = button.bottom;
            
    }
    self.topViewheight.constant = 66 * (height+1);

}

//选择金额
- (void)selectMoneyPresson:(UIButton *)button {
    RechargeModel *listData = button.data;
    [self resignKeyboard];
    [_moneyTextfield setText:@""];
    _redPrice = [listData.value floatValue];
    _priceNum = _redPrice;
    [self updataData:listData];
    if (button != _selectBtn) {
        _selectBtn.selected = NO;
        _selectBtn = button;
    }
    _selectBtn.selected = YES;
}

- (void)updataData:(RechargeModel *)listData {
    [self.valueLabel setText:[NSString stringWithFormat:@"¥%.f",[listData.value floatValue]]];
    [self.priceLabel setText:[NSString stringWithFormat:@"可获得饭票%.f元",[listData.price floatValue]]];
    _priceNum = [listData.value floatValue];
    
}


-(NSMutableAttributedString *)makeTheMonthReduceMoneyShowTheOrangeColourWithText:(NSString *)text andRange:(NSRange )range ValueRang:(NSRange )valueRange Color:(UIColor *)color Font:(UIFont *)font{
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:text];
    [attString addAttribute:NSBaselineOffsetAttributeName value:@(6) range:range];
    [attString addAttribute:NSForegroundColorAttributeName value:color range:range];
    [attString addAttribute:NSFontAttributeName value:font range:range];
    [attString addAttribute:NSForegroundColorAttributeName value:color range:valueRange];
    
    return attString;
}

#pragma mark -UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [_selectBtn setSelected:NO];
    if (SCREENHEIGHT <= 568) {
        
    }
    if (SCREENHEIGHT <= 568) {
        if (SCREENHEIGHT <= 480) {
            [UIView animateWithDuration:0.3 animations:^{
                [self.view setTop:self.view.top - 105];
            }];
        } else {
            [UIView animateWithDuration:0.3 animations:^{
                [self.view setTop:self.view.top - 50];
            }];
        }
    }
    
    _redPrice = 0;
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (SCREENHEIGHT <= 568) {
        if (SCREENHEIGHT <= 480) {
            [UIView animateWithDuration:0.3 animations:^{
                [self.view setTop:self.view.top + 105];
            }];
        } else {
            [UIView animateWithDuration:0.3 animations:^{
                [self.view setTop:self.view.top + 50];
            }];
        }
        
    }
    if ([textField.text length] == 0) {
        [_selectBtn setSelected:YES];
        _redPrice = _priceNum;
    } else {
        if ([textField.text integerValue] >5000) {
            [self presentFailureTips:@"充值金额不能大于5000元"];
        } else {
//            [self presentLoadingTips:@"正在加载"];
//            NSInteger val = [textField.text integerValue];
            RechargeModel *rechargeModel = [[RechargeModel alloc]init];
            rechargeModel.price = textField.text;
            rechargeModel.value = textField.text;
//            [textField setText:@""];
            [self updataData:rechargeModel];
            
            
//            [MealTicketModel getPercentListVal:[NSNumber numberWithInteger:val] Type:[NSNumber numberWithInteger:1] Then:^(VER_REDPACKETFEES_PERCENTLIST_POST_RESPONSE *response, STIHTTPResponseError *e) {
//                [self dismissTips];
//                if (response) {
//                    //请求成功
//                    [textField setText:@""];
//                    [self updataData:response.list[0]];
//                }
//                
//            }];
        }
    }
    
    return YES;
}

#pragma mark-click

- (IBAction)confirmPre:(id)sender {
 
    if (_priceNum == 0) {
        [self presentFailureTips:@"请选择或输入充值金额"];
        return;
    }
    [self presentLoadingTips:nil];
    [[BaseNetConfig shareInstance]configGlobalAPI:KAKATOOL];
    CreateOrderAPI *createOrderApi = [[CreateOrderAPI alloc]initWithBid:@"10000230" money:[NSString stringWithFormat:@"%.2f",_priceNum] callBack:@"" content:@"test" extype:@"5"];
    [createOrderApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        [self dismissTips];
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
            
            PayController * cashier = [PayController spawn];
            cashier.tnum = result[@"tnum"];
            @weakify(cashier)
            cashier.paySuccess = ^(NSString *payCallback){
                @strongify(cashier)
//                [cashier.navigationController popToViewController:self animated:NO];
                //        [self.webView removeFromSuperview];
                
                
                UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
                
                NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",payCallback]]];
                cashier.navigationItem.title = @"支付结果";
                
                [webView loadRequest:request];
                [cashier.view addSubview:webView];
            };

            [self.navigationController pushViewController:cashier animated:YES];
        }else{
            [self presentFailureTips:result[@"reason"]];
        }
    } failure:^(__kindof YTKBaseRequest *request) {
        if (request.responseStatusCode == 0) {
            [self presentFailureTips:@"网络不可用，请检查网络链接"];
        }else{
            [self presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
        }
    }];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

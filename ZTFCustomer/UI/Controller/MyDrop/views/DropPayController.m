//
//  DropPayController.m
//  ZTFCustomer
//
//  Created by mac on 2017/3/16.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "DropPayController.h"
#import "SettingPasswordController.h"
#import "ForgetPayPwdViewController.h"
#import "PayPasswordView.h"
#import "EntranceGuardController.h"

@interface DropPayController ()<UITextFieldDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *sv;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerHeight;

@property (weak, nonatomic) IBOutlet UILabel *shopNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *shopDiscountLbl;
@property (weak, nonatomic) IBOutlet UITextField *moneyInout;
@property (weak, nonatomic) IBOutlet UILabel *actualMoneyLbl;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;

@property (weak, nonatomic) IBOutlet UIView *emptyView;
@property (weak, nonatomic) IBOutlet UILabel *emptyLbl;


@property (nonatomic, strong) DropPayBizInfoModel *bizinfoModel;
@property (nonatomic, strong) NSMutableArray *galleryArray;
@property (nonatomic, copy) NSString *pano;
@property (nonatomic, copy) NSString *atid;
@property (nonatomic, copy) NSString *discount;

@property (nonatomic, strong) PayPasswordView * passwordView;

@end

@implementation DropPayController

+(instancetype)spawn{
    return [self loadFromStoryBoard:@"MyDrop"];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.payBtn.backgroundColor = BUTTON_BLUECOLOR;
    [self.payBtn setTitleColor:BUTTONBLUE_TEXTCOLOR forState:UIControlStateNormal];
    self.payBtn.layer.cornerRadius = 5;
    
    [self setNavigation];
    [self listenToKeyboard];
    [self setToolbar];
    
    [self setupPasswordView];
    
    [self loadShopInfoAndPayGallery];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)setNavigation{
    self.navigationItem.title = @"铁豆支付";
    self.navigationItem.leftBarButtonItem = [AppTheme backItemWithHandler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
}


-(NSMutableArray *)galleryArray{
    if (!_galleryArray) {
        _galleryArray = [NSMutableArray array];
    }
    return _galleryArray;
}

#pragma mark - settoolBar
-(void)setToolbar{
    //添加toobar
    UIToolbar *toobar= [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 38.0f)];
    toobar.barStyle        = UIBarStyleDefault;
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneBarItem    = [[UIBarButtonItem alloc] initWithTitle:@"完成"
                                                                       style:UIBarButtonItemStyleDone target:self action:@selector(resignKeyboard)];
    
    [toobar setItems:[NSArray arrayWithObjects:flexibleSpace,doneBarItem, nil]];
    self.moneyInout.inputAccessoryView   = toobar;
    
}
-(void)resignKeyboard{
    [self.view endEditing:YES];
}


- (void)setupPasswordView
{
    if ( self.passwordView == nil )
    {
        PayPasswordView * passView = [PayPasswordView loadFromNib];
        
        @weakify(self);
        @weakify(passView);
        passView.confirmPay = ^(NSString * password) {
            @strongify(self);
            @strongify(passView);
            [passView endInput];
            
            NSString *bid = self.bid;
            NSString *amount = self.moneyInout.text;
            NSString *pano = self.pano;
            NSString *atid = self.atid;
            
            [[BaseNetConfig shareInstance]configGlobalAPI:ICE];
            [self presentLoadingTips:nil];
            
            DropPayAPI *dropPayApi = [[DropPayAPI alloc]initWithBid:bid amount:amount password:password pano:pano atid:atid];
            
            [dropPayApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                [self dismissTips];
                NSDictionary *result = (NSDictionary *)request.responseJSONObject;
                NSLog(@"%@",result);
                NSDictionary *content = result[@"content"];
                if (![ISNull isNilOfSender:content] && [result[@"code"] intValue] == 0) {
                    [self fk_postNotification:@"GIVENSUCCESS"];
                    [[UIApplication sharedApplication].keyWindow.rootViewController presentSuccessTips:@"支付成功"];
                    
                    passView.hidden = YES;
                    
                    for (UIViewController *tempvc in self.navigationController.viewControllers) {
                        if ([tempvc isKindOfClass:[EntranceGuardController class]]) {
                            [self.navigationController popToViewController:tempvc animated:YES];
                            return ;
                        }
                        
                    }
                    [self.navigationController popToRootViewControllerAnimated:YES];

                    
                }else{
                    NSString *str = result[@"message"];
                    
                    if ([str isEqualToString:@"无效的支付密码"]) {
                        passView.hidden = NO;
                        [passView clear];
                        [passView beginInput];
                    }else{
                        passView.hidden = YES;
                    }
                    
                    [self presentFailureTips:result[@"message"]];

                }
            } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                [self presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
            }];
            
        };
        passView.hidden = YES;
        [self.view addSubview:passView];
        self.passwordView = passView;
    }
}


//获取商户信息和支付通道

-(void)loadShopInfoAndPayGallery{
    
    if (!self.bid) {
        return;
    }
    
    [[BaseNetConfig shareInstance]configGlobalAPI:ICE];
    [self presentLoadingTips:nil];
    
    GetPayGalleryAPI *getPayGallertApi = [[GetPayGalleryAPI alloc]initWithBid:self.bid];
    [getPayGallertApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self dismissTips];
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        NSLog(@"%@",result);
        NSDictionary *content = result[@"content"];
        if (![ISNull isNilOfSender:content] && [result[@"code"] intValue] == 0) {
            
            NSDictionary *dic = content[@"bizinfo"];
            NSArray *list = content[@"list"];
            
            if (![ISNull isNilOfSender:dic]) {
                self.bizinfoModel = [DropPayBizInfoModel mj_objectWithKeyValues:dic];
                
            }else{
                self.emptyView.hidden = NO;
                self.sv.hidden = YES;
            }
            
            if (![ISNull isNilOfSender:list]) {
                
                for (NSDictionary *dic in list) {
                    [self.galleryArray addObject:[DropPayGalleryModel mj_objectWithKeyValues:dic]];
                }
                
            }else{
                [self presentFailureTips:@"商户不支持铁豆支付"];
                self.emptyView.hidden = NO;
                self.sv.hidden = YES;
            }
            
            [self prepareData];
            
        }else{
            self.emptyView.hidden = NO;
            self.sv.hidden = YES;
            [self presentFailureTips:result[@"message"]];
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        self.emptyView.hidden = NO;
        self.sv.hidden = YES;
        [self presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
    }];
    
}

-(void)prepareData{
    
    self.shopNameLbl.text = self.bizinfoModel.name;
    
    if (self.galleryArray.count > 0) {
        DropPayGalleryModel *dropPayModel = self.galleryArray[0];
        if ([dropPayModel.discount floatValue]>=100 || [dropPayModel.discount floatValue] ==0 ) {
             self.shopDiscountLbl.text = @"商户折扣：无折扣";
        }else{
            
            NSString *str = [NSString stringWithFormat:@"%.2f",[dropPayModel.discount floatValue]/10];
            
            self.shopDiscountLbl.text =  [NSString stringWithFormat:@"商户折扣：%@折",[self getyouxiaoWithNumber:str]];
        }
    
        self.pano = dropPayModel.pano;
        self.atid = dropPayModel.atid;
        self.discount = dropPayModel.discount;
        
    }
    
    self.containerHeight.constant = 380;
    
}

#pragma mark - click
- (IBAction)payClick:(id)sender {
    
    [self.moneyInout resignFirstResponder];
    if ([self.moneyInout.text length] == 0 || [self.moneyInout.text isEqualToString:@"0"]) {
        [self presentFailureTips:@"请输入支付金额"];
        return;
    }
    [self getIsSetPwd];
}


#pragma mark -Request
- (void)getIsSetPwd {
    
    [self presentLoadingTips:nil];
    [[BaseNetConfig shareInstance]configGlobalAPI:ICE];
    GetDropAPI *existPasswordApi = [[GetDropAPI alloc]init];
    existPasswordApi.dropType = ExistPasswordType;
    [existPasswordApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        [self dismissTips];
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        NSDictionary *content = result[@"content"];
        
        if (![ISNull isNilOfSender:content] && [result[@"code"] intValue] == 0) {
            
            NSNumber *state = content[@"exist"];
            if ( [state isEqualToNumber:@(1)] )
            {
                self.passwordView.hidden = NO;
            }
            else if ( [state isEqualToNumber:@(0)] )
            {
                
                // 忘记密码
                ForgetPayPwdViewController *forgetPayPwd = [ForgetPayPwdViewController spawn];
                forgetPayPwd.popViewController = self;
                forgetPayPwd.bindType = BIND_USER_TYPE_BIND;
                [self.navigationController pushViewController:forgetPayPwd animated:YES];
                
            }
            else if ( [state isEqualToNumber:@(2)] )
            {
                SettingPasswordController * passwordVC = [SettingPasswordController spawn];
                passwordVC.popViewController = self;
                passwordVC.settingType = SETTING_PASSWORD_TYPE_NEW;
                passwordVC.passwordType = PASSWORD_TYPE_SET;
                [self.navigationController pushViewController:passwordVC animated:YES];
            }
            
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
#pragma mark - textfield Delegate

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.moneyInout) {
        NSMutableString *keywords = [NSMutableString stringWithString:textField.text];
        [keywords replaceCharactersInRange:range withString:string];
        
        if ([keywords trim].length==0) {
            
            self.actualMoneyLbl.text = @"0元";
        }
        else if ([keywords trim].length <= 14)
        {
            
            NSString *str = [NSString stringWithFormat:@"%.2f",[keywords floatValue]*[self.discount floatValue]/100];
            
            self.actualMoneyLbl.text =  [NSString stringWithFormat:@"%@元",[self getyouxiaoWithNumber:str]];
        }
        
        else
        {
            [self presentFailureTips:@"金额过大"];
            return NO;
        }
    }
    return YES;
    
}

//保留两位有效数字
-(NSString *)getyouxiaoWithNumber:(NSString *)number{
    
    NSString *str = nil;
    
    if ([number containsString:@"."]) {
        
        NSArray *arr = [number componentsSeparatedByString:@"."];
        
        if (arr.count > 1 ) {
            
            if ( [arr[1] hasPrefix:@"00"]) {
                return arr[0];
            }else{
                if([arr[1] hasSuffix:@"0"]){
                    str = [NSString stringWithFormat:@"%.1f",[number floatValue]];
                    return str;
                }
            }
            
        }
        
    }
    
    return number;
    
}



-(void)listenToKeyboard
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    [nc addObserver:self selector:@selector(keyboardWillShow:) name:
     UIKeyboardWillShowNotification object:nil];
    
    [nc addObserver:self selector:@selector(keyboardWillHide:) name:
     UIKeyboardWillHideNotification object:nil];
}

-(void)keyboardWillShow:(NSNotification *)note {
    
    NSDictionary* userInfo = [note userInfo];
    
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    
    CGRect keyboardEndFrame;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    CGRect keyboardFrame = [self.view convertRect:keyboardEndFrame toView:nil];
    
    self.sv.contentInset = UIEdgeInsetsMake(0,0,keyboardFrame.size.height,0);
    
}

-(void)keyboardWillHide:(NSNotification *)note
{
    self.sv.contentInset = UIEdgeInsetsMake(0,0,0,0);
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

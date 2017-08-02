//
//  HouseBookController.m
//  ztfCustomer
//
//  Created by mac on 16/9/14.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "HouseBookController.h"
#import "MyBookRootController.h"
#import "UIDatePickerSheetController.h"
#import "SelectPropertyController.h"
@interface HouseBookController ()<UIAlertViewDelegate,UIDatePickerSheetDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *sv;
@property (weak, nonatomic) IBOutlet UITextField *timeTF;
//@property (weak, nonatomic) IBOutlet UITextView *commentT;
@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *commentT;

@property (weak, nonatomic) IBOutlet UITextField *selectPropertyTextField;
@property (weak, nonatomic) IBOutlet UIButton *selectPropertyBtn;
@property (weak, nonatomic) IBOutlet UIButton *selectPropertyRightBtn;


@property (weak, nonatomic) IBOutlet UITextField *houseTextField;

@property (weak, nonatomic) IBOutlet UIButton *subscribeBtn;
@property (weak, nonatomic) IBOutlet UIButton *byPhoneBtn;

@property (nonatomic, strong) UIButton * bgButton;

@property (nonatomic, strong) NSURL *callUrl;

@property (retain, nonatomic)UIDatePickerSheetController *datePicker;

@property (nonatomic, strong) PropertyConstrulantModel *propertyConstrulantModel;
@end

@implementation HouseBookController

+(instancetype)spawn{
    return [HouseBookController loadFromStoryBoard:@"Houses"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.subscribeBtn.backgroundColor = BUTTON_BLUECOLOR;
    [self.subscribeBtn setTitleColor:BUTTONBLUE_TEXTCOLOR forState:UIControlStateNormal];
    
    self.byPhoneBtn.backgroundColor = BUTTON_BLACKCOLOR;
    [self.byPhoneBtn setTitleColor:BUTTONBLACK_TEXTCOLOR forState:UIControlStateNormal];
    
    //适配ios7
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)){
        self.navigationController.navigationBar.translucent = NO;
    }
    
    [self setNavigationBar];
    [self listenToKeyboard];
    self.subscribeBtn.layer.cornerRadius = 4;
    self.byPhoneBtn.layer.cornerRadius = 4;
    
    self.commentT.placeholder = @"请输入备注";
    self.houseTextField.text = self.houseModel.name;
    
    //添加toobar
    UIToolbar *toobar= [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 38.0f)];
    toobar.barStyle        = UIBarStyleDefault;
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneBarItem    = [[UIBarButtonItem alloc] initWithTitle:@"完成"
                                                                       style:UIBarButtonItemStyleDone target:self action:@selector(resignKeyboard)];
    
    [toobar setItems:[NSArray arrayWithObjects:flexibleSpace,doneBarItem, nil]];
    self.commentT.inputAccessoryView   = toobar;
    
    [self loadPropertyConsultane];
    
    [self fk_observeNotifcation:@"SELECTCUSSESS" usingBlock:^(NSNotification *note) {
        
        self.propertyConstrulantModel = (PropertyConstrulantModel *)note.object;
        
        self.selectPropertyTextField.text = self.propertyConstrulantModel.name;
        
        
        
    }];
    
}
-(void)resignKeyboard{
    [self.timeTF resignFirstResponder];
    [self.commentT resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setNavigationBar{
    
    self.navigationItem.title = @"预约看房";
    
    self.navigationItem.leftBarButtonItem = [AppTheme backItemWithHandler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    self.navigationItem.rightBarButtonItem = [AppTheme itemWithContent:@"历史记录" handler:^(id sender) {
        [_datePicker dismissAnimated:YES];
        [self historyRecord];
    }];
}


-(void)historyRecord{
    
    MyBookRootController *myBook = [MyBookRootController spawn];
    
    myBook.bid = self.houseModel.project_id;
    
    [self.navigationController pushViewController:myBook animated:YES];
    
    
}

#pragma mark - request
-(void)loadPropertyConsultane{
    [self presentLoadingTips:nil];
    [[BaseNetConfig shareInstance]configGlobalAPI:ICE];
//    UserModel *userModel = [[LocalData shareInstance]getUserAccount];
//    Community *community = [STICache.global objectForKey:[NSString stringWithFormat:@"%@_crcc",userModel.mobile]];
    
    PropertyConstulantAPI *propertyConstulantApi = [[PropertyConstulantAPI alloc]initWithProjectId:self.houseModel.project_id communityId:@"" key:@"" skip:@"0" limit:@"10000"];
    propertyConstulantApi.propertyType = ISBINDPROPERTY;
    [propertyConstulantApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        [self dismissTips];
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        NSDictionary *content = result[@"content"];
        if (![ISNull isNilOfSender:result] && [result[@"code"] intValue] == 0) {
            
            NSArray *arr = content[@"employee"];
            if (arr.count > 0) {
                NSDictionary *dic = arr[0];
                self.propertyConstrulantModel = [PropertyConstrulantModel mj_objectWithKeyValues:dic];                
            }
            
            if (self.propertyConstrulantModel) {
                self.selectPropertyBtn.userInteractionEnabled = NO;
                self.selectPropertyTextField.text = self.propertyConstrulantModel.name;
                self.selectPropertyRightBtn.hidden = YES;
            }else{
                self.selectPropertyRightBtn.hidden = NO;
                self.selectPropertyBtn.userInteractionEnabled = YES;
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


#pragma mark - click

//选择时间
- (IBAction)chooseTime:(id)sender {
    [self.view endEditing:YES];
    [self showDatePicker];
}

- (IBAction)selectPropertyClick:(id)sender {

    SelectPropertyController *selectProperty = [SelectPropertyController spawn];
    selectProperty.houseModel = self.houseModel;
    [self.navigationController pushViewController:selectProperty animated:YES];
}



#pragma mark - 时间选择
-(void)showDatePicker{
    [self.view endEditing:YES];
    if (_datePicker==nil) {
        _datePicker = [[UIDatePickerSheetController alloc] initWithDefaultNibName];
        _datePicker.dateMode=1;
        _datePicker.delegate = self;
    }
    [_datePicker setDate:[NSDate date]  animated:NO];
    [_datePicker showInViewController:self animated:YES];
    [_datePicker setMiniumDate:[NSDate date]];
    
}

- (void)datePickerSheet:(UIDatePickerSheetController *)datePickerSheet didFinishWithDate:(NSDate *)date
{
    
    NSDate * currentDate = date;
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString * timeStr = [formatter stringFromDate:currentDate];
    
    self.timeTF.text = timeStr;
    self.timeTF.textColor = [AppTheme titleColor];
    
}
- (void)datePickerSheetDidCancel:(UIDatePickerSheetController *)datePickerSheet
{
    
}
- (IBAction)subscribeBtnClick:(id)sender {
    
    [self.view endEditing:YES];
    
    
    NSString *dateStr = self.timeTF.text;
    NSString *content = self.commentT.text.length > 0?self.commentT.text:@"";
    
    NSLog(@"dateStr = %@",dateStr);
    if ([ISNull isNilOfSender:dateStr]) {
        [self presentFailureTips:@"请选择预约时间"];
        return;
    }
    
//    if ([ISNull isNilOfSender:content]) {
//        [self presentFailureTips:@"请输入预约备注"];
//        return;
//    }
    
    NSString *now = [[NSDate date] stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
    if ([now compare:dateStr] == NSOrderedDescending) {
        [self presentFailureTips:@"预约时间过期，请重新填写时间"];
        return;
    }
    
    NSString *employeeId = self.propertyConstrulantModel.id;
    if (employeeId.length == 0) {
        employeeId = @"";
    }
    
    
    [self presentLoadingTips:nil];
    [[BaseNetConfig shareInstance]configGlobalAPI:ICE];
    HouseBookAPI *houseBookApi = [[HouseBookAPI alloc]initWithEmployyId:employeeId PojectId:self.houseModel.project_id appointmenttime:dateStr memo:content];
    [houseBookApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        [self dismissTips];
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        if (![ISNull isNilOfSender:result] && [result[@"code"] intValue] == 0) {
            
            [[UIApplication sharedApplication].keyWindow.rootViewController presentSuccessTips:@"预约成功"];
            [self.navigationController popViewControllerAnimated:YES];
            
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


- (IBAction)subscribeByPhone:(id)sender {
    
    [self.view endEditing:YES];
    
    if (self.houseModel.tel != nil && [self.houseModel.tel trim].length>0) {
        
        if ([self.houseModel.tel containsString:@"-"]) {
            self.houseModel.tel = [self.houseModel.tel stringByReplacingOccurrencesOfString:@"-" withString:@""];
        }
        self.houseModel.tel = [self.houseModel.tel trim];
        
        NSString *realnum = [NSString stringWithFormat:@"tel://%@",self.houseModel.tel];
        self.callUrl=[NSURL URLWithString:realnum];
        
        
        [UIAlertView bk_showAlertViewWithTitle:@"拨打电话" message:self.houseModel.tel cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                if ([[UIApplication sharedApplication] openURL:self.callUrl]) {
                    [[UIApplication sharedApplication] openURL:self.callUrl];
                }
                else
                {
                    [self presentFailureTips:@"此设备无法拨打电话"];
                }

            }
        }];
        
        
    }
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

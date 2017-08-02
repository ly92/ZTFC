//
//  MyBookDetailController.m
//  ZTFCustomer
//
//  Created by mac on 16/9/19.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "MyBookDetailController.h"

@interface MyBookDetailController ()
@property (weak, nonatomic) IBOutlet UILabel *communityNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *employeeNameLbl;

@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UILabel *memoLbl;


@property (weak, nonatomic) IBOutlet UIView *memoView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *memoViewheight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *memoLblHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *stateL;

@property (weak, nonatomic) IBOutlet UIButton *cancelbtn;
@property (weak, nonatomic) IBOutlet UIButton *completebtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewBottom;


@end

@implementation MyBookDetailController

+(instancetype)spawn{
    return [MyBookDetailController loadFromStoryBoard:@"PersonalCenter"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.cancelbtn.backgroundColor = BUTTON_BLACKCOLOR;
    [self.cancelbtn setTitleColor:BUTTONBLACK_TEXTCOLOR forState:UIControlStateNormal];
    
    self.completebtn.backgroundColor = BUTTON_BLUECOLOR;
    [self.completebtn setTitleColor:BUTTONBLUE_TEXTCOLOR forState:UIControlStateNormal];
    
    //适配ios7
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)){
        self.navigationController.navigationBar.translucent = NO;
    }
    
    self.navigationItem.title = @"预约详情";
    self.navigationItem.leftBarButtonItem = [AppTheme backItemWithHandler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    
    [self prepareData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - prepareData
-(void)prepareData{
    
    NSInteger status = [self.appointmentModel.status integerValue];
    if (status == 1 || status == 2) {
        //取消和完成按钮显示
        //已提交，已确认的状体啊
        self.completebtn.hidden = NO;
        self.cancelbtn.hidden = NO;
        self.scrollViewBottom.constant = 40;
    }else{
        //取消和完成按钮隐藏
        //已完成和已取消的状态
        self.completebtn.hidden = YES;
        self.cancelbtn.hidden = YES;
        self.scrollViewBottom.constant = 0;
    }
    
    
    switch (status) {
        case 1:
            //未确认
            self.stateL.text = @"未确认";
            break;
        case 2:
            //已确认
            self.stateL.text = @"已确认";
            break;
            
        case 3:
            //已完成
            self.stateL.text = @"已完成";
            break;
        case 4:
            //已取消
            self.stateL.text = @"已取消";
            break;
            
        default:
            //未确认
            self.stateL.text = @"未确认";
            break;
    }
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[self.appointmentModel.order_time longLongValue]];
    self.timeL.text = [date stringWithFormat:@"yyyy-MM-dd HH:mm"];
    
    self.communityNameLbl.text = self.appointmentModel.project.name;
    self.employeeNameLbl.text = self.appointmentModel.employee.name;
    
    self.memoLbl.text = self.appointmentModel.content;
    if (self.memoLbl.text.length == 0) {
        self.memoView.hidden = YES;
        self.memoLblHeight.constant =0;
        self.memoViewheight.constant = 0;
        self.containerViewHeight.constant = 400-89 +self.memoViewheight.constant;
    }else{
        self.memoView.hidden = NO;
        self.memoLbl.width = SCREENWIDTH-20;
        self.memoLblHeight.constant = [self.memoLbl resizeHeight]> 20?[self.memoLbl resizeHeight]:20;
        self.memoViewheight.constant = 89-20 + self.memoLblHeight.constant;
        self.containerViewHeight.constant = 400-89 +self.memoViewheight.constant;
    }
}

#pragma mark - click

- (IBAction)completeClick:(id)sender {
    //完成预约
    [UIAlertView bk_showAlertViewWithTitle:@"是否要完成该预约" message:nil cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex ==1) {
            OperateBookAPI *completeBookApi = [[OperateBookAPI alloc]initWithBookId:self.appointmentModel.id projectId:self.appointmentModel.project_id];
            completeBookApi.operateBookType = completeBookType;
            [completeBookApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                NSDictionary *result = (NSDictionary *)request.responseJSONObject;
                NSLog(@"%@",result);
                NSDictionary *content = result[@"content"];
                if (![ISNull isNilOfSender:content] && [result[@"code"] intValue] == 0) {
                     [[UIApplication sharedApplication].keyWindow.rootViewController presentSuccessTips:@"完成预约成功"];
                    self.appointmentModel.status = @"3";
                    [self fk_postNotification:@"OPERATEBOOKSUCCESS" object:self.appointmentModel];
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }else{
                    [self presentFailureTips:result[@"message"]];
                }
            } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                [self presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
            }];

        }
    }];
   
}

- (IBAction)cancelClick:(id)sender {
    [UIAlertView bk_showAlertViewWithTitle:@"是否要取消该预约" message:nil cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex ==1) {
            //取消预约
            OperateBookAPI *cancelBookApi = [[OperateBookAPI alloc]initWithBookId:self.appointmentModel.id projectId:self.appointmentModel.project_id];
            cancelBookApi.operateBookType = cancelBookType;
            [cancelBookApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                NSDictionary *result = (NSDictionary *)request.responseJSONObject;
                NSLog(@"%@",result);
                NSDictionary *content = result[@"content"];
                if (![ISNull isNilOfSender:content] && [result[@"code"] intValue] == 0) {
                    [[UIApplication sharedApplication].keyWindow.rootViewController presentSuccessTips:@"取消预约成功"];
                    self.appointmentModel.status = @"4";
                    [self fk_postNotification:@"OPERATEBOOKSUCCESS" object:self.appointmentModel];
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }else{
                    [self presentFailureTips:result[@"message"]];
                }
            } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                [self presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
            }];

        }
    }];
   }


@end

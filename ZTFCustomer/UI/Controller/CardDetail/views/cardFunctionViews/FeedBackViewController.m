//
//  FeedBackViewController.m
//  colourlife
//
//  Created by ly on 16/1/14.
//  Copyright © 2016年 liuyadi. All rights reserved.
//

#import "FeedBackViewController.h"
#import "FeedBackTableViewController.h"
#import "FeedbackAPI.h"
#import "TextView.h"

@interface FeedBackViewController ()

@property (nonatomic, copy) NSString *bid;
@property (weak, nonatomic) IBOutlet TextView *feedbackText;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;

@end

@implementation FeedBackViewController

- (instancetype)initWithBid:(NSString *)bid{
    if (self = [super init]){
        self.bid = bid;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //适配ios7
    self.view.backgroundColor = VIEW_BG_COLOR;
    
    self.sendBtn.backgroundColor = BUTTON_BLUECOLOR;
    [self.sendBtn setTitleColor:BUTTONBLUE_TEXTCOLOR forState:UIControlStateNormal];
    self.sendBtn.layer.cornerRadius = 5;
    
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)){
        self.navigationController.navigationBar.translucent = NO;
    }
    
    self.navigationItem.title = @"反馈";
    self.navigationItem.leftBarButtonItem = [AppTheme backItemWithHandler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    self.navigationItem.rightBarButtonItem = [AppTheme itemWithContent:@"历史记录" handler:^(id sender) {
        
        [self historyFeedback];
    }];
    
    self.feedbackText.placehoder = @"欢迎您对本店进行意见反馈";
}
- (IBAction)sureFeedBack:(id)sender {
    [self.feedbackText endEditing:YES];
    
    NSString *content = self.feedbackText.text;
    
    if (content&&[content trim].length==0) {
         [self presentFailureTips:@"请填写内容"];
        return;
    }
    
    //新增意见反馈
    
    //TODO:提交数据
    [self presentLoadingTips:nil];
    [[BaseNetConfig shareInstance] configGlobalAPI:KAKATOOL];
    FeedbackAPI *feedbackApi = [[FeedbackAPI alloc] initWithBid:self.bid Content:content Contact:[[LocalData shareInstance] getUserAccount].mobile];
    [feedbackApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        [self dismissTips];
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
            [self presentSuccessTips:@"提交成功！"];
             self.feedbackText.text = @"";
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

- (void)historyFeedback{
    FeedBackTableViewController *history = [[FeedBackTableViewController alloc] initWithBid:self.bid];
    [self.navigationController pushViewController:history animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

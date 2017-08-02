//
//  SubscribeDetailViewController.m
//  colourlife
//
//  Created by ly on 16/1/18.
//  Copyright © 2016年 liuyadi. All rights reserved.
//

#import "SubscribeDetailViewController.h"
#import "SubscribeListModel.h"

@interface SubscribeDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UILabel *stateL;
@property (weak, nonatomic) IBOutlet UITextView *contentText;

@property (strong, nonatomic) SubscribeRecordModel *subscribe;//

@end

@implementation SubscribeDetailViewController


- (instancetype)initWithSubscribe:(SubscribeRecordModel *)subscribe{
    if (self = [super init]){
        self.subscribe = subscribe;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //适配ios7
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)){
        self.navigationController.navigationBar.translucent = NO;
    }
    
    self.navigationItem.title = @"预约详情";
    self.navigationItem.leftBarButtonItem = [AppTheme backItemWithHandler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];

    
    [self loadData];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (![AppDelegate sharedAppDelegate].tabController.tabBarHidden) {
        [[AppDelegate sharedAppDelegate].tabController setTabBarHidden:YES animated:YES];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadData{
    if (self.subscribe) {
        [self prepareData];
    }else{
        [self loadBookDetailRequest];
    }
    
}

-(void)loadBookDetailRequest{
    
    
    [self presentLoadingTips:nil];
    [[BaseNetConfig shareInstance] configGlobalAPI:WETOWN];
    
    AppointmentDetailAPI *feedBackDetailApi = [[AppointmentDetailAPI alloc]initWithAid:self.relatedId];
    [feedBackDetailApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self dismissTips];
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
            
            self.subscribe = [SubscribeRecordModel mj_objectWithKeyValues:[result objectForKey:@"info"]];
            [self prepareData];
            
            
        }else{
            [self presentFailureTips:result[@"message"]];
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
    }];
    
}


-(void)prepareData{
    
    
    self.timeL.text = [NSDate timeChargeToCustomDate:self.subscribe.booktime dateFormat:@"yyyy-MM-dd HH:mm"];
    
    //    self.timeL.text = [NSDate longlongToDayDateTime:self.subscribe.booktime];
    
    int status= [self.subscribe.status intValue];
    switch (status) {
        case 2:
            self.stateL.text = @"已确认";
            break;
            
        default:
            self.stateL.text = @"已提交";
            break;
    }
    NSLog(@"-----%@",self.subscribe.content);
    self.contentText.text = self.subscribe.content;
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

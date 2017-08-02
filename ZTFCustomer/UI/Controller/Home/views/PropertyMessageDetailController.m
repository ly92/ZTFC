//
//  PropertyMessageController.m
//  ZTFCustomer
//
//  Created by wangshanshan on 16/11/6.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "PropertyMessageDetailController.h"
#import "ChatViewController.h"
#import "PropertyMessageCell.h"

static NSString *identifierId = @"PropertyMessageCell";
@interface PropertyMessageDetailController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tv;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation PropertyMessageDetailController

+(instancetype)spawn{
    return [self loadFromStoryBoard:@"Home"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationBar];
    self.view.backgroundColor = VIEW_BG_COLOR;
    self.tv.backgroundColor = VIEW_BG_COLOR;
    [self.tv tableViewRemoveExcessLine];
    
    [self.tv registerNib:identifierId identifier:identifierId];

    [self laodData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    HIDETABBAR;
}

#pragma mark-navibar
-(void)setNavigationBar{
    if (self.isSteward) {
        self.navigationItem.title = @"管家消息详情";
    }else{
        self.navigationItem.title = @"顾问消息详情";
    }
    self.navigationItem.leftBarButtonItem = [AppTheme backItemWithHandler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    
}

#pragma mark-初始化
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

#pragma mark-request

-(void)laodData{
    
    [self presentLoadingTips:nil];
    [[BaseNetConfig shareInstance]configGlobalAPI:ICE];
        PropertyMessageDetailAPI *propertyMessageDetailApi = [[PropertyMessageDetailAPI alloc]initWithMessageId:self.propertyMessageModel.message_id];
        [propertyMessageDetailApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            [self dismissTips];
            NSDictionary *result = (NSDictionary *)request.responseJSONObject;
            NSLog(@"%@",result);
            NSDictionary *content = result[@"content"];
            if (![ISNull isNilOfSender:content] && [result[@"code"] intValue] == 0) {
    
                NSDictionary *dic = content[@"message"];
                PropertyMessageModel *propertyMessageModel = [PropertyMessageModel mj_objectWithKeyValues:dic];
                [self.dataArray addObject:propertyMessageModel];
    
                [self.tv reloadData];
            }else{
                [self presentFailureTips:result[@"message"]];
            }
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            [self presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
        }];
    
}
#pragma mark-tableview delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PropertyMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierId forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.dataArray.count > indexPath.row) {
        PropertyMessageModel *propertyMessageModel = self.dataArray[indexPath.row];
        cell.propertyMessageDetailModel = propertyMessageModel;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArray.count > indexPath.row) {
        MessageModel *propertyMessageModel = self.dataArray[indexPath.row];
        
        return [self.tv cellHeightForIndexPath:indexPath model:propertyMessageModel keyPath:@"propertyMessageDetailModel" cellClass:[PropertyMessageCell class] contentViewWidth:SCREENWIDTH];
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}


@end

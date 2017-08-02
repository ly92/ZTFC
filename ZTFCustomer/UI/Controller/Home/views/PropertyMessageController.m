//
//  PropertyMessageController.m
//  ZTFCustomer
//
//  Created by wangshanshan on 16/11/6.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "PropertyMessageController.h"
#import "ChatViewController.h"
#import "PropertyMessageCell.h"
#import "PropertyMessageDetailController.h"

static NSString *identifierId = @"PropertyMessageCell";
@interface PropertyMessageController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tv;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, copy) NSString *limit;
@property (nonatomic, copy) NSString *skip;


@end

@implementation PropertyMessageController

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
    [self setHeaderAndFooter];
    
    [self.tv registerNib:identifierId identifier:identifierId];
    self.skip = @"0";
    self.limit = @"10";
    [self initloading];
    
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
        self.navigationItem.title = @"管家消息";
    }else{
        self.navigationItem.title = @"顾问消息";
    }
    self.navigationItem.leftBarButtonItem = [AppTheme backItemWithHandler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    self.navigationItem.rightBarButtonItem = [AppTheme itemWithContent:@"咨询聊天" handler:^(id sender) {
        if (![EMClient sharedClient].isLoggedIn){
            [[HuanxinService shareInstance] login];
        }
        
        ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:self.propertyModel.easemob conversationType:EMConversationTypeChat FromOther:YES];
        chatController.title = self.propertyModel.name;
        
        [self.navigationController pushViewController:chatController animated:YES];
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
-(void)loadNewData{
    self.skip = @"0";
    [self.dataArray removeAllObjects];
    [self laodData];
}
-(void)loadMoreData{
    self.skip = [NSString stringWithFormat:@"%d",[self.skip intValue] + [self.limit intValue]];
    [self laodData];
}
-(void)laodData{
    
    [[BaseNetConfig shareInstance]configGlobalAPI:ICE];
    PropertyListAPI *employeeMessageListApi = [[PropertyListAPI alloc]initWithkeyword:@"" limit:self.limit skip:self.skip];
    employeeMessageListApi.employeeType = EMPLOYEEMESSAGELISTTYPE;
    [employeeMessageListApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self doneLoadingTableViewData];
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        NSDictionary *content = result[@"content"];
        if (![ISNull isNilOfSender:content] && [result[@"code"] intValue] == 0) {
            
            NSArray *arr = content[@"message"];
            
            for (NSDictionary *dic in arr) {
                PropertyMessageModel *propertyMessageModel = [PropertyMessageModel mj_objectWithKeyValues:dic];
                [self.dataArray addObject:propertyMessageModel];
            }
            
            if (self.dataArray.count == 0) {
                self.tv.emptyDataSetSource = self;
                self.tv.emptyDataSetDelegate = self;
            }
            if (arr.count < [self.limit intValue]) {
                [self loadAll];
            }
            
            [self.tv reloadData];
            
        }else{
            self.tv.emptyDataSetSource = self;
            self.tv.emptyDataSetDelegate = self;
             [self.tv reloadData];
            [self presentFailureTips:result[@"message"]];
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self doneLoadingTableViewData];
        self.tv.emptyDataSetSource = self;
        self.tv.emptyDataSetDelegate = self;
         [self.tv reloadData];
        [self presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
    }];
    
}
#pragma mark-tableview delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PropertyMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierId forIndexPath:indexPath];
    
    cell.isList = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (self.dataArray.count > indexPath.row) {
        PropertyMessageModel *propertyMessageModel = self.dataArray[indexPath.row];
        cell.propertyMessageModel = propertyMessageModel;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArray.count > indexPath.row) {
        MessageModel *propertyMessageModel = self.dataArray[indexPath.row];
        
        return [self.tv cellHeightForIndexPath:indexPath model:propertyMessageModel keyPath:@"propertyMessageModel" cellClass:[PropertyMessageCell class] contentViewWidth:SCREENWIDTH];
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.dataArray.count > indexPath.row) {
        PropertyMessageModel *propertyMessageModel = self.dataArray[indexPath.row];
        NSInteger isRead = [propertyMessageModel.is_read integerValue];
        
        if (isRead == 0) {
            [[BaseNetConfig shareInstance]configGlobalAPI:ICE];
            ClearPropertyMessagePushAPI *clearPropertyMessagePushApi  =[[ClearPropertyMessagePushAPI alloc]initWithMessageId:propertyMessageModel.message_id count:@""];
            [clearPropertyMessagePushApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                NSDictionary *result = (NSDictionary *)request.responseJSONObject;
                NSLog(@"%@",result);
                NSDictionary *content = result[@"content"];
                if (![ISNull isNilOfSender:content] && [result[@"code"] intValue] == 0) {
                    
//                    NSDictionary *message = content[@"message"];
                    
                    
                }else{
                    [self presentFailureTips:result[@"message"]];
                }
            } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                [self presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
            }];
        }
        
        propertyMessageModel.is_read = @"1";
        [self.dataArray removeObjectAtIndex:indexPath.row];
        [self.dataArray insertObject:propertyMessageModel atIndex:indexPath.row];
        [self.tv reloadData];
        
        PropertyMessageDetailController *propertyMessageDetailCon = [PropertyMessageDetailController spawn];
        propertyMessageDetailCon.propertyMessageModel = propertyMessageModel;
        [self.navigationController pushViewController:propertyMessageDetailCon animated:YES];
        
    }
    
}

#pragma mark - DZNEmptyDelegate
-(UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    return [UIImage imageNamed:@"noactivity"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    
    
    NSString *text = @"暂没有顾问消息";
    
    if (self.isSteward) {
        text = @"暂没有管家消息";
    }
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

@end

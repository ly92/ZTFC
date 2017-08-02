//
//  MessageRootViewController.m
//  EstateBiz
//
//  Created by wangshanshan on 16/6/3.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "MessageRootViewController.h"
#import "MerchantMsgCell.h"
#import "SystemMsgCell.h"

static NSString *identifier1 = @"MerchantMsgCell";
static NSString *identifier2 = @"SystemMsgCell";

@interface MessageRootViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tv;
@property (weak, nonatomic) IBOutlet UIView *emptyView;
@property (weak, nonatomic) IBOutlet UILabel *emptyLbl;

@property (nonatomic, strong) NSMutableArray *dataList;

@property (nonatomic, strong) NSString *lastId;

//商家信息model
@property (nonatomic, strong) MessageModel *merchantMsgModel;

//个人信息（系统信息）model
@property (nonatomic, strong) MessageModel *systemMsgModel;


@end


@implementation MessageRootViewController

+(instancetype)spawn{
    return [MessageRootViewController loadFromStoryBoard:@"Message"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dataList = [NSMutableArray array];
    self.lastId = @"0";
    [self registerNoti];
    
    [self.tv tableViewRemoveExcessLine];
    
    [self setHeaderAndFooter];
    
    [self.tv registerNib:[UINib nibWithNibName:@"MerchantMsgCell" bundle:nil] forCellReuseIdentifier:identifier1];
    [self.tv registerNib:[UINib nibWithNibName:@"SystemMsgCell" bundle:nil] forCellReuseIdentifier:identifier2];
    
    
    
    
    
    //加载数据
    [self initloading];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark-noti
-(void)registerNoti{
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setAllMessageRed) name:@"MESSAGESETRED" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMessage) name:@"PushMsgCardAd" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshMessage) name:@"refreshMessage" object:nil];
    
}
-(void)setAllMessageRed{
    
    [[BaseNetConfig shareInstance]configGlobalAPI:WETOWN];
    
    [self presentLoadingTips:nil];
    AllMsgReadAPI *allMsgReadApi = [[AllMsgReadAPI alloc]initWithMainType:@"0"];
    [allMsgReadApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        [self dismissTips];
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
            self.lastId = @"0";
            [self initloading];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"SETMESSAGEREADSUCCESS" object:nil];
            
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
-(void)refreshMessage{
    [self initloading];
}
#pragma mark-加载数据
-(void)loadNewData{
    
    self.lastId = @"";
    [self.dataList removeAllObjects];
    [self loadMessage];
}

-(void)loadMoreData{
    [self loadMessage];
}


-(void)loadMessage{
    if (self.messageType == 0) {
        
        [[BaseNetConfig shareInstance]configGlobalAPI:WETOWN];
        //商家信息
        MessageAPI *messageApi = [[MessageAPI alloc]initWithMainType:@"3" lastId:self.lastId limit:@"20"];
        
        [messageApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
            
            [self doneLoadingTableViewData];
            MessageResultModel *result = [MessageResultModel mj_objectWithKeyValues:request.responseJSONObject];
            
            if (result && [result.result intValue] == 0) {
                
                for (MessageModel *merchantMsg in result.MList) {
                    [self.dataList addObject:merchantMsg];
                }
                self.lastId = result.LastID;
                if (result.MList.count == 0) {
                    self.emptyView.hidden = NO;
                    self.tv.hidden = YES;
                    self.emptyLbl.text = @"还没有商家信息哟!";
                }else{
                    self.emptyView.hidden = YES;
                    self.tv.hidden = NO;
                }

                if (result.MList.count < 20 ) {
                    [self loadAll];
                }
                
                [self.tv reloadData];
                
            }else{
                 [self presentFailureTips:result.reason];
            }

            
            
        } failure:^(__kindof YTKBaseRequest *request) {
            
            [self doneLoadingTableViewData];
            if (request.responseStatusCode == 0) {
                [self presentFailureTips:@"网络不可用，请检查网络链接"];
            }else{
                [self presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
            }
        }];
        
        
    
    }else{
        //个人信息
        
        [self.dataList removeAllObjects];
        
        [[BaseNetConfig shareInstance]configGlobalAPI:WETOWN];
        MessageAPI *messageApi = [[MessageAPI alloc]initWithMainType:@"2" lastId:self.lastId limit:@"20"];
        
        [messageApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
            
            [self doneLoadingTableViewData];
            
            MessageResultModel *result = [MessageResultModel mj_objectWithKeyValues:request.responseJSONObject];
            
            if (result && [result.result intValue] == 0) {
                for (MessageModel *systemMsg in result.MList) {
                    [self.dataList addObject:systemMsg];
                }
                self.lastId = result.LastID;

                if (result.MList.count == 0) {
                    self.emptyView.hidden = NO;
                    self.tv.hidden = YES;
                    self.emptyLbl.text = @"还没有个人信息哟!";
                }else{
                    self.emptyView.hidden = YES;
                    self.tv.hidden = NO;
                }
                
                if (result.MList.count < 20 ) {
                    [self loadAll];
                }
                
                [self.tv reloadData];
                
            }else{
                 [self presentFailureTips:result.reason];
            }
            
        } failure:^(__kindof YTKBaseRequest *request) {
            
            [self doneLoadingTableViewData];
            
            if (request.responseStatusCode == 0) {
                [self presentFailureTips:@"网络不可用，请检查网络链接"];
            }else{
                [self presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
            }
            
        }];
    
    }
}

#pragma mark-tableview delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.messageType == 0) {
        MerchantMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier1];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

        if (_dataList.count>indexPath.row) {
            MessageModel *message = _dataList[indexPath.row];
            cell.data = message;
            
            //判断是否已读
            if ([message.isread integerValue] == 0) {
                [cell.contentLbl setTextColor:UIColorFromRGB(0x333b46)];
            } else {
                [cell.contentLbl setTextColor:UIColorFromRGB(0xbfc7cc)];
            }
            
        }
        
        
        return cell;
        
    } else {
        
        
        SystemMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier2];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        

        if (_dataList.count>indexPath.row) {
            MessageModel *message = _dataList[indexPath.row];
            cell.data = message;
            
            //判断是否已读
            if ([message.isread integerValue] == 0) {
                [cell.contentLbl setTextColor:UIColorFromRGB(0x333b46)];
            } else {
                [cell.contentLbl setTextColor:UIColorFromRGB(0xbfc7cc)];
            }
        }
        
        return cell;
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.messageType == 0){
        if (_dataList.count > indexPath.row) {
            MessageModel *message = _dataList[indexPath.row];
            
            return [self.tv cellHeightForIndexPath:indexPath model:message keyPath:@"data" cellClass:[MerchantMsgCell class] contentViewWidth:SCREENWIDTH];
        }
        return 100;
    }else{
        return 100;
    }
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.delegate respondsToSelector:@selector(didSelectRowAtIndexPathTag:ListData:)]) {
        
        if (self.messageType == 0) {
            //商家信息
            self.merchantMsgModel = _dataList[indexPath.row];
            self.merchantMsgModel.id =  self.merchantMsgModel.id;
            self.merchantMsgModel.creationtime =  self.merchantMsgModel.creationtime;
            self.merchantMsgModel.maintype =  self.merchantMsgModel.maintype;
            self.merchantMsgModel.title =  self.merchantMsgModel.title;
            self.merchantMsgModel.isread =  self.merchantMsgModel.isread;
            self.merchantMsgModel.outlink =  self.merchantMsgModel.outlink;
            self.merchantMsgModel.isdeleted =  self.merchantMsgModel.isdeleted;
            self.merchantMsgModel.subtype =  self.merchantMsgModel.subtype;
            self.merchantMsgModel.bid =  self.merchantMsgModel.bid;
            self.merchantMsgModel.cid =  self.merchantMsgModel.cid;
            self.merchantMsgModel.relatedid =  self.merchantMsgModel.relatedid;
            self.merchantMsgModel.cardid =  self.merchantMsgModel.cardid;
            self.merchantMsgModel.imageurl =  self.merchantMsgModel.imageurl;
            self.merchantMsgModel.content =  self.merchantMsgModel.content;
            self.merchantMsgModel.name =  self.merchantMsgModel.name;
            self.merchantMsgModel.isread = @"1";
            
            [_dataList removeObjectAtIndex:indexPath.row];
            [_dataList insertObject: self.merchantMsgModel atIndex:indexPath.row];
            [self.tv reloadData];
            
            
        } else {
            //个人信息
            self.systemMsgModel = _dataList[indexPath.row];
            self.systemMsgModel.id =  self.systemMsgModel.id;
            self.systemMsgModel.creationtime =  self.systemMsgModel.creationtime;
            self.systemMsgModel.maintype =  self.systemMsgModel.maintype;
            self.systemMsgModel.title =  self.systemMsgModel.title;
            self.systemMsgModel.isread =  self.systemMsgModel.isread;
            self.systemMsgModel.outlink =  self.systemMsgModel.outlink;
            self.systemMsgModel.isdeleted =  self.systemMsgModel.isdeleted;
            self.systemMsgModel.subtype =  self.systemMsgModel.subtype;
            self.systemMsgModel.bid =  self.systemMsgModel.bid;
            self.systemMsgModel.cid =  self.systemMsgModel.cid;
            self.systemMsgModel.relatedid =  self.systemMsgModel.relatedid;
            self.systemMsgModel.cardid =  self.systemMsgModel.cardid;
            self.systemMsgModel.content =  self.systemMsgModel.content;
            self.systemMsgModel.name =  self.systemMsgModel.name;
            self.systemMsgModel.isread = @"1";
            
            [_dataList removeObjectAtIndex:indexPath.row];
            [_dataList insertObject:self.systemMsgModel atIndex:indexPath.row];
            [self.tv reloadData];
        }
        
        [self.delegate didSelectRowAtIndexPathTag:self.messageType ListData:_dataList[indexPath.row]];
    }
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

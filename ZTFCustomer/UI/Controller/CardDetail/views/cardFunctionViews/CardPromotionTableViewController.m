//
//  CardPromotionTableViewController.m
//  colourlife
//
//  Created by ly on 16/1/15.
//  Copyright © 2016年 liuyadi. All rights reserved.
//

#import "CardPromotionTableViewController.h"
#import "CardPromotionTableViewCell.h"
#import "CardPromotionDetailViewController.h"
#import "VoteDetailController.h"
#import "ActivityController.h"
#import "CardPromotionAPI.h"
#import "CardPromotionModel.h"
#import "VoteMsgDetailViewController.h"

@interface CardPromotionTableViewController ()<ActivityControllerDelegate,VoteDetailControllerDelegate,UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tv;
@property (weak, nonatomic) IBOutlet UIView *emptyView;

@property (nonatomic,strong) NSString *bid;
@property (nonatomic, strong) NSString *name;

@property (copy, nonatomic) NSString *last_id;//
@property (copy, nonatomic) NSString *last_datetime;//

@property (strong, nonatomic) NSMutableArray *cardList;//

@end

@implementation CardPromotionTableViewController

- (instancetype)initWithBid:(NSString *)bid Name:name{
    if (self = [super init]){
        self.name = name;
        self.bid = bid;
    }
    return self;
}

- (NSMutableArray *)cardList{
    if (!_cardList){
        _cardList = [NSMutableArray array];
    }
    return _cardList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //适配ios7
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)){
        self.navigationController.navigationBar.translucent = NO;
    }
    
    self.navigationItem.title = @"商家促销";
    self.navigationItem.leftBarButtonItem = [AppTheme backItemWithHandler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [self setHeaderAndFooter];
    [self.tv registerNib:[CardPromotionTableViewCell nib] forCellReuseIdentifier:@"CardPromotionTableViewCell"];
    self.tv.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tv.backgroundColor = RGBCOLOR(240, 240, 240);
    self.view.backgroundColor = RGBCOLOR(240, 240, 240);
    
    self.last_id = @"0";
    self.last_datetime = @"0";
    
    [self initloading];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PushMsgCardAd:) name:@"PushMsgCardAd" object:nil];
}

-(void)PushMsgCardAd:(NSNotification *)noti{
    [self initloading];
}

-(void)loadNewData{
    [self.cardList removeAllObjects];
    self.last_id = @"0";
    self.last_datetime = @"0";
    [self loadData];
}

-(void)loadMoreData{
    [self loadData];
}

- (void)loadData{
    if ([self.last_id intValue] == 0 && [self.last_datetime intValue] == 0){
        [self.cardList removeAllObjects];
    }

    CardPromotionAPI *promotionApi = [[CardPromotionAPI alloc] initWithBid:self.bid Limits:@"10" LastId:self.last_id LastDatetime:self.last_datetime];
    [[BaseNetConfig shareInstance] configGlobalAPI:KAKATOOL];
    [promotionApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        [self doneLoadingTableViewData];
        CardPromotionModel *result = [CardPromotionModel mj_objectWithKeyValues:request.responseJSONObject];
        if (result && [result.result intValue] == 0) {
            [self dismissTips];
            self.last_id = result.last_id;
            self.last_datetime = result.last_datetime;
            
            [self.cardList addObjectsFromArray:result.CardList];
            
            if (self.cardList.count == 0) {
                self.tv.hidden = YES;
                self.emptyView.hidden = NO;
            }else{
                self.tv.hidden = NO;
                self.emptyView.hidden = YES;
            }
            
            if (result.CardList.count < 10) {
                [self loadAll];
            }
            
           
            [self.tv reloadData];
            
        }
        else{
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

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.cardList.count > 0){
        return self.cardList.count;
    }
        return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"CardPromotionTableViewCell";
    CardPromotionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    if (!cell){
        cell = [[CardPromotionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    if (self.cardList.count > indexPath.row){
        cell.data = self.cardList[indexPath.row];
    }
        return cell;
   
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PromotionModel *promotion = [self.cardList objectAtIndex:indexPath.row];
    
    if (promotion && [promotion.msg_type isEqualToString:@"msg"]) {
        
        CardPromotionDetailViewController *detailViewController = [[CardPromotionDetailViewController alloc] initWithBusName:self.name Promotion:promotion];
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
    else if (promotion && [promotion.msg_type isEqualToString:@"vote"])
    {
        Msg_Extinfo *msg_exitinfo = promotion.msg_extinfo;
                VoteDetailController *voteDetail = [[VoteDetailController alloc] initWithMsgInfo:msg_exitinfo promotion:promotion];
                voteDetail.voteDelegate = self;
        [self.navigationController pushViewController:voteDetail animated:YES];
        
        

    }
    else if (promotion && [promotion.msg_type isEqualToString:@"events"])
    {
        
        Msg_Extinfo *msg_exitinfo = promotion.msg_extinfo;
        ActivityController *acDetail = [[ActivityController alloc] initWithMsgInfo:msg_exitinfo creationtime:promotion];
                acDetail.activityDelegate = self;
        [self.navigationController pushViewController:acDetail animated:YES];
    }

   }

#pragma mark -ActivityControllerDelegate,VoteDetailControllerDelegate

- (void)refreshData{
    self.last_id = @"0";
    self.last_datetime = @"0";
    [self loadData];
}
@end

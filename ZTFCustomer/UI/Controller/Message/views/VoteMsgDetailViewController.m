//
//  VoteMsgDetailViewController.m
//  EstateBiz
//
//  Created by wangshanshan on 16/6/3.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "VoteMsgDetailViewController.h"
#import "VotaMTableViewCell.h"
#import "VoteResultTableViewCell.h"
#import "VoteTableViewCell.h"

@interface VoteMsgDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *voteButton;

@property (weak, nonatomic) IBOutlet UILabel *contentLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;

@property (weak, nonatomic) IBOutlet UILabel *timeL;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentVH;

@property (weak, nonatomic) IBOutlet UITableView *tvS;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tvSH;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewHeight;


@property (weak, nonatomic) IBOutlet UITableView *tvR;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tvRH;

@property (weak, nonatomic) IBOutlet UITableView *tvM;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tvViewHeight;


@property (nonatomic, strong) NSArray *items;

@property (nonatomic, assign) int type;
@property (nonatomic, assign) float allVotes;

@property (nonatomic, strong) NSMutableArray *itemIdArray;

@property (nonatomic, strong) NSString *voteId;

//
@property (nonatomic, strong) CardMsgDetailModel *voteMsg;
@property (nonatomic, strong) ActivityMsg_extinfoModel *voteInfo;

@end

@implementation VoteMsgDetailViewController

+(instancetype)spawn{
    return [VoteMsgDetailViewController loadFromStoryBoard:@"Message"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationBar];
    [self setStyle];
    
    [self.tvS registerNib:[VoteTableViewCell nib] forCellReuseIdentifier:@"VoteTableViewCell"];
    self.tvS.backgroundColor = [UIColor clearColor];
    [self.tvM registerNib:[VotaMTableViewCell nib] forCellReuseIdentifier:@"VotaMTableViewCell"];
    self.tvM.backgroundColor = [UIColor clearColor];
    [self.tvR registerNib:[VoteResultTableViewCell nib] forCellReuseIdentifier:@"VoteResultTableViewCell"];
    self.tvR.backgroundColor = [UIColor clearColor];
    
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

- (NSMutableArray *)itemIdArray{
    if (!_itemIdArray){
        _itemIdArray = [NSMutableArray array];
    }
    return _itemIdArray;
}
#pragma mark-navibar

-(void)setNavigationBar{
    
    self.navigationItem.title = @"商家投票";
    
    self.navigationItem.leftBarButtonItem = [AppTheme backItemWithHandler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
}
#pragma mark-style
-(void)setStyle{
    self.voteButton.backgroundColor = JoinButtonColor;
    [self.voteButton setTitleColor:TEXTCONTENTCOLOR forState:UIControlStateNormal];
    
    self.voteButton.layer.cornerRadius = 4;
}

#pragma mark-
- (void)prepareView{

    self.contentLbl.text = self.voteMsg.content;
    
    CGFloat contentHeight = [self.contentLbl resizeHeight];
    self.contentHeight.constant = contentHeight;
    self.contentVH.constant = contentHeight + 50;
    
    self.items = self.voteInfo.item;
    
    for (VoteItemModel *item in self.items) {
        self.allVotes += [item.votes floatValue];
        NSLog(@"%f",self.allVotes);
    }
    
    if (self.items.count == 0){
        self.allVotes = 1;
        return;
    }
    if (!self.allVotes) {
        self.allVotes = 1;
    }
    
    if ([self.voteInfo.is_join intValue] == 0){//没有投票
        self.voteId = self.voteInfo.info.id;
        self.voteButton.enabled = YES;
        
        if ([self.voteInfo.info.option_type isEqualToString:@"radio"]){//单选
            self.tvRH.constant = 0;
            self.tvR.hidden = YES;
            self.tvM.hidden = YES;
            self.tvS.hidden = NO;
            
            self.type = 1;
            
            self.tvViewHeight.constant = self.items.count * 35;
            self.tvSH.constant = self.items.count * 35;
            
            [self.tvS reloadData];
        }else{//多选
            self.tvRH.constant = 0;
            self.tvR.hidden = YES;
            self.tvSH.constant = 0;
            self.tvS.hidden = YES;
            self.tvM.hidden = NO;
            
            self.type = 2;
            
            self.tvViewHeight.constant = self.items.count * 35;
            
            [self.tvM reloadData];
        }
        
        self.containerViewHeight.constant = self.contentVH.constant + self.tvViewHeight.constant + 40 +30;
        
    }else{//已投票，显示结果
        [self showResult];
    }
}

- (void)showResult{
    self.tvSH.constant = 0;
    self.tvS.hidden = YES;
    self.tvM.hidden = YES;
    self.tvR.hidden = NO;
    self.type = 3;
    self.voteButton.enabled = NO;
    self.voteButton.backgroundColor = NotJoinButtonColor;
    [self.voteButton setTitleColor:TEXTCONTENTCOLOR forState:UIControlStateNormal];
    
    self.tvViewHeight.constant = self.items.count * 50;
    self.tvRH.constant = self.tvViewHeight.constant;
    
    self.containerViewHeight.constant = self.contentVH.constant + self.tvViewHeight.constant + 40 +30;
    
    [self.tvR reloadData];
}

#pragma mark-加载数据
-(void)loadData{
    if (!self.relatedId) {
        return;
    }
    
    [self presentLoadingTips:nil];
    [[BaseNetConfig shareInstance] configGlobalAPI:WETOWN];
    
    MerchantMsgDetailAPI *merchantMsgDetailApi = [[MerchantMsgDetailAPI alloc]initWithMsgId:self.relatedId];
    
    [merchantMsgDetailApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        [self dismissTips];
        ActivityDetailResultModel *result = [ActivityDetailResultModel mj_objectWithKeyValues:request.responseJSONObject];
        
        if (result && [result.result intValue] == 0) {
            
            self.voteMsg = result.Msg;
            self.voteInfo = result.msg_extinfo;
            [self prepareView];
            
        }else{
             [self presentFailureTips:result.reason];
        }
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
        if (request.responseStatusCode == 0) {
            [self presentFailureTips:@"网络不可用，请检查网络链接"];
        }else{
            [self presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
        }
        
    }];
    
    
}


#pragma mark-click
//投票
- (IBAction)voteButtonClick:(id)sender {
    if (self.itemIdArray.count == 0) {
         [self presentFailureTips:@"请选择投票选项"];
        return;
    }
    
    NSString *bid = self.voteInfo.info.bid;
    NSString *voteId = self.voteInfo.info.id;
    NSString *itemId = [self.itemIdArray jsonStringEncoded];
    
    [self presentLoadingTips:nil];
    [[BaseNetConfig shareInstance] configGlobalAPI:KAKATOOL];
    VoteAPI *voteApi = [[VoteAPI alloc]initWithBid:bid voteId:voteId itemId:itemId];
    
    [voteApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        [self dismissTips];
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        if (![ISNull isNilOfSender:result] && [result[@"result"]intValue] == 0) {
            if (self.type == 1){
                self.allVotes = 1;
            }else if (self.type == 2){
                self.allVotes = self.itemIdArray.count;
            }
            self.type = 3;
            self.voteInfo.is_join = @"1";
            [self showResult];

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

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([ISNull isNilOfSender:self.items]) return 0;
    NSLog(@"%lu",(unsigned long)self.items.count);
    return self.items.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.items.count != 0){
        NSString *ID = @"";
        if (self.type == 1){//单选
            ID = @"VoteTableViewCell";
            VoteTableViewCell *cell = [self.tvS dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
            if (!cell){
                cell = [[VoteTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
            }
            cell.data = [self.items objectAtIndex:indexPath.row];
            return cell;
            
        }else if (self.type == 2){//多选
            ID = @"VotaMTableViewCell";
            VotaMTableViewCell *cell = [self.tvM dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
            if (!cell){
                cell = [[VotaMTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
            }
            cell.data = [self.items objectAtIndex:indexPath.row];
            return cell;
            
        }else if (self.type == 3){//结果
            ID = @"VoteResultTableViewCell";
            VoteResultTableViewCell *cell = [self.tvR dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
            if (!cell){
                cell = [[VoteResultTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
            }
            
            VoteItemModel *item = [self.items objectAtIndex:indexPath.row];
            
            
            cell.introL.text = item.item_name;
            
            float scal = [item.votes floatValue] / self.allVotes;
            if (self.itemIdArray && [self.itemIdArray containsObject:item.id]){
                scal = ([item.votes floatValue] + 1) / self.allVotes;
            }
            cell.VW.constant = cell.width * scal;
            cell.lab.text = [NSString stringWithFormat:@"%.0f％",scal * 100];
            return cell;
            
        }
        
    }
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.type == 3) return 50;
    
    return 35;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    VoteItemModel *item = [self.items objectAtIndex:indexPath.row];
    
    if (self.type == 3){
        return;
    }else if(self.type == 2){
        if ([self.itemIdArray containsObject:item.id]){
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }else{
            [self.itemIdArray addObject:item.id];
        }
    }else{
        [self.itemIdArray removeAllObjects];
        [self.itemIdArray addObject:item.id];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    VoteItemModel *item = [self.items objectAtIndex:indexPath.row];
    
    if(self.type == 2){
        if ([self.itemIdArray containsObject:item.id]){
            [self.itemIdArray removeObject:item.id];
        }
    }
}
// Dispose of any resources that can be recreated.


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

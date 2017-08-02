//
//  VoteDetailController.m
//  CardToon
//
//  Created by fengwanqi on 13-11-13.
//  Copyright (c) 2013年 com.coortouch.ender. All rights reserved.
//


#import "VoteDetailController.h"
#import "VoteTableViewCell.h"
#import "VotaMTableViewCell.h"
#import "VoteResultTableViewCell.h"
#import "CardPromotionModel.h"
#import "VoteAPI.h"

@interface VoteDetailController ()<UITableViewDataSource,UITableViewDelegate>


@property (weak, nonatomic) IBOutlet UITextView *contentT;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentVH;

@property (weak, nonatomic) IBOutlet UITableView *tvS;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tvSH;

@property (weak, nonatomic) IBOutlet UITableView *tvM;

@property (weak, nonatomic) IBOutlet UITableView *tvR;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tvRH;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *TVH;

@property (weak, nonatomic) IBOutlet UIButton *voteBtn;

@property (nonatomic, strong) NSArray *items;

@property (nonatomic, assign) int type;
@property (nonatomic, assign) float allVotes;

@property (nonatomic, strong) NSMutableArray *itemIdArray;

@property (nonatomic, strong) NSString *voteId;


@property (nonatomic, strong) Msg_Extinfo *msgInfo;
@property (nonatomic, strong) PromotionModel *promotion;
@end

@implementation VoteDetailController

- (NSMutableArray *)itemIdArray{
    if (!_itemIdArray){
        _itemIdArray = [NSMutableArray array];
    }
    return _itemIdArray;
}

- (instancetype)initWithMsgInfo:(Msg_Extinfo *)msgInfo promotion:(PromotionModel *)promotion{
    if (self = [super init]){
        self.msgInfo = msgInfo;
        self.promotion = promotion;
    }
    return self;
}

- (IBAction)voteClick:(id)sender {
    if (self.itemIdArray.count == 0) {
         [self presentFailureTips:@"请选择投票选项"];
        return;
    }

    VoteAPI *voteApi = [[VoteAPI alloc] initWithBid:self.msgInfo.info.bid voteId:self.voteId itemId:[self.itemIdArray mj_JSONString]];
    [voteApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        [self dismissTips];
        NSDictionary *result = request.responseJSONObject;
        if (![ISNull isNilOfSender:result] && [[result objectForKey:@"result"] intValue] == 0){
        
            if (self.type == 1){
                self.allVotes = 1;
            }else if (self.type == 2){
                self.allVotes = self.itemIdArray.count;
            }
            self.type = 3;
            self.msgInfo.is_join = @"1";
            [self showResult];
            [self presentSuccessTips:@"投票成功!"];
            
            //刷新上一个界面
            if ([self.voteDelegate respondsToSelector:@selector(refreshData)]){
                [self.voteDelegate refreshData];
            }
            
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


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.contentT.text = self.msgInfo.info.intro;
//    self.timeL.text = [NSDate longlongToDateTime:self.msgInfo.info.creationtime];

    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[self.msgInfo.info.creationtime  longLongValue]];
    self.timeL.text = [date stringWithFormat:@"yyyy-MM-dd HH:mm"];

}

- (void)prepareView{
    self.items = self.msgInfo.item;
    
    for (PromotionItem *item in self.items) {
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
    
    if ([self.msgInfo.is_join intValue] == 0){//没有投票
        self.voteId = self.msgInfo.info.ID;
        self.voteBtn.enabled = YES;
        
        if ([self.msgInfo.info.option_type isEqualToString:@"radio"]){//单选
            self.tvRH.constant = 0;
            self.tvR.hidden = YES;
            self.tvM.hidden = YES;
            self.tvS.hidden = NO;
            
            self.type = 1;
            
            self.TVH.constant = self.items.count * 35;
            self.tvSH.constant = self.items.count * 35;
            
            [self.tvS reloadData];
        }else{//多选
            self.tvRH.constant = 0;
            self.tvR.hidden = YES;
            self.tvSH.constant = 0;
            self.tvS.hidden = YES;
            self.tvM.hidden = NO;
            
            self.type = 2;
            
            self.TVH.constant = self.items.count * 35;
            
            [self.tvM reloadData];
        }
        
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
    self.voteBtn.enabled = NO;
    self.voteBtn.backgroundColor = [UIColor grayColor];
    
    self.TVH.constant = self.items.count * 50;
    self.tvRH.constant = self.TVH.constant;
    
    [self.tvR reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //适配ios7
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)){
        self.navigationController.navigationBar.translucent = NO;
    }
    
       self.navigationItem.title = @"商家投票";
    self.navigationItem.leftBarButtonItem = [AppTheme backItemWithHandler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    if (self.promotion.bid) {
        
        [[LocalizePush shareLocalizePush] updateLoaclCardId:self.promotion.bid Kind:Votes];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshHomeBadgle" object:nil];
    }
    
    [self.tvS registerNib:[VoteTableViewCell nib] forCellReuseIdentifier:@"VoteTableViewCell"];
    self.tvS.backgroundColor = [UIColor clearColor];
    [self.tvM registerNib:[VotaMTableViewCell nib] forCellReuseIdentifier:@"VotaMTableViewCell"];
    self.tvM.backgroundColor = [UIColor clearColor];
    [self.tvR registerNib:[VoteResultTableViewCell nib] forCellReuseIdentifier:@"VoteResultTableViewCell"];
    self.tvR.backgroundColor = [UIColor clearColor];
    self.voteBtn.layer.cornerRadius = 5;
    
    [self prepareView];

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
            
            PromotionItem *item = [self.items objectAtIndex:indexPath.row];
            
            cell.introL.text = item.item_name;
            
            float scal = [item.votes floatValue] / self.allVotes;
            if (self.itemIdArray && [self.itemIdArray containsObject:item.ID]){
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
    PromotionItem *item = [self.items objectAtIndex:indexPath.row];
    
    if (self.type == 3){
        return;
    }else if(self.type == 2){
        if ([self.itemIdArray containsObject:item.ID]){
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }else{
            [self.itemIdArray addObject:item.ID];
        }
    }else{
        [self.itemIdArray removeAllObjects];
        [self.itemIdArray addObject:item.ID];
    }

}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    PromotionItem *item = [self.items objectAtIndex:indexPath.row];
    
    if(self.type == 2){
        if ([self.itemIdArray containsObject:item.ID]){
            [self.itemIdArray removeObject:item.ID];
        }
    }

    
}

@end

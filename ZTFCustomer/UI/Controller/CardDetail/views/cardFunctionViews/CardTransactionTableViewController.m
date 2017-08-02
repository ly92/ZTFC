//
//  CardTransactionTableViewController.m
//  colourlife
//
//  Created by ly on 16/1/15.
//  Copyright © 2016年 liuyadi. All rights reserved.
//

#import "CardTransactionTableViewController.h"
#import "BalanceTableViewCell.h"
#import "CardTransactionDetailViewController.h"
#import "CardTransactionAPI.h"
#import "CardTransactionModel.h"

@interface CardTransactionTableViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tv;

@property (weak, nonatomic) IBOutlet UIView *emptyView;

@property (nonatomic,strong) NSString *bid;
@property (nonatomic, strong) NSString *name;

@property (nonatomic,strong) NSMutableArray *sectionArray;
@property (nonatomic,strong) NSMutableArray *resultArray;
@property (nonatomic, strong) NSMutableDictionary *isHiddenSections;

@property (copy, nonatomic) NSString *last_id;//
@property (copy, nonatomic) NSString *last_datetime;//
@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation CardTransactionTableViewController

- (NSMutableArray *)sectionArray{
    if (_sectionArray == nil){
        _sectionArray = [NSMutableArray array];
    }
    return _sectionArray;
}
- (NSMutableArray *)resultArray{
    if (_resultArray == nil){
        _resultArray = [NSMutableArray array];
    }
    return _resultArray;
}
- (NSMutableDictionary *)isHiddenSections{
    if (!_isHiddenSections){
        _isHiddenSections = [NSMutableDictionary dictionary];
    }
    return _isHiddenSections;
}

-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (instancetype)initWithBid:(NSString *)bid Name:(NSString *)name{
    if (self = [super init]){
        self.bid = bid;
        self.name = name;
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    //适配ios7
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)){
        self.navigationController.navigationBar.translucent = NO;
    }
    
    self.navigationItem.title = @"消费记录";
    self.navigationItem.leftBarButtonItem = [AppTheme backItemWithHandler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [self setHeaderAndFooter];
    [self.tv registerNib:[BalanceTableViewCell nib] forCellReuseIdentifier:@"BalanceTableViewCell"];
    self.tv.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tv.backgroundColor = RGBCOLOR(240, 240, 240);
    self.view.backgroundColor = RGBCOLOR(240, 240, 240);
    
    self.last_id = @"0";
    self.last_datetime = @"0";
    
 
    [self initloading];
}

-(void)loadNewData{
    [self.sectionArray removeAllObjects];
    self.last_id = @"0";
    self.last_datetime = @"0";
    [self loadData];
}

-(void)loadMoreData{
    [self loadData];
}

- (void)loadData{
    CardTransactionAPI *cardtransactionApi = [[CardTransactionAPI alloc] initWithBid:self.bid Limits:@"10" LastId:self.last_id LastDatetime:self.last_datetime];
    [[BaseNetConfig shareInstance] configGlobalAPI:KAKATOOL];
    [cardtransactionApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        [self doneLoadingTableViewData];
        [self dismissTips];
        CardTransactionModel *result = [CardTransactionModel mj_objectWithKeyValues:request.responseJSONObject];
        if (result && [result.result intValue] == 0) {
            
            self.last_id = result.last_id;
            self.last_datetime = result.last_datetime;
            
            [self.dataArr addObjectsFromArray:result.data];
            
            if (result.data.count <= 0){
                self.tv.hidden = YES;
                self.emptyView.hidden = NO;
            }else{
                self.tv.hidden = NO;
                self.emptyView.hidden = YES;
            }

            if (result.data.count < 10) {
                [self loadAll];
            }
            
            [self sortArrayByCreatetime:self.dataArr];
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


- (void)sortArrayByCreatetime:(NSMutableArray *)array{
    [self.resultArray removeAllObjects];
    [self.sectionArray removeAllObjects];
    
    NSMutableArray *tempSecArr = [NSMutableArray arrayWithCapacity:0];
    
    for (int i=0; i<array.count; i++) {
        TransactionModel *tif = array[i];
        NSDate *creationtime = [NSDate dateWithTimeIntervalSince1970:[tif.creationtime longLongValue]];
        NSString *date = [creationtime stringWithFormat:@"yyyy-MM"];
        [tempSecArr addObject:date];
        
    }
    
    //NSLog(@"排序前：tempSecArr1=%@",tempSecArr);
    tempSecArr = [NSMutableArray arrayWithArray:[[NSSet setWithArray:tempSecArr] allObjects]];
    //NSLog(@"排序前：tempSecArr2=%@",tempSecArr);
    
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"self" ascending:NO]];
    [tempSecArr sortUsingDescriptors:sortDescriptors];
    //NSLog(@"排序后：tempSecArr=%@",tempSecArr);
    
    NSMutableArray *lastSecArr = [NSMutableArray arrayWithArray:self.sectionArray];
    //NSLog(@"lastSecArr=%@",lastSecArr);
    
    [self.sectionArray addObjectsFromArray:tempSecArr];
    //NSLog(@"上拉加载后：_sectionArray=%@",_sectionArray);
    
    self.sectionArray = [NSMutableArray arrayWithArray:[[NSSet setWithArray:_sectionArray] allObjects]];
    [self.sectionArray sortUsingDescriptors:sortDescriptors];
    //NSLog(@"倒序后：_sectionArray=%@",_sectionArray);
    
    for (int i=0; i<tempSecArr.count; i++) {
        
        __block NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:0];
        
        [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            TransactionModel *tif = obj;
            
            NSDate *creationtime = [NSDate dateWithTimeIntervalSince1970:[tif.creationtime longLongValue]];
            NSString *date = [creationtime stringWithFormat:@"yyyy-MM"];
            
            NSRange range = [date rangeOfString:[NSString stringWithFormat:@"%@",tempSecArr[i]]];
            
            if (range.length != 0) {
                [tempArray addObject:tif];
            }
        }];
        
        if ([lastSecArr.lastObject isEqualToString:tempSecArr[i]]) {
            [self.resultArray.lastObject addObjectsFromArray:tempArray];
        }
        else {
            [self.resultArray addObject:tempArray];
        }
    }
    
    [self.tv reloadData];
}


#pragma mark - Table view data source - Table view delegate


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.resultArray.count != 0) {
        return self.resultArray.count;
    }
    
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 65.f;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([_isHiddenSections objectForKey:[NSString stringWithFormat:@"%ld",section]]) {
        return 0;
    }
    
    if (self.resultArray.count != 0) {
        return [(NSArray *)[self.resultArray objectAtIndex:section] count];
    }
    
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 26.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 25)];
    sectionView.backgroundColor = RGBCOLOR(240, 240, 240);
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, tableView.width * 0.3, 25)];
    titleLabel.backgroundColor = [UIColor clearColor];
    UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(tableView.width * 0.35, 0, tableView.width * 0.6, 25)];
    descLabel.backgroundColor = [UIColor clearColor];
    
    if ([ISNull isNilOfSender:self.sectionArray] == NO) {
        NSString *month = self.sectionArray[section];
        if (self.resultArray.count != 0) {
            
            NSMutableArray *rowsArray = [self.resultArray objectAtIndex:section];
            if (rowsArray) {
                
                float charge = 0.0;
                float consume = 0.0;
                
                for (TransactionModel *tif in rowsArray) {
                    int maintype = [tif.maintype intValue];
                    float amount = [tif.amount floatValue];
                    
                    if ([tif.tstatus intValue] != 100) {
                        //maintype:1充值，2消费
                        if (maintype == 1) {
                            charge += amount;
                        }
                        else {
                            consume += amount;
                        }
                    }
                    
                }
                
                descLabel.text = [NSString stringWithFormat:@"消费:¥%.2f 充值:¥%.2f",consume,charge];
                titleLabel.text = month;
                
            }
        }
    }
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = RGBCOLOR(51, 59, 70);
    titleLabel.font = [UIFont systemFontOfSize:14];
    
    descLabel.textAlignment = NSTextAlignmentRight;
    descLabel.textColor = [UIColor darkGrayColor];
    descLabel.font = [UIFont systemFontOfSize:12];
    
    [sectionView addSubview:titleLabel];
    [sectionView addSubview:descLabel];
    
    [sectionView addTapAction:@selector(sectionViewDidSelect:) forTarget:self];
    sectionView.tag = section;
    
    return sectionView;
    
}

//点击section隐藏列表rows
- (void)sectionViewDidSelect:(UIGestureRecognizer *)sender
{
    UILabel *label = (UILabel *)sender.view;
    //NSLog(@"section %d 被点击",label.tag);
    if (![_isHiddenSections objectForKey:[NSString stringWithFormat:@"%ld",label.tag]]) {
        //收缩
        [_isHiddenSections setObject:@"YES" forKey:[NSString stringWithFormat:@"%ld",label.tag]];
    }
    else
    {
        //展开
        [_isHiddenSections removeObjectForKey:[NSString stringWithFormat:@"%ld",label.tag]];
    }
    [self.tv reloadSections:[NSIndexSet indexSetWithIndex:label.tag] withRowAnimation:UITableViewRowAnimationFade];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([ISNull isNilOfSender:self.resultArray] == NO){
        static NSString *ID = @"BalanceTableViewCell";
        BalanceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
        if (!cell){
            cell = [[BalanceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        NSMutableArray *rowsArray = [self.resultArray objectAtIndex:indexPath.section];
        if (rowsArray) {
            cell.data = [rowsArray objectAtIndex:indexPath.row];
        }
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSMutableArray *rowsArray = [self.resultArray objectAtIndex:indexPath.section];
    
    if (rowsArray) {
        TransactionModel *transaction = [rowsArray objectAtIndex:indexPath.row];
        if (transaction) {
            CardTransactionDetailViewController *detailViewController = [[CardTransactionDetailViewController alloc] initWithTid:transaction.tid];
            [self.navigationController pushViewController:detailViewController animated:YES];
        }
    }
}




@end

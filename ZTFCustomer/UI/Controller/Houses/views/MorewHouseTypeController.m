//
//  MorewHouseTypeController.m
//  ztfCustomer
//
//  Created by mac on 16/7/11.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "MorewHouseTypeController.h"
#import "MoreHouseTypeCell.h"
#import "HouseTypeDetailController.h"
@interface MorewHouseTypeController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tv;

@property (nonatomic, strong) NSMutableArray *housetypeDataArray;
@property (nonatomic, copy) NSString *limit;
@property (nonatomic, copy) NSString *skip;

@property (nonatomic, assign) NSInteger currentRow;;

@end

@implementation MorewHouseTypeController

+(instancetype)spawn{
    return [MorewHouseTypeController loadFromStoryBoard:@"Houses"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavigationBar];
    
    [self setHeaderAndFooter];
    [self.tv registerNib:@"MoreHouseTypeCell" identifier:@"MoreHouseTypeCell"];
    
    self.skip = @"0";
    self.limit = @"10";
    [self initloading];
    
    [self fk_observeNotifcation:@"OPERATEHOUSETYPESUCCESS" usingBlock:^(NSNotification *note) {
        HouseTypeModel *houseTypModel = (HouseTypeModel *)note.object;
        [self.housetypeDataArray replaceObjectAtIndex:self.currentRow withObject:houseTypModel];
    }];
    
   
    
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
#pragma mark - navibar
-(void)setNavigationBar{
    self.navigationItem.title = @"更多户型";
    self.navigationItem.leftBarButtonItem = [AppTheme backItemWithHandler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
}

-(NSMutableArray *)housetypeDataArray{
    if (!_housetypeDataArray) {
        _housetypeDataArray = [NSMutableArray array];
    }
    return _housetypeDataArray;
}

#pragma mark - request
-(void)loadNewData{
    self.skip = @"0";
    [self.housetypeDataArray removeAllObjects];
    [self loadData];
}

-(void)loadMoreData{
    self.skip  =[NSString stringWithFormat:@"%d", [self.limit intValue] + [self.skip intValue]];
    [self loadData];
}
-(void)loadData{
    
    [[BaseNetConfig shareInstance]configGlobalAPI:ICE];
    HouseTypeListAPI *houseTypeListApi = [[HouseTypeListAPI alloc]initWithProjectId:self.projectModel.project_id skip:self.skip limit:self.limit];
    [houseTypeListApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self doneLoadingTableViewData];
        
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        NSDictionary *content = result[@"content"];
        if (![ISNull isNilOfSender:content] && [result[@"code"] intValue] == 0) {
            
            NSArray *houseTypes = content[@"houseTypes"];
            for (NSDictionary *dic in houseTypes) {
                HouseTypeModel *housetypeModel = [HouseTypeModel mj_objectWithKeyValues:dic];
                 housetypeModel.mobile =self.projectModel.tel;
                [self.housetypeDataArray addObject:housetypeModel];
            }
            
            if (self.housetypeDataArray.count == 0) {
                self.tv.emptyDataSetSource = self;
                self.tv.emptyDataSetDelegate = self;
            }
            
            if (houseTypes.count < [self.limit intValue]) {
                [self loadAll];
            }else{
                [self resetLoadAll];
            }
            [self.tv reloadData];
            
        }else{
            [self presentFailureTips:result[@"message"]];
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self doneLoadingTableViewData];
        [self presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
    }];
    
}

#pragma mark - tableview delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.housetypeDataArray.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MoreHouseTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MoreHouseTypeCell" forIndexPath:indexPath];
    
    if (self.housetypeDataArray.count> indexPath.row) {
        cell.data = self.housetypeDataArray[indexPath.row];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 95;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.housetypeDataArray.count> indexPath.row) {
        HouseTypeModel *houseTypeModel = self.housetypeDataArray[indexPath.row];
        HouseTypeDetailController *houseTypeDetail = [HouseTypeDetailController spawn];
        houseTypeDetail.projectId = self.projectModel.project_id;
        houseTypeDetail.houseTypeModel = houseTypeModel;
        self.currentRow = indexPath.row;
        [self.navigationController pushViewController:houseTypeDetail animated:YES];
    }
    
//    HouseTypeDetailController *houseTypeDetail = [HouseTypeDetailController spawn];
//    [self.navigationController pushViewController:houseTypeDetail animated:YES];
}

-(UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
     return [UIImage imageNamed:@"noactivity"];
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

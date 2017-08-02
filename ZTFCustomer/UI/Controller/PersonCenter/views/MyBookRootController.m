//
//  MyBookRootController.m
//  ztfCustomer
//
//  Created by mac on 16/7/12.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "MyBookRootController.h"
#import "SubscribeTableViewCell.h"
#import "SubscribeDetailViewController.h"
#import "MyBookDetailController.h"
#import "HouseBookCell.h"

@interface MyBookRootController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tv;

@property (nonatomic, strong) NSMutableArray *dataList;

@property (nonatomic, copy) NSString *last_id;

@property (nonatomic, copy) NSString *limit;
@property (nonatomic, copy) NSString *skip;

@property (nonatomic, strong) NSIndexPath *currentIndexPath;
@property (nonatomic, assign) NSInteger currentRow;
@end

@implementation MyBookRootController
+(instancetype)spawn{
    return [MyBookRootController loadFromStoryBoard:@"PersonalCenter"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.tv tableViewRemoveExcessLine];
    self.tv.backgroundColor = VIEW_BG_COLOR;
    [self setNavigationBar];
    [self setHeaderAndFooter];
    [self.tv registerNib:@"HouseBookCell" identifier:@"HouseBookCell"];
    
    self.skip = @"0";
    self.limit = @"10";
    
    [self initloading];
    [self registernoti];
    
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

-(void)setNavigationBar{
    self.navigationItem.title = @"预约看房";
    
    self.navigationItem.leftBarButtonItem = [AppTheme backItemWithHandler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
}

-(void)registernoti{
    
    [self fk_observeNotifcation:@"OPERATEBOOKSUCCESS" usingBlock:^(NSNotification *note) {
        AppointmentModel *appointmentModel = (AppointmentModel *)note.object;
//        [self.dataList removeObjectAtIndex:self.currentIndexPath.row];
//        [self.dataList insertObject:appointmentModel atIndex:self.currentIndexPath.row];
        if (self.dataList.count > self.currentRow) {
            
            [self.dataList replaceObjectAtIndex:self.currentRow withObject:appointmentModel];
            [self.tv reloadData];
            
        }else{
            [self initloading];
        }
       
        
        
        
        
    }];
}

#pragma mark-lan jia zia

-(NSMutableArray *)dataList{
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}


#pragma mark-loadData

-(void)loadNewData{
    self.skip = @"0";
    [self.dataList removeAllObjects];
    
    [self loadData];
}

-(void)loadMoreData{
    
    NSInteger count = [self.skip integerValue];
    self.skip = [NSString stringWithFormat:@"%ld",count +[self.limit integerValue]];
    
    [self loadData];
}

-(void)loadData{
    
    NSString *bid = @"";
    if (self.bid) {
        bid = self.bid;
    }
    
    [[BaseNetConfig shareInstance]configGlobalAPI:ICE];
    
    
    MyBookListAPI *myBookListApi = nil;
  
    if (self.bid) {
        myBookListApi = [[MyBookListAPI alloc]initWithCommunityid:bid limit:self.limit skip:self.skip];
        myBookListApi.appointmentListType = ProjectAppointmentList;;
    }else{
        myBookListApi = [[MyBookListAPI alloc]initWithlimit:self.limit skip:self.skip];
        myBookListApi.appointmentListType = PersonAppointmentList;
    }
    
    [myBookListApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        [self doneLoadingTableViewData];
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        NSDictionary *content = result[@"content"];
        if (![ISNull isNilOfSender:content] && [result[@"result"] intValue] == 0) {
            NSArray *list ;
            if (self.bid) {
                list = content[@"appointments"];
            }else{
                list = content[@"appointmentId"];
            }
            if (![ISNull isNilOfSender:list]) {
                for (NSDictionary *dic in list) {
                    AppointmentModel *appointmentModel = [AppointmentModel mj_objectWithKeyValues:dic];
                    [self.dataList addObject:appointmentModel];
                }
            }
            
            
            if (list.count < [self.limit integerValue]) {
                [self loadAll];
            }else{
                [self resetLoadAll];
            }
            
            if (self.dataList.count == 0) {
                self.tv.emptyDataSetSource = self;
                self.tv.emptyDataSetDelegate = self;
            }
            [self.tv reloadData];
            
        }else{
        
            [self presentFailureTips:result[@"message"]];
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


#pragma mark-tableview delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    HouseBookCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HouseBookCell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (self.dataList.count > indexPath.row) {
        
        AppointmentModel *appointmentModel = self.dataList[indexPath.row];
        cell.data = appointmentModel;
    }
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 106;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (self.dataList.count > indexPath.row) {
        AppointmentModel *appointmentMdoel = self.dataList[indexPath.row];
        
        self.currentRow = indexPath.row;
//        self.currentIndexPath = indexPath;
        MyBookDetailController *detailViewController = [MyBookDetailController spawn];
        
        detailViewController.appointmentModel = appointmentMdoel;
        
        [self.navigationController pushViewController:detailViewController animated:YES];
    }

}

#pragma mark - empty

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

//
//  CollectHouseViewController.m
//  ZTFCustomer
//
//  Created by ly on 16/11/4.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "CollectHouseViewController.h"
#import "CollectHouseCell.h"
#import "HouseDetailController.h"
#import "HouseTypeDetailController.h"


@interface CollectHouseViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>
@property (weak, nonatomic) IBOutlet UITableView *tv;
@property (weak, nonatomic) IBOutlet UIButton *collectHouseBtn;
@property (weak, nonatomic) IBOutlet UIButton *collectHouseTypeBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineLeftDis;
@property (weak, nonatomic) IBOutlet UIView *emptyView;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (nonatomic, strong) NSMutableArray *houseArray;
@property (nonatomic, strong) NSMutableArray *houseTyperray;
@property (nonatomic, copy) NSString *skip;
@property (nonatomic, copy) NSString *limit;

@end

@implementation CollectHouseViewController
+(instancetype)spawn{
    return [self loadFromStoryBoard:@"PersonalCenter"];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    HIDETABBAR;
}

- (NSMutableArray *)houseArray{
    if (!_houseArray){
        _houseArray = [NSMutableArray array];
    }
    return _houseArray;
}

- (NSMutableArray *)houseTyperray{
    if (!_houseTyperray){
        _houseTyperray = [NSMutableArray array];
    }
    return _houseTyperray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.collectHouseBtn setTitleColor:BLUE_TEXTCOLOR forState:UIControlStateSelected];
    [self.collectHouseTypeBtn setTitleColor:BLUE_TEXTCOLOR forState:UIControlStateSelected];
    self.lineView.backgroundColor = BLUE_TEXTCOLOR;
    
    self.navigationItem.title = @"我的收藏";
    self.navigationItem.leftBarButtonItem = [AppTheme backItemWithHandler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [self.tv tableViewRemoveExcessLine];
    [self setHeaderAndFooter];
    [self.tv registerNib:[UINib nibWithNibName:@"CollectHouseCell" bundle:nil] forCellReuseIdentifier:@"CollectHouseCell"];
    
    
    self.skip = @"0";
    self.limit = @"10";
    
    [self initloading];
    [self registerNoti];
}

-(void)registerNoti{
    
    //取消收藏楼盘
    [self fk_observeNotifcation:@"CANCELCOLLECTSUCCESS" usingBlock:^(NSNotification *note) {
        HousesModel *housesModel = (HousesModel *)note.object;
        [self.houseArray removeObject:housesModel];
        if (self.houseArray.count == 0) {
            self.tv.emptyDataSetSource = self;
            self.tv.emptyDataSetDelegate = self;
        }
        [self.tv reloadData];
        
    }];
    
    //重新收藏楼盘
    [self fk_observeNotifcation:@"COLLECTSUCCESS" usingBlock:^(NSNotification *note) {
        HousesModel *housesModel = (HousesModel *)note.object;
        [self.houseArray removeObject:housesModel];
        [self.houseArray insertObject:housesModel atIndex:0];
        if (self.houseArray.count == 0) {
            self.tv.emptyDataSetSource = self;
            self.tv.emptyDataSetDelegate = self;
        }
        [self.tv reloadData];
    }];
    
    //取消收藏户型
    [self fk_observeNotifcation:@"CANCELCOLLECTHOUSETYPESUCCESS" usingBlock:^(NSNotification *note) {
        
        HouseTypeModel *houseypeModel = (HouseTypeModel *)note.object;
        [self.houseTyperray removeObject:houseypeModel];
        

        if (self.houseTyperray.count == 0) {
            self.tv.emptyDataSetSource = self;
            self.tv.emptyDataSetDelegate = self;
        }

        [self.tv reloadData];
        
    }];
    //重新收藏户型
    [self fk_observeNotifcation:@"COLLECTHOUSETYPESUCCESS" usingBlock:^(NSNotification *note) {
        HouseTypeModel *houseypeModel = (HouseTypeModel *)note.object;
        [self.houseTyperray removeObject:houseypeModel];
        [self.houseTyperray insertObject:houseypeModel atIndex:0];
        
        if (self.houseTyperray.count == 0) {
            self.tv.emptyDataSetSource = self;
            self.tv.emptyDataSetDelegate = self;
        }
        
        [self.tv reloadData];
    }];
    
}

#pragma mark-loadData

-(void)loadNewData{

    self.skip = @"0";
    
    if (self.collectHouseBtn.selected){
        [self.houseArray removeAllObjects];
        
        
    }else{
        [self.houseTyperray removeAllObjects];
        
        
    }

    [self loadData];
}

-(void)loadMoreData{
    
    self.skip = [NSString stringWithFormat:@"%d",[self.skip intValue] + [self.limit intValue]];
    
    [self loadData];
}

-(void)loadData{
    
    [[BaseNetConfig shareInstance]configGlobalAPI:ICE];
    CollectListAPI *collectListApi = [[CollectListAPI alloc]initWithSlip:self.skip limit:self.limit];
    if (self.collectHouseBtn.selected){
        collectListApi.collectListType = ProjectCollectListType;
    }else{
        collectListApi.collectListType = HouseTypeCollectListType;
    }
    
    [collectListApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self doneLoadingTableViewData];
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        NSLog(@"%@",result);
        NSDictionary *content = result[@"content"];
        if (![ISNull isNilOfSender:content] && [result[@"code"] intValue] == 0) {
            if (self.collectHouseBtn.selected){
                NSArray *favorite = content[@"favorite"];
                for (NSDictionary *dic in favorite) {
                    HousesModel *housesModel = [HousesModel mj_objectWithKeyValues:dic];
                    [self.houseArray addObject:housesModel];
                }
                
                if (self.houseArray.count == 0) {
                    self.tv.emptyDataSetSource = self;
                    self.tv.emptyDataSetDelegate = self;
                }
                
                if (favorite.count < [self.limit intValue]) {
                    [self loadAll];
                }else{
                    [self resetLoadAll];
                }
                if (self.collectHouseBtn.selected == YES) {
                    [self.tv reloadData];
                }
                
                
            }else{
                
                NSArray *favorite = content[@"favorite"];
                for (NSDictionary *dic in favorite) {
                    HouseTypeModel *housestypeModel = [HouseTypeModel mj_objectWithKeyValues:dic];
                    housestypeModel.mobile = housestypeModel.project.tel;
                    [self.houseTyperray addObject:housestypeModel];
                }
                
                if (self.houseTyperray.count == 0) {
                    self.tv.emptyDataSetSource = self;
                    self.tv.emptyDataSetDelegate = self;
                }
                
                if (favorite.count < [self.limit intValue]) {
                    [self loadAll];
                }else{
                    [self resetLoadAll];
                }
                if (self.collectHouseTypeBtn.selected == YES) {
                    [self.tv reloadData];
                }
            }
            
        }else{
            if (self.houseArray.count == 0) {
                self.tv.emptyDataSetSource = self;
                self.tv.emptyDataSetDelegate = self;
            }
             [self.tv reloadData];
            [self presentFailureTips:result[@"message"]];
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self doneLoadingTableViewData];
        if (self.houseArray.count == 0) {
            self.tv.emptyDataSetSource = self;
            self.tv.emptyDataSetDelegate = self;
        }
        [self.tv reloadData];
        [self presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
    }];
}



#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.collectHouseBtn.selected){
       
        return  self.houseArray.count;
        
    }else{

        return self.houseTyperray.count;
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CollectHouseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CollectHouseCell"];
    
    if (self.collectHouseBtn.selected){
        if (self.houseArray.count > indexPath.row){
            HousesModel *houseModel = self.houseArray[indexPath.row];
            cell.data = houseModel;
        }
    }else{
        if (self.houseTyperray.count > indexPath.row){
            HouseTypeModel *houseTypeModel = self.houseTyperray[indexPath.row];
            cell.data = houseTypeModel;
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.collectHouseBtn.selected){
        if (self.houseArray.count > indexPath.row){
            
            HousesModel *houseModel = self.houseArray[indexPath.row];
            HouseDetailController *houseDetailCon = [HouseDetailController spawn];
            houseDetailCon.houseModel = houseModel;
            houseDetailCon.isCollect = YES;
            
            [self.navigationController pushViewController:houseDetailCon animated:YES];
            
        }
    }else{
        if (self.houseTyperray.count > indexPath.row){
            
            HouseTypeModel *houseTypeModel = self.houseTyperray[indexPath.row];
            HouseTypeDetailController *houseTypeDetailCon = [HouseTypeDetailController spawn];
            houseTypeDetailCon.isCollect = YES;
            houseTypeDetailCon.houseTypeModel = houseTypeModel;
            houseTypeDetailCon.projectId = houseTypeModel.project_id;
            
            [self.navigationController pushViewController:houseTypeDetailCon animated:YES];
        }
    }
}

#pragma mark-click

- (IBAction)houseBtnAction:(UIButton *)btn {
    if (btn.selected){
        return;
    }
    
    if (btn.tag == 1){
        //收藏房源
        self.lineLeftDis.constant = 0;
        self.collectHouseBtn.selected = YES;
        self.collectHouseTypeBtn.selected = NO;
        if (self.houseArray.count == 0) {
            [self initloading];
        }else{
            [self.tv reloadData];
        }
        
        
    }else{
        //收藏户型
        self.lineLeftDis.constant = SCREENWIDTH / 2.0;
        self.collectHouseBtn.selected = NO;
        self.collectHouseTypeBtn.selected = YES;
        if (self.houseTyperray.count == 0) {
            [self initloading];
        }else{
            [self.tv reloadData];
        }
        
    }
    
}

#pragma mark-DZNEmptyDelegte
-(UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    return [UIImage imageNamed:@"noactivity"];
}
-(NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    NSString *text = @"还没有收藏的楼盘";
    if (self.collectHouseTypeBtn.selected) {
        text = @"还没有收藏的户型";
    }
    NSAttributedString *attri = [[NSAttributedString alloc]initWithString:text attributes:@{NSForegroundColorAttributeName:[UIColor darkGrayColor],NSFontAttributeName:[UIFont systemFontOfSize:14] }];
    return attri;
}

@end

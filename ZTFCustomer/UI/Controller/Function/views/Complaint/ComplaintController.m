//
//  ComplaintController.m
//  ztfCustomer
//
//  Created by mac on 16/9/13.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "ComplaintController.h"
#import "ComplaintDetailController.h"
#import "RepairCell.h"

@interface ComplaintController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *telView;
@property (weak, nonatomic) IBOutlet UILabel *telLbl;
@property (weak, nonatomic) IBOutlet UITableView *tv;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property(retain,nonatomic) NSString *communityTel;

@end

@implementation ComplaintController
+(instancetype)spawn{
    return [ComplaintController loadFromStoryBoard:@"Function"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self navigationBar];
    self.telView.backgroundColor = BLUE_VIEWCOLOR;
    [self.tv registerNib:@"RepairCell" identifier:@"RepairCell"];
    [self.tv tableViewRemoveExcessLine];
    self.communityTel=@"0";
    [self loadCommunity];
    [self loadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:@"REFRESH_COMPLAINT" object:nil];
    
    //统计数据
    [self statisticsAction];
}

//统计数据
- (void)statisticsAction{
    UserModel *user = [[LocalData shareInstance]getUserAccount];
    Community *community = [STICache.global objectForKey:[NSString stringWithFormat:@"%@_crcc",user.mobile]];
    StatisticsGlobalAPI *statisticsApi = [[StatisticsGlobalAPI alloc] initWithtypeId:@"7" communityId:community.bid];
    [[BaseNetConfig shareInstance]configGlobalAPI:ICE];
    [statisticsApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (![AppDelegate sharedAppDelegate].tabController.tabBarHidden) {
        [[AppDelegate sharedAppDelegate].tabController setTabBarHidden:YES animated:YES];
    }
    
}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(void)navigationBar{
    
    self.titleName = (NSString *)self.data;
    
    self.navigationItem.title = self.titleName;
    self.navigationItem.leftBarButtonItem = [AppTheme backItemWithHandler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark-load data
//加载小区信息
-(void)loadCommunity
{
     UserModel *userModel = [[LocalData shareInstance]getUserAccount];
    Community *community =[STICache.global objectForKey:[NSString stringWithFormat:@"%@_crcc",userModel.mobile]];
    if (community) {
        
        NSString *bid = community.bid;
        
        if (bid) {
            
            [[BaseNetConfig shareInstance]configGlobalAPI:KAKATOOL];
            CommunitySearchAPI *communitySearchApi = [[CommunitySearchAPI alloc]initWithBid:bid];
            [communitySearchApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
                NSDictionary *result = (NSDictionary *)request.responseJSONObject;
                
                if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
                    
                    id remoteCommunity = [result objectForKey:@"community"];
                    
                    if ([remoteCommunity isKindOfClass:[NSDictionary class]]) {
                        
                        self.communityTel = [remoteCommunity objectForKey:@"tel"];
                    }
                    else if ([remoteCommunity isKindOfClass:[NSArray class]]){
                        
                        NSArray *arr = (NSArray *)remoteCommunity;
                        
                        if ([arr count]>0) {
                            NSDictionary *firstCommunity = [arr objectAtIndex:0];
                            self.communityTel = [firstCommunity objectForKey:@"tel"];
                        }
                    }
                    if ([self.communityTel isEqualToString:@"0"]==NO) {
                        
                        self.telLbl.text = [NSString stringWithFormat:@"立即拨打电话%@",self.communityTel];
                    }
                    else{
                        self.telLbl.text =@"暂时不提供电话";
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
        
    }
}
-(void)loadData{
    
    [[BaseNetConfig shareInstance]configGlobalAPI:WETOWN];
    ComplaintListAPI *complaintListApi = [[ComplaintListAPI alloc]init];
    [complaintListApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        
        if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
            [self.dataArray removeAllObjects];
            NSArray *arr = result[@"list"];
            for (NSDictionary *dic in arr) {
                ComplaintModel *model = [ComplaintModel mj_objectWithKeyValues:dic];
                [self.dataArray addObject:model];
            }
            [self.tv reloadData];
            
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

#pragma mark-click
//拨打电话
- (IBAction)telClick:(id)sender {
    if ([self.communityTel isEqualToString:@"0"]==NO) {
        
        [UIAlertView bk_showAlertViewWithTitle:@"拨打电话" message:self.communityTel cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                NSString *callTel = [NSString stringWithFormat:@"tel://%@",self.communityTel];
                callTel = [callTel stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSURL *callUrl = [NSURL URLWithString:callTel];
                if (callUrl) {
                    [[UIApplication sharedApplication] openURL:callUrl];
                }
            }
        }];
        
    }
}
//投诉点击
- (IBAction)complaintClick:(id)sender {
 ComplaintDetailController *detail =[[ComplaintDetailController alloc] initWithMainType:@"1" Order:nil];
    [self.navigationController pushViewController:detail animated:YES];
}
//建议点击
- (IBAction)adviceClick:(id)sender {
    ComplaintDetailController *detail =[[ComplaintDetailController alloc] initWithMainType:@"2" Order:nil];
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark - table delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CELLINDENTITY=@"RepairCell";
    
    RepairCell *cell = (RepairCell *)[tableView dequeueReusableCellWithIdentifier:CELLINDENTITY forIndexPath:indexPath];
    
    ComplaintModel *item =  self.dataArray[indexPath.row];
    if (item) {
        cell.complaintModel = item;
//        [cell prepareData:item];
        
        NSString *type = item.type;
        if ([type isEqualToString:@"1"]) {
            
            cell.lblNo.text = [NSString stringWithFormat:@"投诉单号:%d",[item.id intValue]];
            
        }
        else{
            cell.lblNo.text = [NSString stringWithFormat:@"建议单号:%d",[item.id intValue]];
        }
        
    }
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 89.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row<self.dataArray.count) {
        
        ComplaintModel *item =[self.dataArray objectAtIndex:indexPath.row];
        
        if (item) {
            
            NSString *maintype = item.type;
            if (maintype) {
                ComplaintDetailController *detail =[[ComplaintDetailController alloc] initWithMainType:maintype Order:item];
               
                [self.navigationController pushViewController:detail animated:YES];
                
            }
            
            
        }
        
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

//
//  SelectCommunityController.m
//  EstateBiz
//
//  Created by mac on 16/7/1.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "SelectCommunityController.h"

@interface SelectCommunityController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tv;
@property (weak, nonatomic) IBOutlet UIView *emptyView;

@property (nonatomic, strong) NSMutableArray *dataArray;


@end

@implementation SelectCommunityController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = VIEW_BG_COLOR;
    [self.tv tableViewRemoveExcessLine];
    [self setNavigationBar];
    
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark-懒加载
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
#pragma mark-navibar
-(void)setNavigationBar{
    self.navigationItem.title = @"选择小区";
    self.navigationItem.leftBarButtonItem = [AppTheme backItemWithHandler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark-loadData
-(void)loadData{
    [self presentLoadingTips:nil];
    [[BaseNetConfig shareInstance]configGlobalAPI:WETOWN];
    SelectCommunityAPI *selectCommunityApi = [[SelectCommunityAPI alloc]init];
    [selectCommunityApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        
        if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
            [self dismissTips];
            NSArray *communitys = [result objectForKey:@"communitylist"];
            if (![ISNull isNilOfSender:communitys]) {
                
                self.dataArray = [NSMutableArray arrayWithArray:communitys];
                
                if (self.dataArray.count==0) {
                    self.emptyView.hidden=NO;
                    self.tv.hidden=YES;
                }
                else{
                    self.emptyView.hidden=YES;
                    self.tv.hidden=NO;
                    [self.tv reloadData];
                }
            }
            else{
                self.emptyView.hidden=NO;
                self.tv.hidden=YES;
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

#pragma mark - table delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CELLINDENTITY=@"SELECTCELL";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLINDENTITY];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELLINDENTITY] ;
    }
    
    NSDictionary *item = [self.dataArray objectAtIndex:indexPath.row];
    if (item) {
        cell.textLabel.text = [item objectForKey:@"name"];
    }
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
    if (indexPath.row<self.dataArray.count) {
        
        NSDictionary *item =[self.dataArray objectAtIndex:indexPath.row];
        
        if (item) {

                self.selectCommunity(item);

            
            [self.navigationController popViewControllerAnimated:YES];
            
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

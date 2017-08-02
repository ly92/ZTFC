//
//  SelectRepairSubtypeController.m
//  WeiTown
//
//  Created by Ender on 8/29/15.
//  Copyright (c) 2015 Hairon. All rights reserved.
//

#import "SelectRepairSubtypeController.h"
@interface SelectRepairSubtypeController ()
@property (retain, nonatomic) IBOutlet UITableView *tv;
@property (retain, nonatomic) IBOutlet UILabel *lblNoResult;
@property(nonatomic,retain)NSString *maintype;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation SelectRepairSubtypeController


- (instancetype)initWithMainType:(NSString *)aType
{
    self = [super init];
    if (self) {
        self.maintype = aType;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self navigationBar];
    
    [self.tv tableViewRemoveExcessLine];
    
    [self prepareLayout];
    
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)navigationBar{
 
    self.navigationItem.title = @"维修类型";
    
    self.navigationItem.leftBarButtonItem = [AppTheme backItemWithHandler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

#pragma mark - 布局
-(void)prepareLayout{
    
//    if (IS_IPHONE_5) {
//        [self.tv fixYForIPhone5:NO addHight:YES];
//    }
    self.lblNoResult.hidden=YES;
    
}

#pragma mark - 数据
-(void)loadData{
    
    
    [self presentLoadingTips:nil];
    [[BaseNetConfig shareInstance]configGlobalAPI:WETOWN];
    GetRepairSubtypeAPI *getRepairSubtypeApi = [[GetRepairSubtypeAPI alloc]initWithMaintype:self.maintype];
    [getRepairSubtypeApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        
        if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
            [self dismissTips];
            
            NSArray *arr = result[@"list"];
            if (![ISNull isNilOfSender:arr]) {
                for (NSDictionary *dic in arr) {
                    RepairSubtypeModel *subtypeModel = [RepairSubtypeModel mj_objectWithKeyValues:dic];
                    [self.dataArray addObject:subtypeModel];
                }
                
                if (self.dataArray.count==0) {
                    self.lblNoResult.hidden=NO;
                    self.tv.hidden=YES;
                }
                else{
                    
                    [self.tv reloadData];
                }
            } else{
                self.lblNoResult.hidden=NO;
                self.tv.hidden=YES;
            }
            
            [self.tv reloadData];
        }else{
            self.lblNoResult.hidden=NO;
            self.tv.hidden=YES;
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELLINDENTITY];
    }
    RepairSubtypeModel *item = [self.dataArray objectAtIndex:indexPath.row];
    if (item) {
        cell.textLabel.text = item.name;
    }
    cell.imageView.image=[UIImage imageNamed:@"repair_public"];
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row<self.dataArray.count) {
        
        RepairSubtypeModel *item =[self.dataArray objectAtIndex:indexPath.row];
        
        if (item) {
            
            self.selectSubtype(item);
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        
    }
    
}

@end

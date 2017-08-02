//
//  SelectCityController.m
//  ZTFCustomer
//
//  Created by mac on 16/9/23.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "SelectCityController.h"
#import "CityListCell.h"
#import "ChineseString.h"
#import "CityDatabase.h"

@interface SelectCityController ()

@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UIView *locationView;
@property (weak, nonatomic) IBOutlet UITableView *tv;

@property (weak, nonatomic) IBOutlet UILabel *currentCity;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;

@property (nonatomic, copy) NSString *searchword;

@property (nonatomic, strong) NSMutableArray *itemsArray;
@property (nonatomic, strong) NSArray *items;

@property (nonatomic, assign) BOOL finishLoaction;  // 完成定位标识

@end

@implementation SelectCityController

+(instancetype)spawn{
    return [self loadFromStoryBoard:@"Houses"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavigationBar];
    
    self.searchView.clipsToBounds = YES;
    self.searchView.layer.cornerRadius = 2;
    self.searchView.layer.borderColor = VIEW_BG_COLOR.CGColor;
    self.searchView.layer.borderWidth = 1;
    
    self.tv.separatorColor = [AppTheme lineColor];
    
    [self.tv tableViewRemoveExcessLine];
    [self.tv registerNib:[CityListCell nib] forCellReuseIdentifier:@"CityListCell"];
    
    UserModel *user = [[LocalData shareInstance]getUserAccount];
    RegionModel *selectVity = [STICache.global objectForKey:[NSString stringWithFormat:@"crcclocation_selectcity_%@",user.mobile]];
    
    if (selectVity.id == nil )
    {
        [self currentCitySelect:nil];
    }
    else
    {
        self.currentCity.text =[NSString stringWithFormat:@"当前：%@", [AppLocation sharedInstance].selectCity.name];
    }
    
//     NSArray *arr = [STICache.global objectForKey:@"PROVINCEDATA"];
    
//    if (![ISNull isNilOfSender:arr]) {
////        NSArray *arr = [STICache.global objectForKey:@"SELECTCITY"];
//        self.items = [ChineseString getChineseStringArr:arr];
//        
//        [self.tv reloadData];
//    }else{
        [self loadData];
//    }
    
    
}

-(NSMutableArray *)itemsArray{
    if (!_itemsArray) {
        _itemsArray = [NSMutableArray array];
    }
    return _itemsArray;
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

#pragma mark-navibar
-(void)setNavigationBar{
    
    self.navigationItem.title = @"选择城市";
    self.navigationItem.leftBarButtonItem = [AppTheme backItemWithHandler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
}

-(void)loadData{
    [self presentLoadingTips:nil];
    [[BaseNetConfig shareInstance]configGlobalAPI:ICE];
    GetCityListAPI *getCityListApi = [[GetCityListAPI alloc]init];
    [getCityListApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        [self dismissTips];
        [self.itemsArray removeAllObjects];
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        NSDictionary *content = result[@"content"];
        if (![ISNull isNilOfSender:content] && [result[@"code"] intValue] == 0) {
            if (![ISNull isNilOfSender:content]) {
                NSArray *list = content[@"regions"];
                for (NSDictionary *dic in list) {
                    RegionModel *region = [RegionModel mj_objectWithKeyValues:dic];
                    
                    [self.itemsArray addObject:region];
                }
                
                self.items = [ChineseString getChineseStringArr:self.itemsArray];
                
                [STICache.global setObject:self.itemsArray forKey:@"PROVINCEDATA"];
                
                [self.tv reloadData];

            }
            
        }else{
            [self presentFailureTips:result[@"message"]];
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
- (IBAction)searchbuttonClick:(id)sender {
    [self.view endEditing:YES];
    [self loadData];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray * array = [self.items objectAtIndex:section];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CityListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CityListCell" forIndexPath:indexPath];
    NSArray * array = [self.items objectAtIndex:indexPath.section];
    cell.data = [array objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ( self.items.count > 0 )
    {
        return [self.items count] - 1;
        
    }
    else
    {
        return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[self.items lastObject] objectAtIndex:section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [self.items lastObject];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray * array = [self.items objectAtIndex:indexPath.section];
    
    ChineseString * string = [array objectAtIndex:indexPath.row];
    RegionModel * region = string.data;
    
    [AppLocation sharedInstance].selectCity = region;
    
    self.whenUpdated(region);
//    PERFORM_BLOCK_SAFELY(self.whenUpdated, region);
    [self.navigationController popViewControllerAnimated:YES];
}

// 点击选择定位城市
- (IBAction)currentCitySelect:(id)sender
{
    if ( ![AppLocation canLocate] )
    {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"定位失败" message:@"请检查是否开启定位" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    if ( [AppLocation sharedInstance].currentCity.id )
    {
        self.whenUpdated([AppLocation sharedInstance].currentCity);
//        PERFORM_BLOCK_SAFELY(self.whenUpdated, [AppLocation sharedInstance].currentCity);
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self presentLoadingTips:nil];
        @weakify(self);
        [[AppLocation sharedInstance] locateThen:^(RegionModel *city) {
            @strongify(self);
            [self dismissTips];
            if ( city )
            {
                self.currentCity.text = [NSString stringWithFormat:@"当前：%@",city.name];;
                self.finishLoaction = YES;
            }else{
                [self presentFailureTips:@"定位失败"];
            }
        }];
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

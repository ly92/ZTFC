//
//  SearchCommunityController.m
//  EstateBiz
//
//  Created by wangshanshan on 16/6/20.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "SearchCommunityController.h"
#import "SearchCommunityResultController.h"
#import "SearchWordCell.h"

@interface SearchCommunityController ()<UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SearchCommunityResultControllerDelegate,UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *hotLbl;

@property (weak, nonatomic) IBOutlet UICollectionView *hotTable;
@property (weak, nonatomic) IBOutlet UIView *hotView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hotViewH;
@property (weak, nonatomic) IBOutlet UICollectionView *historyTable;

@property (weak, nonatomic) IBOutlet UIView *historyView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *historyViewH;

@property (weak, nonatomic) IBOutlet UITableView *tv;

@property (strong , nonatomic) NSMutableArray *communityArray;

@property (nonatomic, strong) NSMutableArray *hotArr;
@property (nonatomic, strong) NSMutableArray *historyArr;
@property (nonatomic, strong) UITextField *searchTxt;
@property (nonatomic, copy) NSString *searchword;

@end

@implementation SearchCommunityController

+(instancetype)spawn{
    return [SearchCommunityController loadFromStoryBoard:@"Home"];
}

-(NSMutableArray *)hotArr{
    if (!_hotArr) {
        _hotArr = [NSMutableArray array];
    }
    return _hotArr;
}

-(NSMutableArray *)historyArr{
    if (!_historyArr) {
        _historyArr = [NSMutableArray array];
    }
    return _historyArr;
}

-(NSMutableArray *)communityArray{
    if (!_communityArray) {
        _communityArray = [NSMutableArray array];
    }
    return _communityArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = VIEW_BG_COLOR;
    
    [self setNavigationbar];
    [self hideKeyBoard];
    
//    [self.historyArr removeAllObjects];
//    [self.historyArr addObjectsFromArray:[LocalData getCommunitySearchOfHistoryRecord]];
//    
//    if (self.historyArr.count != 0){
//        NSInteger row = self.historyArr.count / 2;
//        if (self.historyArr.count % 2 != 0){
//            row ++;
//        }
//        self.historyView.hidden = NO;
//        self.historyViewH.constant = row * 30 + 66;
//    }else{
//        self.historyViewH.constant = 0;
//        self.historyView.hidden = YES;
//    }
//    
//    [self.hotTable registerNib:[SearchWordCell nibWithName:@"SearchWordCell"] forCellWithReuseIdentifier:@"SearchWordCell"];
//    [self.historyTable registerNib:[SearchWordCell nibWithName:@"SearchWordCell"] forCellWithReuseIdentifier:@"SearchWordCell"];
    
//    [self.searchTxt becomeFirstResponder];
    //加载热门搜索
//    [self loadHotSearchList];
    
    [self.tv tableViewRemoveExcessLine];
    [self.tv registerClass:[UITableViewCell class] forCellReuseIdentifier:@"SELECTCELL"];
    
    [self loadCommunityList];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    HIDETABBAR;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark-navibar
-(void)setNavigationbar{
//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 27,SCREENWIDTH-80 , 30)];
//    view.backgroundColor = [UIColor blackColor];
//    
//    view.clipsToBounds = YES;
//    view.layer.cornerRadius = 5;
//    
//    UIImageView *searchImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 7, 15, 15)];
//    searchImg.backgroundColor = [UIColor clearColor];
//    searchImg.image = [UIImage imageNamed:@"d1_search"];
//    [view addSubview:searchImg];
//    
//    
//    if (!(GT_IOS7)){
//        self.searchTxt = [[UITextField alloc]initWithFrame:CGRectMake(30, 5,SCREENWIDTH-110 , 30)];
//    }else{
//        self.searchTxt = [[UITextField alloc]initWithFrame:CGRectMake(30, 0,SCREENWIDTH-110 , 30)];
//    }
//    self.searchTxt.placeholder = @"搜索小区";
//    self.searchTxt.backgroundColor = [UIColor clearColor];
//    //187 194 199
//    [self.searchTxt setValue:RGBACOLOR(187, 194, 199, 1.0) forKeyPath:@"_placeholderLabel.textColor"];
//    [self.searchTxt setValue:[UIFont systemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
//    self.searchTxt.borderStyle =UITextBorderStyleNone;
//    self.searchTxt.backgroundColor = [UIColor blackColor];
//    self.searchTxt.delegate = self;
//    self.searchTxt.textColor = NAV_SEARCHTEXTCOLOR ;
//
//    
//    self.searchTxt.clearButtonMode = UITextFieldViewModeWhileEditing;
//    self.searchTxt.returnKeyType = UIReturnKeySearch;
//    
//    [view addSubview:self.searchTxt];
//    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
//                                             initWithCustomView:view];
    
//    self.navigationItem.rightBarButtonItem = [AppTheme itemWithContent:@"取消" handler:^(id sender) {
//        [self.navigationController popViewControllerAnimated:YES];
//    }];
    
    self.navigationItem.title = @"选择小区";
    
    self.navigationItem.leftBarButtonItem = [AppTheme backItemWithHandler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    
}


#pragma mark-hideKeyBoard
-(void)hideKeyBoard{
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap
{
    [self.searchTxt resignFirstResponder];
}

#pragma mark - 获取小区列表
-(void)loadCommunityList{
    
    [self presentLoadingTips:nil];
    [[BaseNetConfig shareInstance]configGlobalAPI:ICE];
    
    LoadCommunityListAPI *loadCommunityListApi = [[LoadCommunityListAPI alloc]init];
    [loadCommunityListApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self dismissTips];
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        if (![ISNull isNilOfSender:result] && [result[@"code"] intValue] == 0) {
           
            NSDictionary *content = [result objectForKey:@"content"];
            [self prepareDataWithDic:content];
            
        }else{
            [self presentFailureTips:result[@"message"]];
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
    }];
    
    
}

-(void)prepareDataWithDic:(NSDictionary *)result{
    
    if (![ISNull isNilOfSender:result]) {
        NSArray *communitys = result[@"communitys"];
        for (NSDictionary *dic in communitys) {
            Community *community = [Community mj_objectWithKeyValues:dic];
            
            [self.communityArray addObject:community];
        }
        [self.tv reloadData];
    }
    
    
}

#pragma mark-热门搜索

- (void)loadHotSearchList{
    [self presentLoadingTips:nil];
    [[BaseNetConfig shareInstance] configGlobalAPI:WETOWN];
    AuthoriseCommunityAPI *authoriseCommunityApi = [[AuthoriseCommunityAPI alloc]init];
    [authoriseCommunityApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        [self dismissTips];
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
            
            NSArray *list = result[@"list"];
            if (![ISNull isNilOfSender:list]) {
                for (NSDictionary *dic in list) {
                    [self.hotArr addObject:[Community mj_objectWithKeyValues:dic]];
                }
                if (self.hotArr.count == 0) {
                    [self loadNearCommunity];
                }else{
                    [self refreshHotTable];
                    
                    self.hotLbl.text = @"授权小区";
                }
            }else{
                 [self loadNearCommunity];
            }
            [self.hotTable reloadData];
            
        }else{
            [self loadNearCommunity];
//            [self.hotTable reloadData];
//             [self presentFailureTips:result[@"reason"]];
        }

    } failure:^(__kindof YTKBaseRequest *request) {
        [self loadNearCommunity];
//        [self refreshHotTable];
//        if (request.responseStatusCode == 0) {
//            [self presentFailureTips:@"网络不可用，请检查网络链接"];
//        }else{
//            [self presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
//        }
    }];
    
}

-(void)refreshHotTable{
    if (self.hotArr.count != 0){
        NSInteger row = self.hotArr.count / 2;
        if (self.hotArr.count % 2 != 0){
            row ++;
        }
        self.hotView.hidden = NO;
        self.hotViewH.constant = row * 30 + 70;
    }else{
        self.hotViewH.constant = 0;
        self.hotView.hidden = YES;
    }

}

-(void)loadNearCommunity{
    //获取当前位置
    Location *location = [AppLocation sharedInstance].location;
    NSString * lon = [NSString stringWithFormat:@"%@",location.lon];
    NSString * lat = [NSString stringWithFormat:@"%@",location.lat];
    
    [self presentLoadingTips:nil];
    [[BaseNetConfig shareInstance] configGlobalAPI:KAKATOOL];
    NearCommunityAPI *nearCommunityApi = [[NearCommunityAPI alloc]initWithLongitude:lon latitude:lat];
    
    [nearCommunityApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        [self dismissTips];
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
            NSDictionary *nearCommunity = result[@"community"];
            
            if (![ISNull isNilOfSender:nearCommunity]) {
                 UserModel *userModel = [[LocalData shareInstance]getUserAccount];
                Community *community = [Community mj_objectWithKeyValues:nearCommunity];
                [STICache.global setObject:community forKey:[NSString stringWithFormat:@"%@_crcc",userModel.mobile]];
                
                
                [self.hotArr addObject:community];
                self.hotLbl.text = @"附近小区";
                
                if (self.hotArr.count != 0){
                    NSInteger row = self.hotArr.count / 2;
                    if (self.hotArr.count % 2 != 0){
                        row ++;
                    }
                    self.hotView.hidden = NO;
                    self.hotViewH.constant = row * 30 + 70;
                }else{
                    self.hotViewH.constant = 0;
                    self.hotView.hidden = YES;
                }
                
            }
            [self.hotTable reloadData];
            
        }else{
            [self refreshHotTable];
             [self presentFailureTips:result[@"reason"]];
        }
        
        
    } failure:^(__kindof YTKBaseRequest *request) {
        [self refreshHotTable];
        if (request.responseStatusCode == 0) {
            [self presentFailureTips:@"网络不可用，请检查网络链接"];
        }else{
            [self presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
        }
    }];

}

#pragma mark-click

- (IBAction)deleteButtonClick:(id)sender {
    
    [self.view endEditing:YES];
    
    [LocalData removeCommunitySearchOfHistoryRecord];
    [self.historyArr removeAllObjects];
    [self.historyArr addObjectsFromArray:[LocalData getCommunitySearchOfHistoryRecord]];
    
    if (self.historyArr.count != 0){
        NSInteger row = self.historyArr.count / 2;
        if (self.historyArr.count % 2 != 0){
            row ++;
        }
        self.historyView.hidden = NO;
        self.historyViewH.constant = row * 30 + 66;
    }else{
        self.historyViewH.constant = 0;
        self.historyView.hidden = YES;
    }
    
    [self.historyTable reloadData];
}


#pragma mark- texrfield的代理方法

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self.searchTxt resignFirstResponder];
    
    self.searchword = textField.text;
    
    [self searchCommunity:self.searchword];
    
    return YES;
}

-(void)searchCommunity:(NSString *)searchWord{
    if (searchWord.length == 0) {
         [self presentFailureTips:@"请输入搜索内容"];
        return;
    }
    else {
        [self saveToLocalWithRecord:searchWord];
//        [self.historyTable reloadData];
    }
    
    SearchCommunityResultController * searchCommunity = [SearchCommunityResultController spawn];
    searchCommunity.delegate = self;
    searchCommunity.searchword = searchWord;
    [self.navigationController pushViewController:searchCommunity animated:YES];
    
}

#pragma mark-历史搜索缓存

//SearchListDelegate : 搜索历史关键字保存本地delegate回调
- (void)updateHistoryRecord:(NSString *)record
{
    [self saveToLocalWithRecord:record];
}

//保存历史关键字到本地
- (void)saveToLocalWithRecord:(NSString *)record
{
    if (record == nil && [record trim].length == 0) {
        return;
    }
    
    [LocalData updateCommunitySearchOfHistoryRecord:[record trim]];
    [self.historyArr removeAllObjects];
    [self.historyArr addObjectsFromArray:[LocalData getCommunitySearchOfHistoryRecord]];
    
    if (self.historyArr.count != 0){
        NSInteger row = self.historyArr.count / 2;
        if (self.historyArr.count % 2 != 0){
            row ++;
        }
        self.historyView.hidden = NO;
        self.historyViewH.constant = row * 30 + 66;
    }else{
        self.historyViewH.constant = 0;
        self.historyView.hidden = YES;
    }
    
    [self.historyTable reloadData];
}


#pragma mark-collection delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (collectionView == self.historyTable) {
        return self.historyArr.count;
    }else if (collectionView == self.hotTable) {
        return self.hotArr.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellId = @"SearchWordCell";
    SearchWordCell * cell = (SearchWordCell *) [collectionView dequeueReusableCellWithReuseIdentifier:CellId forIndexPath:indexPath];
    cell.isCommunity = YES;
    if (collectionView == self.hotTable){
        
        cell.data = self.hotArr[indexPath.row];
        
    }else{
        
        cell.searchWordLbl.text = self.historyArr[indexPath.row];
    }
    //    cell.backgroundColor = [UIColor redColor];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.searchTxt resignFirstResponder];
    
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    
    if(collectionView == self.hotTable){
        
        Community *community = self.hotArr[indexPath.row];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SELECTCOMMUNITY" object:community];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }
    
    else{
        NSString *searchword = @"";
        if (collectionView == self.historyTable) {
            searchword = [self.historyArr objectAtIndex:indexPath.row];
        }
        else {
            
            Community *searCard = self.hotArr[indexPath.row];
            if (searCard) {
                searchword = searCard.name;
            }
        }
        
        if ([searchword trim].length == 0) {
            return;
        }
        self.searchTxt.text = searchword;
        
        [self searchCommunity:searchword];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat w = (SCREENWIDTH - 55)/2;
    return CGSizeMake(w, 25);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0, 5, 5, 0);
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}


#pragma mark - tableview delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.communityArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CELLINDENTITY=@"SELECTCELL";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLINDENTITY];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELLINDENTITY] ;
    }
    
    if (self.communityArray.count > indexPath.row) {
        Community *item = [self.communityArray objectAtIndex:indexPath.row];
        if (item) {
            cell.textLabel.text = item.name;
        }
    }
   
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
    if (indexPath.row<self.communityArray.count) {
        
        Community *item =[self.communityArray objectAtIndex:indexPath.row];
        
        if (item) {
            
//            self.selectCommunity(item);
            
             [[NSNotificationCenter defaultCenter] postNotificationName:@"SELECTCOMMUNITY" object:item];
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        
    }
    
    
}

@end

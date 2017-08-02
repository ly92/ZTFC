//
//  SearchMemberCardController.m
//  EstateBiz
//
//  Created by wangshanshan on 16/6/17.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "SearchMemberCardController.h"
#import "SearchWordCell.h"
#import "SearchMemberCardResultController.h"

@interface SearchMemberCardController ()<UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SearchMemberCardResultControllerDelegate>


@property (weak, nonatomic) IBOutlet UICollectionView *hotTable;
@property (weak, nonatomic) IBOutlet UICollectionView *historyTable;
@property (weak, nonatomic) IBOutlet UIView *hotView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hotViewH;

@property (weak, nonatomic) IBOutlet UIView *historyView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *historyViewH;


@property (nonatomic, retain) NSMutableArray *hotArray;
@property (nonatomic, retain) NSMutableArray *historyArray;

@property (nonatomic, strong) UITextField *searchTxt;
@property (nonatomic, copy) NSString *searchword;

@end

@implementation SearchMemberCardController

+(instancetype)spawn{
    
    return [SearchMemberCardController loadFromStoryBoard:@"Home"];
    
}
#pragma mark - 懒加载
- (NSMutableArray *)hotArray{
    if (_hotArray == nil){
        _hotArray = [NSMutableArray array];
    }
    return _hotArray;
}

- (NSMutableArray *)historyArray{
    if (_historyArray == nil){
        _historyArray = [NSMutableArray array];
    }
    return _historyArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = VIEW_BG_COLOR;
    
    [self setNavigationbar];
    [self hideKeyBoard];
    
    [self.searchTxt becomeFirstResponder];
    
    
    [self.historyArray removeAllObjects];
    [self.historyArray addObjectsFromArray:[LocalData getMemberCardSearchOfHistoryRecord]];
    
    if (self.historyArray.count != 0){
        NSInteger row = self.historyArray.count / 2;
        if (self.historyArray.count % 2 != 0){
            row ++;
        }
        self.historyView.hidden = NO;
        self.historyViewH.constant = row * 30 + 66;
    }else{
        self.historyViewH.constant = 0;
        self.historyView.hidden = YES;
    }
    
    
    [self.hotTable registerNib:[SearchWordCell nibWithName:@"SearchWordCell"] forCellWithReuseIdentifier:@"SearchWordCell"];
    [self.historyTable registerNib:[SearchWordCell nibWithName:@"SearchWordCell"] forCellWithReuseIdentifier:@"SearchWordCell"];
    
    self.hotTable.backgroundColor = [UIColor whiteColor];
    self.historyTable.backgroundColor = [UIColor whiteColor];
    
    [self loadHotData];
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
-(void)setNavigationbar{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 27,SCREENWIDTH-80 , 30)];
    view.backgroundColor = [UIColor blackColor];
    
    view.clipsToBounds = YES;
    view.layer.cornerRadius = 5;
    
    UIImageView *searchImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 7, 15, 15)];
    searchImg.backgroundColor = [UIColor clearColor];
    searchImg.image = [UIImage imageNamed:@"d1_search"];
    [view addSubview:searchImg];
    
    
    if (!(GT_IOS7)){
        self.searchTxt = [[UITextField alloc]initWithFrame:CGRectMake(30, 5,SCREENWIDTH-110 , 30)];
    }else{
        self.searchTxt = [[UITextField alloc]initWithFrame:CGRectMake(30, 0,SCREENWIDTH-110 , 30)];
    }
    self.searchTxt.placeholder = @"搜索会员卡";
    self.searchTxt.backgroundColor = [UIColor clearColor];
    //187 194 199
    [self.searchTxt setValue:RGBACOLOR(187, 194, 199, 1.0) forKeyPath:@"_placeholderLabel.textColor"];
    [self.searchTxt setValue:[UIFont systemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    self.searchTxt.borderStyle =UITextBorderStyleNone;
    self.searchTxt.backgroundColor = [UIColor blackColor];
    self.searchTxt.delegate = self;
    self.searchTxt.textColor = NAV_SEARCHTEXTCOLOR ;

    
    self.searchTxt.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.searchTxt.returnKeyType = UIReturnKeySearch;
    
    [view addSubview:self.searchTxt];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithCustomView:view];
    
    self.navigationItem.rightBarButtonItem = [AppTheme itemWithContent:@"取消" handler:^(id sender) {
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

#pragma mark-loadHotData

-(void)loadHotData{
    
    [self presentLoadingTips:nil];
    [[BaseNetConfig shareInstance] configGlobalAPI:WETOWN];
    HotSearchAPI *hotSearchApi = [[HotSearchAPI alloc]initWithLimits:@""];
    [hotSearchApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        [self dismissTips];
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
            
            NSArray *list = result[@"list"];
            for (NSDictionary *dic in list) {
                [self.hotArray addObject:[SearchCardModel mj_objectWithKeyValues:dic]];
            }
            [self.hotTable reloadData];
            
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

#pragma mark- texrfield的代理方法

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self.searchTxt resignFirstResponder];
    
    self.searchword = textField.text;
   
    [self searchMemberCard:self.searchword];
    
    return YES;
}


#pragma mark - 搜索会员卡

- (void)searchMemberCard:(NSString *)searchWord{
    
    if (searchWord.length == 0) {
         [self presentFailureTips:@"请输入搜索内容"];
        return;
    }
    else {
        [self saveToLocalWithRecord:searchWord];
        [self.historyTable reloadData];
    }
    
    SearchMemberCardResultController *searchMemberCardResult = [SearchMemberCardResultController spawn];
    
    
    searchMemberCardResult.delegate = self;
    searchMemberCardResult.searchword = searchWord;
    
    [self.navigationController pushViewController:searchMemberCardResult animated:YES];
    
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
    
    [LocalData updateMemberCardSearchOfHistoryRecord:[record trim]];
    [self.historyArray removeAllObjects];
    [self.historyArray addObjectsFromArray:[LocalData getMemberCardSearchOfHistoryRecord]];
    
    if (self.historyArray.count != 0){
        NSInteger row = self.historyArray.count / 2;
        if (self.historyArray.count % 2 != 0){
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

#pragma mark - 删除历史搜索

- (IBAction)deleteSearchHistory:(id)sender {
    
    [self.view endEditing:YES];
    
    [LocalData removeMemberCardSearchOfHistoryRecord];
    [self.historyArray removeAllObjects];
    [self.historyArray addObjectsFromArray:[LocalData getMemberCardSearchOfHistoryRecord]];
    
    if (self.historyArray.count != 0){
        NSInteger row = self.historyArray.count / 2;
        if (self.historyArray.count % 2 != 0){
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

#pragma mark - collectionview

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (collectionView == self.historyTable) {
        return self.historyArray.count;
    }else if (collectionView == self.hotTable) {
        return self.hotArray.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellId = @"SearchWordCell";
    SearchWordCell * cell = (SearchWordCell *) [collectionView dequeueReusableCellWithReuseIdentifier:CellId forIndexPath:indexPath];
    if (collectionView == self.hotTable){
        cell.data = self.hotArray[indexPath.row];
    }else{
        cell.searchWordLbl.text = self.historyArray[indexPath.row];
    }
    //    cell.backgroundColor = [UIColor redColor];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.searchTxt resignFirstResponder];
    
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    
    NSString *searchword = @"";
    if (collectionView == self.historyTable) {
        searchword = [self.historyArray objectAtIndex:indexPath.row];
    }
    else {
        
        SearchCardModel *searCard = self.hotArray[indexPath.row];
        if (searCard) {
            searchword = searCard.key;
        }
    }
    
    if ([searchword trim].length == 0) {
        return;
    }
    self.searchTxt.text = searchword;
    
    [self searchMemberCard:searchword];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

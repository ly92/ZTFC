//
//  SearchSurroundingViewController.m
//  EstateBiz
//
//  Created by wangshanshan on 16/5/31.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "SearchSurroundingViewController.h"
#import "SurroundingCell.h"
#import "MemberCardDetailViewController.h"
#import "NoMemberCardDetailViewController.h"

@interface SearchSurroundingViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tv;
@property (weak, nonatomic) IBOutlet UIView *emptyView;

@property (nonatomic, strong) UITextField *searchTxt;
@property (nonatomic, copy) NSString *searchword;

@property (nonatomic, strong) NSMutableArray *searchSurroundingArray;


@end

@implementation SearchSurroundingViewController

+(instancetype)spawn{
    return [SearchSurroundingViewController loadFromStoryBoard:@"Surrounding"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.searchSurroundingArray = [NSMutableArray array];
    
    [self setNavigationbar];
    
    [self setHeaderAndFooter];
    
    [self.searchTxt becomeFirstResponder];
    
    self.searchword = @"";
    
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
    self.searchTxt.placeholder = @"搜索周边商户";
    self.searchTxt.backgroundColor = [UIColor clearColor];
    //187 194 199
    [self.searchTxt setValue:RGBACOLOR(187, 194, 199, 1.0) forKeyPath:@"_placeholderLabel.textColor"];
    [self.searchTxt setValue:[UIFont systemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    self.searchTxt.borderStyle =UITextBorderStyleNone;
    self.searchTxt.backgroundColor = [UIColor blackColor];
    self.searchTxt.delegate = self;
    self.searchTxt.textColor = RGBACOLOR(187, 194, 199, 1.0) ;
    
    self.searchTxt.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.searchTxt.returnKeyType = UIReturnKeySearch;
    
    [view addSubview:self.searchTxt];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithCustomView:view];
    
    self.navigationItem.rightBarButtonItem = [AppTheme itemWithContent:@"取消" handler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
}
#pragma mark- texrfield的代理方法

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self.searchTxt resignFirstResponder];
    
    self.searchword = textField.text;
    if (self.searchword.length == 0) {
         [self presentFailureTips:@"搜索内容不能为空"];
    }
    else {
        [self initloading];
//        [self loadDataWithKeywords:self.searchword];
    }
    return YES;
}

#pragma mark-加载数据

-(void)loadNewData{
    [self.searchSurroundingArray removeAllObjects];
    
    if (self.searchword.length == 0) {
        [self doneLoadingTableViewData];
        [self presentFailureTips:@"请输入搜索关键字"];
        return;
    }
    
    [self loadDataWithKeywords:self.searchword];
}

-(void)loadMoreData{
    [self loadDataWithKeywords:self.searchword];
}

-(void)loadDataWithKeywords:(NSString *)keyword{
    

    NSString *skip = [NSString stringWithFormat:@"%ld",self.searchSurroundingArray.count];
    
    [[BaseNetConfig shareInstance] configGlobalAPI:KAKATOOL];
    
    SearchSurroundingAPI *searchSurroundingApi = [[SearchSurroundingAPI alloc]initSurroundingWithKeyword:keyword bid:self.bid radius:self.radius limit:@"20" skip:skip industryid:self.industryid];
    
    [searchSurroundingApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
        [self doneLoadingTableViewData];
        [self dismissTips];
        SurroundingListResultModel *result = [SurroundingListResultModel mj_objectWithKeyValues:request.responseJSONObject];
        
        if (result && [result.result intValue] == 0) {
            
            for (Shop *shop in result.shoplist) {
                [self.searchSurroundingArray addObject:shop];
            }
            
            if (self.searchSurroundingArray.count == 0) {
                self.tv.hidden = YES;
                self.emptyView.hidden = NO;
            }else{
                self.tv.hidden = NO;
                self.emptyView.hidden = YES;
            }
            
            [self.tv reloadData];
            
        }else{
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


#pragma mark-tableView的代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.searchSurroundingArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"SurroundingCell";
    SurroundingCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:identifier owner:nil options:nil].firstObject;
    }
    if(self.searchSurroundingArray.count>indexPath.row){
        Shop *shop = self.searchSurroundingArray[indexPath.row];
        cell.data = shop;
        
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.searchTxt isFirstResponder]) {
        [self.searchTxt resignFirstResponder];
        
        SurroundingCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }else{
        
        SurroundingCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        if(self.searchSurroundingArray.count>indexPath.row){
            Shop *shop = self.searchSurroundingArray[indexPath.row];

            [self goToCardDetail:shop];
        }
    }
    
}
-(void)goToCardDetail:(Shop *)surrounding{
    //饭票商城（cardtype ==1）、地方饭票支付（cardtype == 2）
    if (surrounding) {
        
        NSString *cardnum = surrounding.cardnum;
        NSString *cardtype = surrounding.cardtype;
        NSString *extra = surrounding.extra;
        
        
        if (([cardtype intValue] == 1 || [cardtype intValue] == 2) && cardtype.length > 0){
            //饭票商城   //地方饭票
            if (extra&&[extra trim].length>0) {
                if ([[LocalData shareInstance] isLogin]) {
                    
                    UserModel *user = [[LocalData shareInstance]getUserAccount];
                    
                    NSString *token = [LocalData getDeviceToken];
                    if (user&&token) {
                        if ([surrounding.cardtype intValue] == 1){
                            NSString *urlstring = [NSString stringWithFormat:@"%@%@&token=%@",[surrounding.extra trim],user.cid,token];
                            if (urlstring) {
                                
                                WebViewController *web = [WebViewController spawn];
                                web.webURL = urlstring;
                                web.webTitle = @"饭票商城";
                                [self.navigationController pushViewController:web animated:YES];
                            }
                        }else if ([surrounding.cardtype intValue] == 2){
                            //surrounding.extra=http://colour.kakatool.cn/localbonus/shop/index?cid=$cid$&token=$kkttoken$&bid=$bid$&communityid=    $communityid$
                            UserModel *userModel = [[LocalData shareInstance]getUserAccount];
                            Community *community  = [STICache.global objectForKey:[NSString stringWithFormat:@"%@_crcc",userModel.mobile]];
                            NSString *urlstring = surrounding.extra;
                            urlstring = [urlstring stringByReplacingOccurrencesOfString:@"$cid$" withString:surrounding.cid];
                            urlstring = [urlstring stringByReplacingOccurrencesOfString:@"$kkttoken$" withString:[token urlEncode]];
                            urlstring = [urlstring stringByReplacingOccurrencesOfString:@"$bid$" withString:surrounding.bid];
                            urlstring = [urlstring stringByReplacingOccurrencesOfString:@"$communityid$" withString:community.bid];
                            
                            if (urlstring) {
                                
                                WebViewController *web = [WebViewController spawn];
                                web.webURL = urlstring;
                                web.webTitle = surrounding.name;
                                [self.navigationController pushViewController:web animated:YES];
                                
                            }
                        }
                    }
                }
            }
            
        }else{
            //普通卡
            if ([cardnum intValue] != 0){
                
                MemberCardDetailViewController *memberCardDetail = [MemberCardDetailViewController spawn];
                
                memberCardDetail.bid = surrounding.bid;
                memberCardDetail.cardId = surrounding.cardid;
                memberCardDetail.cardType = @"online";
                
                [self.navigationController pushViewController:memberCardDetail animated:YES];
                
            }else{
                //非会员
                
                NoMemberCardDetailViewController *noMemberCardDetail = [NoMemberCardDetailViewController spawn];
                noMemberCardDetail.bid = surrounding.bid;
                noMemberCardDetail.reloadData = ^{
                    [self.searchSurroundingArray removeAllObjects];
                    [self loadDataWithKeywords:self.searchword];
                };
                
                [self.navigationController pushViewController:noMemberCardDetail animated:YES];
                
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

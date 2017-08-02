//
//  SearchMemberCardResultController.m
//  EstateBiz
//
//  Created by wangshanshan on 16/6/17.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "SearchMemberCardResultController.h"
#import "SearchCardCell.h"
#import "MemberCardDetailViewController.h"
#import "NoMemberCardDetailViewController.h"

@interface SearchMemberCardResultController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tv;
@property (weak, nonatomic) IBOutlet UIView *emptyView;


@property (nonatomic, strong) UITextField *searchTxt;
@property (nonatomic, copy) NSString *lastId;
@property (nonatomic, strong) NSMutableArray *searchCardArr;

@end

@implementation SearchMemberCardResultController

+(instancetype)spawn{
    return [SearchMemberCardResultController loadFromStoryBoard:@"Home"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = VIEW_BG_COLOR;
    
    [self setNavigationbar];
    
    self.searchCardArr = [NSMutableArray array];
    self.lastId = @"0";
    self.searchTxt.text = self.searchword;
    
    [self setHeaderAndFooter];
    
    [self.tv tableViewRemoveExcessLine];
    [self.tv registerNib:@"SearchCardCell" identifier:@"SearchCardCell"];
    
    
    [self initloading];
    
    self.searchword = self.searchTxt.text;
    
//    [self loadDataWithSearchWord:self.searchTxt.text];
    
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
        self.searchTxt = [[UITextField alloc]initWithFrame:CGRectMake(30, 5,SCREENWIDTH-100 , 30)];
    }else{
        self.searchTxt = [[UITextField alloc]initWithFrame:CGRectMake(30, 0,SCREENWIDTH-100 , 30)];
    }
    self.searchTxt.placeholder = @"搜索会员卡";
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
//        [self loadDataWithSearchWord:self.searchword];

    }
    return YES;
}

#pragma mark-loadData

-(void)loadNewData{
    self.lastId = @"0";
    [self.searchCardArr removeAllObjects];
    [self loadDataWithSearchWord:self.searchword];
}
-(void)loadMoreData{
    [self loadDataWithSearchWord:self.searchword];
}
-(void)loadDataWithSearchWord:(NSString *)searchWord{
    
    NSString *word = self.searchTxt.text;
    
    if ([word trim].length == 0) {
         [self presentFailureTips:@"请输入搜索内容"];
        return;
        
    }
    
    [[BaseNetConfig shareInstance] configGlobalAPI:WETOWN];
    SearchMemberCardAPI *searchMemberCardApi = [[SearchMemberCardAPI alloc]initWithskeys:word lastId:self.lastId pagesize:@"10"];
    [searchMemberCardApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        [self doneLoadingTableViewData];
        [self dismissTips];
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
            
            NSArray *list = result[@"list"];
            for (NSDictionary *dic in list) {
                [self.searchCardArr addObject:[NoMemberCardInfo mj_objectWithKeyValues:dic]];
            }
            
            if (self.searchCardArr.count == 0) {
                self.emptyView.hidden = NO;
                self.tv.hidden = YES;
            }else{
                self.emptyView.hidden = YES;
                self.tv.hidden = NO;
            }
            
            self.lastId = result[@"last_id"];
            
            if (list.count < 10) {
                [self loadAll];
            }
            [self.tv reloadData];
            
        }else{
             [self presentFailureTips:result[@"reason"]];
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.searchCardArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"SearchCardCell";
    SearchCardCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
   
    if(self.searchCardArr.count>0){
        cell.data = self.searchCardArr[indexPath.row];
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.searchTxt resignFirstResponder];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.searchCardArr.count > indexPath.row) {
        NoMemberCardInfo *search = self.searchCardArr[indexPath.row];
        
        //替换搜索纪录
        [LocalData removeMemberCardSearchOfHistoryRecord:self.searchword];
        if (self.delegate && [self.delegate respondsToSelector:@selector(updateHistoryRecord:)]) {
            [self.delegate updateHistoryRecord:search.name];
        }
        
        [self goToCardDetail:search];
        
    }
    
}

-(void)goToCardDetail:(NoMemberCardInfo *)surrounding{
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
                            UserModel *user = [[LocalData shareInstance]getUserAccount];
                             UserModel *userModel = [[LocalData shareInstance]getUserAccount];
                            Community *community  = [STICache.global objectForKey:[NSString stringWithFormat:@"%@_crcc",userModel.mobile]];

                            NSString *urlstring = surrounding.extra;
                            urlstring = [urlstring stringByReplacingOccurrencesOfString:@"$cid$" withString:user.cid];
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
                memberCardDetail.cardId = surrounding.bizcard.cardid;
                memberCardDetail.cardType = @"online";
                
                [self.navigationController pushViewController:memberCardDetail animated:YES];
                
            }else{
                //非会员
                
                NoMemberCardDetailViewController *noMemberCardDetail = [NoMemberCardDetailViewController spawn];
                noMemberCardDetail.bid = surrounding.bid;
                
                noMemberCardDetail.reloadData = ^(){
                    [self initloading];
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

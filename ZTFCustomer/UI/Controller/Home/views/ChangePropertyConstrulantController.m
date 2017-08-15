//
//  ChangePropertyConstrulantController.m
//  ztfCustomer
//
//  Created by mac on 16/7/5.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "ChangePropertyConstrulantController.h"
#import "BindingPropertyConstrulantCell.h"
#import "HandlePush.h"


@interface ChangePropertyConstrulantController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,BindingPropertyConstrulantCellDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tv;

@property (weak, nonatomic) IBOutlet UIView *emptyView;

@property (nonatomic, strong) UITextField *searchTxt;


@property (nonatomic, strong) NSMutableArray *propertyArr;

@property (nonatomic, copy) NSString *keyword;

@property (nonatomic, copy) NSString *skip;
@property (nonatomic, copy) NSString *limits;

@property (nonatomic, strong) PropertyConstrulantModel *bindData;

@end

@implementation ChangePropertyConstrulantController


+(instancetype)spawn{
    return [ChangePropertyConstrulantController loadFromStoryBoard:@"Home"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = VIEW_BG_COLOR;
    self.tv.backgroundColor = VIEW_BG_COLOR;
    
    [self setHeaderAndFooter];
    
    [self.tv tableViewRemoveExcessLine];
    
    [self.tv registerNib:@"BindingPropertyConstrulantCell" identifier:@"BindingPropertyConstrulantCell"];
    
    [self setNavigationbar];
    
    self.skip = @"0";
    self.limits = @"10";
    self.keyword = @"";
    
    [self initloading];
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
        self.searchTxt = [[UITextField alloc]initWithFrame:CGRectMake(30, 5,SCREENWIDTH-120 , 30)];
    }else{
        self.searchTxt = [[UITextField alloc]initWithFrame:CGRectMake(30, 0,SCREENWIDTH-120 , 30)];
    }
    self.searchTxt.placeholder = @"搜索楼栋管家";
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

#pragma mark-懒加载
-(NSMutableArray *)propertyArr{
    if (!_propertyArr) {
        _propertyArr = [NSMutableArray array];
    }
    return _propertyArr;
}

#pragma mark-loaddata

-(void)loadNewData{
    [self.propertyArr removeAllObjects];
    
    self.skip = @"0";
    
    [self loadData];
}
-(void)loadMoreData{
    
    NSInteger page = [self.skip intValue];
    
    self.skip = [NSString stringWithFormat:@"%ld",page+[self.limits intValue]];
    [self loadData];
}

-(void)loadData{
    
    UserModel *user = [[LocalData shareInstance]getUserAccount];
    Community *community = [STICache.global objectForKey:[NSString stringWithFormat:@"%@_crcc",user.mobile]];
    [[BaseNetConfig shareInstance]configGlobalAPI:ICE];
    PropertyListAPI *propertyConstulant = [[PropertyListAPI alloc]initWithCommunityId:community.bid  ProjectId:@"" keyword:self.keyword limit:self.limits skip:self.skip];
    propertyConstulant.employeeType = EMPLOYEELISTTYPE;
    [propertyConstulant startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
        [self doneLoadingTableViewData];
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        NSDictionary *content = result[@"content"];
        if (![ISNull isNilOfSender:result] && [result[@"code"] intValue] == 0) {
            NSArray *list = content[@"employees"];
            if (![ISNull isNilOfSender:list]) {
                for (NSDictionary *dic in list) {
                    PropertyConstrulantModel *consultantModel = [PropertyConstrulantModel mj_objectWithKeyValues:dic];
                    [self.propertyArr addObject:consultantModel];
                }
            }
            
//            if (list.count < [self.limits intValue]) {
//                [self loadAll];
//            }else{
//                [self resetLoadAll];
//            }
            
            if (self.propertyArr.count == 0) {
                self.emptyView.hidden = NO;
                self.tv.hidden = YES;
            }else{
                self.emptyView.hidden = YES;
                self.tv.hidden = NO;
            }
            
            [self.tv reloadData];
            
        }else{
            
            self.emptyView.hidden = NO;
            self.tv.hidden = YES;
            [self presentFailureTips:result[@"message"]];
            
        }
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
        self.emptyView.hidden = NO;
        self.tv.hidden = YES;
        
        [self doneLoadingTableViewData];
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
    
    self.keyword = textField.text;
    
    [self initloading];
    
    return YES;
}

#pragma mark-tableView delegate


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.propertyArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    BindingPropertyConstrulantCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BindingPropertyConstrulantCell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.delegate = self;
    
    
    if (self.propertyArr.count > indexPath.row) {
        PropertyConstrulantModel *consultntModel = self.propertyArr[indexPath.row];
        cell.data = consultntModel;
    }
        
    return cell;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 95;
}

#pragma mark-BindingPropertyConstrulantCellDelegate

-(void)bindingClickWithStr:(id)modelData{
    
    self.bindData = (PropertyConstrulantModel *)modelData;
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"确定绑定该顾问" message:self.bindData.name delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    [alert show];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        
        //绑定成功（无论是从首页跳转，还是从楼栋管家详情挑转，均返回首页,同时刷新首页数据)
        [[BaseNetConfig shareInstance] configGlobalAPI:ICE];
        [self presentLoadingTips:nil];
         UserModel *userModel = [[LocalData shareInstance]getUserAccount];
        Community *community = [STICache.global objectForKey:[NSString stringWithFormat:@"%@_crcc",userModel.mobile]];
        OperatePropertyConstulantAPI *cancelBinding = [[OperatePropertyConstulantAPI alloc]initWithSaleid:self.bindData.id ProjectId:@"" communityId:community.bid];
        cancelBinding.operateType = BINDING;
        [cancelBinding startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
            NSDictionary *result = (NSDictionary *)request.responseJSONObject;
            NSDictionary *content = result[@"content"];
            if (![ISNull isNilOfSender:result] && [result[@"code"] intValue] == 0 ) {
                //绑定成功之后返回的是顾问实体,返回到首页进行获取楼栋管家信息显示
                NSDictionary *employee = content[@"employee"];
                PropertyConstrulantModel *employeeModel = [PropertyConstrulantModel mj_objectWithKeyValues:employee];
                
                [self fk_postNotification:@"BingingSuccess" object:employeeModel.community_id];
                
                [self.navigationController popToRootViewControllerAnimated:YES];
                
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
}


@end

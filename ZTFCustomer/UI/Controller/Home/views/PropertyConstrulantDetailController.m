//
//  PropertyConstrulantDetailController.m
//  ztfCustomer
//
//  Created by mac on 16/7/4.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "PropertyConstrulantDetailController.h"
#import "PropertyConstrulantDetailCell.h"
#import "PropertyConstrulantDetailHeaderCell.h"
#import "ChangePropertyConstrulantController.h"
#import "ChatViewController.h"

@interface PropertyConstrulantDetailController ()<UITableViewDelegate,UITableViewDataSource,PropertyConstrulantDetailCellDelegate,UIAlertViewDelegate,PropertyConstrulantDetailHeaderCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tv;

@property (weak, nonatomic) IBOutlet UIButton *cancelBindBtn;
@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) NSMutableArray *contentArray;
//@property (nonatomic, strong) PropertyConstrulantModel *propertyDetailModel;
@property (nonatomic, strong) PropertyConstrulantModel *propertyDetailModel;

@end

@implementation PropertyConstrulantDetailController

+(instancetype)spawn{
    return [PropertyConstrulantDetailController loadFromStoryBoard:@"Home"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = VIEW_BG_COLOR;
    self.tv.backgroundColor = VIEW_BG_COLOR;
    
    [self setNavigationBar];

    [self.tv tableViewRemoveExcessLine];
    
     [self.tv registerNib:@"PropertyConstrulantDetailHeaderCell" identifier:@"PropertyConstrulantDetailHeaderCell"];
    [self.tv registerNib:@"PropertyConstrulantDetailCell" identifier:@"PropertyConstrulantDetailCell"];
   
    //设置数据
    if (self.isSteward) {
        self.dataArray = @[@"专属管家",@"工      号",@"所属小区",@"手机号码"];
        
    }else{
    self.dataArray = @[@"置业顾问",@"工      号",@"所属团队",@"销售等级",@"手机号码"];
    }
    
    
    [self loadData];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (![AppDelegate sharedAppDelegate].tabController.tabBarHidden) {
        [[AppDelegate sharedAppDelegate].tabController setTabBarHidden:YES animated:YES];
    }
    
    [self.navigationController.navigationBar hideBottomHairline];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar showBottomHairline];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-navibar
-(void)setNavigationBar{
    
    if(self.isSteward){
        self.navigationItem.title = @"专属管家详情";
        self.cancelBindBtn.hidden = YES;
    }else{
        self.navigationItem.title = @"置业顾问详情";
        self.cancelBindBtn.hidden = NO;
    }
    
    self.navigationItem.leftBarButtonItem = [AppTheme backItemWithHandler:^(id sender) {
        
        if (self.communityId) {
            [self fk_postNotification:@"BingingSuccess" object:self.communityId];
        }
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }];
    
}

#pragma mark-懒加载
-(NSMutableArray *)contentArray{
    if (!_contentArray) {
        _contentArray = [NSMutableArray array];
    }
    return _contentArray;
}

#pragma mark-loadData
-(void)loadData{
    
    //网络请求，获取数据转化为模型
    [self presentLoadingTips:nil];
    [[BaseNetConfig shareInstance]configGlobalAPI:ICE];
    UserModel *userModel = [[LocalData shareInstance]getUserAccount];
    Community *community  = [STICache.global objectForKey:[NSString stringWithFormat:@"%@_crcc",userModel.mobile]];
    //self.propertyModel.project.project_id
    OperatePropertyConstulantAPI *propertyDetailApi  =[[OperatePropertyConstulantAPI alloc]initWithSaleid:self.propertyModel.id ProjectId:@"" communityId:community.bid];
    propertyDetailApi.operateType = EMPLOYEEDETAIL;
    
    [propertyDetailApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        [self dismissTips];
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        NSDictionary *content = result[@"content"];
        if (![ISNull isNilOfSender:result] && [result[@"code"] intValue] == 0) {
            
            NSDictionary *dic = content[@"employee"];
            
            self.propertyDetailModel = [PropertyConstrulantModel mj_objectWithKeyValues:dic];
            
            if (self.isSteward) {
                [self.contentArray addObject:self.propertyDetailModel.name.length>0?self.propertyDetailModel.name:@""];
                [self.contentArray addObject:self.propertyDetailModel.employee_number.length>0?self.propertyDetailModel.employee_number:@""];
                [self.contentArray addObject:self.propertyDetailModel.star_name.length>0?self.propertyDetailModel.star_name:@""];
                [self.contentArray addObject:self.propertyDetailModel.mobile.length>0?self.propertyDetailModel.mobile:@""];
            }else{
                
                [self.contentArray addObject:self.propertyDetailModel.name.length>0?self.propertyDetailModel.name:@""];
                [self.contentArray addObject:self.propertyDetailModel.employee_number.length>0?self.propertyDetailModel.employee_number:@""];
                 [self.contentArray addObject:self.propertyDetailModel.team.name.length>0?self.propertyDetailModel.team.name:@""];
                [self.contentArray addObject:self.propertyDetailModel.star_name.length>0?self.propertyDetailModel.star_name:@""];
               
                [self.contentArray addObject:self.propertyDetailModel.mobile.length>0?self.propertyDetailModel.mobile:@""];
                
            }
            [self.tv reloadData];
            
        }else{
             [self presentFailureTips:result[@"message"]];
        }
        
        
    } failure:^(__kindof YTKBaseRequest *request) {
        [self presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
    }];
    
}

#pragma mark-tableView delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 1;
    }else{
        return self.dataArray.count;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section == 0) {
        PropertyConstrulantDetailHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PropertyConstrulantDetailHeaderCell" forIndexPath:indexPath];
        cell.isSteward = self.isSteward;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        
        cell.data = self.propertyDetailModel;
        
        return cell;
        
    }else if (indexPath.section == 1) {
        PropertyConstrulantDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PropertyConstrulantDetailCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        if(self.dataArray.count > indexPath.row){
            
            cell.titleLbl.text = self.dataArray[indexPath.row];
            cell.mobileButton.hidden = YES;
            cell.smsButton.hidden = YES;
            cell.changePropertyButton.hidden = NO;
        }
        
        if (self.contentArray.count > indexPath.row) {
            cell.contentLbl.text = self.contentArray[indexPath.row];
        }
        if (self.isSteward) {
//            if (indexPath.row == 0) {
//                cell.cotentLbltrailing.constant = -10;
//                 cell.changePropertyButton.hidden = YES;
//            }
            if (indexPath.row == 3){
                cell.cotentLbltrailing.constant = 90;
                cell.mobileButton.hidden = NO;
                cell.smsButton.hidden = NO;
                cell.changePropertyButton.hidden = YES;
            }else{
                cell.cotentLbltrailing.constant = 10;
                cell.mobileButton.hidden = YES;
                cell.smsButton.hidden = YES;
                cell.changePropertyButton.hidden = YES;
            }
        }else{
            if (indexPath.row == 0) {
                if (self.communityId) {
                    cell.cotentLbltrailing.constant = 10;
                    cell.changePropertyButton.hidden = YES;
                }else{
                    cell.cotentLbltrailing.constant = 120;
                    cell.changePropertyButton.hidden = NO;
                }
                
                cell.mobileButton.hidden = YES;
                cell.smsButton.hidden = YES;
               

            }else if (indexPath.row == 4){
                cell.cotentLbltrailing.constant = 90;
                cell.mobileButton.hidden = NO;
                cell.smsButton.hidden = NO;
                cell.changePropertyButton.hidden = YES;
            }else{
                cell.cotentLbltrailing.constant = 10;
                cell.mobileButton.hidden = YES;
                cell.smsButton.hidden = YES;
                cell.changePropertyButton.hidden = YES;
            }
        }
       
        return cell;
        
    }
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.01;
    }else{
        return 40;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (self.isSteward) {
            return 180;
        }else{
            return 200;
        }
        
    }else{
        return 44;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 40)];
        headerView.backgroundColor = VIEW_BG_COLOR;
        
        UILabel *headerLbl = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, SCREENWIDTH-20, 20)];
        headerLbl.text = @"基本信息";
        headerLbl.textColor = [UIColor grayColor];
        headerLbl.font = [UIFont systemFontOfSize:14];
        [headerView addSubview:headerLbl];
        
        UILabel *bottomLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 39, SCREENWIDTH, 1)];
        
        bottomLbl.text = @"";
        bottomLbl.backgroundColor = [UIColor colorWithRed:230.0/255 green:230.0/255 blue:230.0/255 alpha:1];
        [headerView addSubview:bottomLbl];
        
        return headerView;
    }
    return nil;
}

#pragma mark-PropertyConstrulantDetailCellDelegate
//切换置业顾问
-(void)changePropertyClick{
    ChangePropertyConstrulantController *change = [ChangePropertyConstrulantController spawn];
    [self.navigationController pushViewController:change animated:YES];
}
//拨打电话
-(void)mobileClick{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"确定拨打电话" message:self.propertyDetailModel.mobile delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 1001;
    
    [alert show];
}
//发短信
-(void)smsClick{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"确定发短信" message:self.propertyDetailModel.mobile delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 1002;
    
    [alert show];
}

#pragma mark-PropertyConstrulantDetailHeaderCellDelegate
//即时聊天
-(void)chatClick{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"确定发送消息" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 1004;
    
    [alert show];
}


#pragma mark-click
//取消绑定
- (IBAction)cancelBindingClick:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"确定取消绑定" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 1003;
    
    [alert show];
}


#pragma mark-uialertView delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1001) {
        if (buttonIndex == 1) {
            //拨打电话
            NSString *tel = [NSString stringWithFormat:@"tel://%@",self.propertyDetailModel.mobile];
            NSURL *callUrl = [NSURL URLWithString:tel];
            
            if ([[UIApplication sharedApplication]canOpenURL:callUrl]) {
                
            }else{
                 [self presentFailureTips:@"不支持此功能"];
            }
            
        }
    }else if (alertView.tag == 1002){
        if (buttonIndex == 1) {
            //发短信
            NSString *sms = [NSString stringWithFormat:@"sms://%@",self.propertyDetailModel.mobile];
            NSURL *smsUrl = [NSURL URLWithString:sms];
            
            if ([[UIApplication sharedApplication]canOpenURL:smsUrl]) {
                
            }else{
                [self presentFailureTips:@"不支持此功能"];
            }
        }
    }else if (alertView.tag == 1003){
        if (buttonIndex == 1) {
            
            if (!self.propertyDetailModel.id) {
                return;
            }
            //取消绑定（网络请求）
            [self presentLoadingTips:nil];
            [[BaseNetConfig shareInstance]configGlobalAPI:ICE];
            //self.propertyModel.project.project_id
            
            UserModel *userModel = [[LocalData shareInstance]getUserAccount];
            Community *community  = [STICache.global objectForKey:[NSString stringWithFormat:@"%@_crcc",userModel.mobile]];
            OperatePropertyConstulantAPI *cancelBinding = [[OperatePropertyConstulantAPI alloc]initWithSaleid:self.propertyModel.id ProjectId:@"" communityId:community.bid];
            cancelBinding.operateType = CANCEL;
            [cancelBinding startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
                
                [self dismissTips];
                
                NSDictionary *result = (NSDictionary *)request.responseJSONObject;
                if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0 ) {
                    
                    
                    [self fk_postNotification:@"CANCELBINDING"];
                    
                    self.cancelBindingBlock();
                    [STICache.global setObject:nil forKey:@"chatUser"];
                    //取消成功（返回首页，刷新首页数据）
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    
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
    }else if (alertView.tag == 1004){
        if (buttonIndex == 1) {
            
            //即时聊天
            ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:self.propertyDetailModel.easemob conversationType:EMConversationTypeChat FromOther:YES];
            chatController.title = self.propertyDetailModel.name;
            
            [self.navigationController pushViewController:chatController animated:YES];
            
        }
    }
}


@end

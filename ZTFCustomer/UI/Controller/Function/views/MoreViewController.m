//
//  MoreViewController.m
//  EstateBiz
//
//  Created by wangshanshan on 16/6/8.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "MoreViewController.h"
#import "ServiceCollectionViewCell.h"
#import "SuppleView.h"
#import "ComingSoonController.h"
#import "MemberCardDetailViewController.h"
#import "NoMemberCardDetailViewController.h"
//#import "RealReachability.h"

@interface MoreViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;


@property (nonatomic, strong) NSMutableArray *functionArr;

@end

@implementation MoreViewController

+(instancetype)spawn{
    return [self loadFromStoryBoard:@"Function"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = VIEW_BG_COLOR;
    self.functionArr = [NSMutableArray array];
    
    [self navigationBar];
    
    [self setUpLayout];
    
    [self loadData];
    
    
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
-(void)navigationBar{
    
    self.titleName = (NSString *)self.data;
    
    self.navigationItem.title = self.titleName;
    self.navigationItem.leftBarButtonItem = [AppTheme backItemWithHandler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

-(void)setUpLayout{
    
    [self.collectionView registerNib:[ServiceCollectionViewCell nib] forCellWithReuseIdentifier:@"ServiceCollectionViewCell"];
    
     [self.collectionView registerClass:[SuppleView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SuppleView"];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    CGFloat width = SCREENWIDTH/4.0;
    
    layout.itemSize = CGSizeMake(width, width);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    
    [self.collectionView setCollectionViewLayout:layout];
    
    

}

#pragma mark-加载数据
-(void)loadData{
    [self presentLoadingTips:nil];
    [[BaseNetConfig shareInstance] configGlobalAPI:WETOWN];
    FunctionAPI *moreFunctionApi = [[FunctionAPI alloc]init];
    moreFunctionApi.functionType = MORE_FUNCTION;
    
    [moreFunctionApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        [self dismissTips];
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
            NSArray *list = result[@"list"];
            for (NSDictionary *dic in list) {
                [self.functionArr addObject:[MoreFunctionModel mj_objectWithKeyValues:dic]];
            }

            [self.collectionView reloadData];
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

#pragma mark-collectionView delegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.functionArr.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    MoreFunctionModel *moreFunctionModel = self.functionArr[section];
    
    NSArray *moduleArr = moreFunctionModel.modules;
    if (moduleArr == nil) {
        return 0;
    }
    if (moduleArr.count == 0) {
        return moduleArr.count;
    }
    else if (moduleArr.count%4 == 0) {
        return moduleArr.count;
    }else{
        return  (moduleArr.count/4+1)*4;
    }
//    return moduleArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ServiceCollectionViewCell" forIndexPath:indexPath];
    
    MoreFunctionModel *moreFunctionModel = self.functionArr[indexPath.section];
    NSArray *moduleArr = moreFunctionModel.modules;
    if (moduleArr.count > indexPath.row) {
         cell.data = moduleArr[indexPath.item];
    }
   
    return cell;
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(0, 35);
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{

    SuppleView *supple = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"SuppleView" forIndexPath:indexPath];
    MoreFunctionModel *moreFunctionModel = [self.functionArr objectAtIndex:indexPath.section];
    NSString *name = moreFunctionModel.name;
    
    if (![ISNull isNilOfSender:name]) {
        supple.titleLabel.text = [NSString stringWithFormat:@"  %@",name];
    }
    if ([kind isEqual:UICollectionElementKindSectionHeader]) {
        return supple;
    }else {
        return supple;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
 
    MoreFunctionModel *moreFunctionModel = self.functionArr[indexPath.section];
    NSArray *moduleArr = moreFunctionModel.modules;
    
    if (moduleArr.count > indexPath.row) {
        FunctionModel *functionModel = moduleArr[indexPath.item];
        if (functionModel) {
            NSString *act = functionModel.actiontype;
            if ([act isEqualToString:@"1"]) {
                NSString *proto = functionModel.actionios;
                if (![ISNull isNilOfSender:proto]) {
                    //跳转到原生界面
                    @try {
                        
                        id myObj = [NSClassFromString(proto) spawn];
                        if ([myObj isKindOfClass:[UIViewController class]]) {
                            
                            UIViewController *con = (UIViewController *)myObj;
                            
                            con.data = functionModel.name;
                            
                            [self.navigationController pushViewController:con animated:YES];
                            
                            
                        }else{
                             [self presentFailureTips:@"该功能暂时未开放"];
                            
                        }
                    }
                    @catch (NSException *exception) {
                        
                    }
                    @finally {
                        
                    }
                    
                }else{
                    //跳转到未建设界面
                    ComingSoonController *comingSoon = [ComingSoonController spawn];
                    
                    comingSoon.data = functionModel.name;
                    
                    [self.navigationController pushViewController:comingSoon animated:YES];
                }
            }else if ([act isEqualToString:@"0"]){
//                RealReachability *reachability = [RealReachability sharedInstance];
//                if ([reachability currentReachabilityStatus]){
                    NSString *outerurl = functionModel.actionurl;
                    outerurl =  [WebViewController pingUrlWithUrl:outerurl pushCmd:nil];
                    if ([outerurl trim].length>0) {
                        
                        WebViewController *web = [WebViewController spawn];
                        web.webURL = outerurl;
                        web.webTitle = functionModel.name;
                        [self.navigationController pushViewController:web animated:YES];
                        
                    }
//                }
            }else if ([act isEqualToString:@"3"]){
                NSString *proto = functionModel.actionios;
                
                //跳转到特定卡详情
                if([proto isEqualToString:@"JumpBizInfo"]){
                    
                    id extra = functionModel.extra;
                    
                    if ([extra isKindOfClass:[NSString class]]) {
                        
                        NSString *extraString = (NSString *)extra;
                        NSDictionary *data =(NSDictionary *) [extraString mj_JSONObject];
                        
                        if (![ISNull isNilOfSender:data]) {
                            NSString *bid = [data objectForKey:@"bid"];
                            if (bid) {
                                [self JumpBizInfo:bid];
                            }
                        }
                        
                    }
                    else if ([extra isKindOfClass:[NSDictionary class]]){
                        NSDictionary *data = (NSDictionary *)extra;
                        
                        if (![ISNull isNilOfSender:data]) {
                            NSString *bid = [data objectForKey:@"bid"];
                            if (bid) {
                                [self JumpBizInfo:bid];
                            }
                        }
                        
                    }
                    
                }

            }
        }

    }
}

//跳转到会员卡
-(void)JumpBizInfo:(NSString *)bid
{
    
    UserModel *user=[[LocalData shareInstance]getUserAccount];
    if (!user) {
        return;
    }
    
    NSString *cid = user.cid;
    
    if (cid&&bid) {
        
        [self presentLoadingTips:nil];
        
        [[BaseNetConfig shareInstance]configGlobalAPI:KAKATOOL];
        GetMemberCardAPI *getMemberCardApi =[[GetMemberCardAPI alloc]initWithBid:bid];
        [getMemberCardApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            [self dismissTips];
            NSDictionary *result = (NSDictionary *)request.responseJSONObject;
            if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
                
                NSDictionary *info = [result objectForKey:@"info"];
                
                [self goToCardDetail:info];
                
                
            }else{
                [self presentFailureTips:result[@"reason"]];
            }
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            [self presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
        }];
        
    }
    
}
-(void)goToCardDetail:(NSDictionary *)info{
    //饭票商城（cardtype ==1）、地方饭票支付（cardtype == 2）
    
    
    if (![ISNull isNilOfSender:info]) {
        NSString *cardnum = [info objectForKey:@"cardnum"];
        
        NSString *bid = [info objectForKey:@"bid"];
        
        NSString *cardtype = [[info objectForKey:@"bizcard"] objectForKey:@"cardtype"];
        NSString *extra = [[info objectForKey:@"bizcard"] objectForKey:@"extra"];
        
        NSString *cardid = [[info objectForKey:@"bizcard"] objectForKey:@"cardid"];
        
        NSString *cardname = [[info objectForKey:@"bizcard"] objectForKey:@"cardname"];
        
        
        if (([cardtype intValue] == 1 || [cardtype intValue] == 2) && cardtype.length > 0){
            //饭票商城   //地方饭票
            if (extra&&[extra trim].length>0) {
                if ([[LocalData shareInstance] isLogin]) {
                    
                    UserModel *user = [[LocalData shareInstance]getUserAccount];
                    
                    NSString *token = [LocalData getDeviceToken];
                    if (user&&token) {
                        if ([cardtype intValue] == 1){
                            NSString *urlstring = [NSString stringWithFormat:@"%@%@&token=%@",[extra trim],user.cid,token];
                            if (urlstring) {
                                
                                
                                WebViewController *web = [WebViewController spawn];
                                web.webURL = urlstring;
                                web.title = @"饭票商城";
                                [self.navigationController pushViewController:web animated:YES];
                                
                                
                            }
                        }else if ([cardtype intValue] == 2){
                            //surrounding.extra=http://colour.kakatool.cn/localbonus/shop/index?cid=$cid$&token=$kkttoken$&bid=$bid$&communityid=    $communityid$
                            UserModel *user=[[LocalData shareInstance]getUserAccount];
                            NSString *urlstring = extra;
                            urlstring = [urlstring stringByReplacingOccurrencesOfString:@"$cid$" withString:user.cid];
                            urlstring = [urlstring stringByReplacingOccurrencesOfString:@"$kkttoken$" withString:[token urlEncode]];
                            urlstring = [urlstring stringByReplacingOccurrencesOfString:@"$bid$" withString:bid];
                            urlstring = [urlstring stringByReplacingOccurrencesOfString:@"$communityid$" withString:bid];
                            
                            if (urlstring) {
                                
                                WebViewController *web = [WebViewController spawn];
                                web.webURL = urlstring;
                                web.title = cardname;
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
                
                memberCardDetail.bid = bid;
                memberCardDetail.cardId = cardid;
                memberCardDetail.cardType = @"online";
                
                [self.navigationController pushViewController:memberCardDetail animated:YES];
                
            }else{
                //非会员
                
                NoMemberCardDetailViewController *noMemberCardDetail = [NoMemberCardDetailViewController spawn];
                noMemberCardDetail.bid = bid;
                noMemberCardDetail.reloadData = ^{
                    
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

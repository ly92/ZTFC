//
//  HomeMemberCardCell.m
//  ZTFCustomer
//
//  Created by mac on 2016/12/6.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "HomeMemberCardCell.h"
#import "MemberCardCell.h"
static NSString *memberCardIdentifier = @"MemberCardCell";
@interface HomeMemberCardCell ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tv;

@end

@implementation HomeMemberCardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.tv registerNib:memberCardIdentifier identifier:memberCardIdentifier];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)dataDidChange{
    if ([self.data isKindOfClass:[NSArray class]]) {
        [self.tv reloadData];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSArray *arr = (NSArray *)self.data;
    return arr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MemberCardCell *memberCardCell = [tableView dequeueReusableCellWithIdentifier:memberCardIdentifier forIndexPath:indexPath];
    memberCardCell.selectionStyle = UITableViewCellSelectionStyleNone;
//    memberCardCell.cardBottom.constant = 0;
    NSArray *arr = (NSArray *)self.data;
    if (arr.count > indexPath.section) {
        memberCardCell.data = arr[indexPath.section];
    }
    
    return memberCardCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 125;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 5)];
    
    footerView.backgroundColor = VIEW_BG_COLOR;
    
    return footerView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     NSArray *arr = (NSArray *)self.data;
    if (arr.count > indexPath.section) {
        MemberCardModel *model = arr[indexPath.section];
        if ([self.delegate respondsToSelector:@selector(didselectMemberCardWithData:)]) {
            [self.delegate didselectMemberCardWithData:model];
        }
        
    }
    
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSMutableArray *arr = (NSMutableArray *)self.data;
    
    if (arr.count > 0) {
        return YES;
    }
    return NO;
    
}

//-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return UITableViewCellEditingStyleDelete;
//}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableArray *arr = (NSMutableArray *)self.data;
    MemberCardModel *memberCard = arr[indexPath.section];
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        [UIAlertView bk_showAlertViewWithTitle:@"是否确认删除" message:[NSString stringWithFormat:@"%@",memberCard.cardname] cancelButtonTitle:@"取消" otherButtonTitles:@[@"确认"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                //删除会员卡
                [[UIApplication sharedApplication].keyWindow.rootViewController presentLoadingTips:nil];
                [[BaseNetConfig shareInstance] configGlobalAPI:KAKATOOL];
                DeleteMemberCardAPI *deleteMemberCardApi = [[DeleteMemberCardAPI alloc]initWithCardID:memberCard.cardid];
                [deleteMemberCardApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
                    NSDictionary *result = (NSDictionary *)request.responseJSONObject;
                    if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
                        [[UIApplication sharedApplication].keyWindow.rootViewController dismissTips];
                        
                        [arr removeObjectAtIndex:indexPath.section];
                      
                        if (arr.count > 0) {
                            
                            [self.tv deleteSection:indexPath.section withRowAnimation:UITableViewRowAnimationRight];
                        }
                        if ([self.delegate respondsToSelector:@selector(didDeleteMemberCardwithArr:)]) {
                            [self.delegate didDeleteMemberCardwithArr:arr];
                        }
                        
                        
                    }else{
                        if ([result[@"result"] intValue] == 9001 || [result[@"result"] intValue] == 9006 ||[result[@"result"] intValue] == 16||[result[@"result"] intValue] == 9004) {
                            [[AppDelegate sharedAppDelegate]showLogin];
                        }
                        [[UIApplication sharedApplication].keyWindow.rootViewController presentFailureTips:result[@"reason"]];
                    }
                    
                } failure:^(__kindof YTKBaseRequest *request) {
                    if (request.responseStatusCode == 9001 || request.responseStatusCode == 9006 || request.responseStatusCode == 16) {
                        [[AppDelegate sharedAppDelegate]showLogin];
                    }
                    if (request.responseStatusCode == 0) {
                        [[UIApplication sharedApplication].keyWindow.rootViewController presentFailureTips:@"网络不可用，请检查网络链接"];
                    }else{
                        [[UIApplication sharedApplication].keyWindow.rootViewController presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
                    }
                }];
            }
        }];
        
    }];
    
    
    

    UITableViewRowAction *editAction = nil;
    
    if ([memberCard.isfav intValue] == 0) {
        
        //添加
        editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"收藏" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            [UIAlertView bk_showAlertViewWithTitle:@"是否确认收藏" message:[NSString stringWithFormat:@"%@",memberCard.cardname] cancelButtonTitle:@"取消" otherButtonTitles:@[@"确认"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    NSMutableArray *arr = (NSMutableArray *)self.data;
                    MemberCardModel *memberCard = arr[indexPath.section];
                    // 收藏会员卡
                    [[UIApplication sharedApplication].keyWindow.rootViewController presentLoadingTips:nil];
                    
                    [[BaseNetConfig shareInstance] configGlobalAPI:KAKATOOL];
                    
                    OperateMemberCardAPI *addMemberCardApi = [[OperateMemberCardAPI alloc]initWithCardId:memberCard.cardid cardType:@"2"];
                    addMemberCardApi.operateMemberCardType = collectMemberCardType;
                    [addMemberCardApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                        [[UIApplication sharedApplication].keyWindow.rootViewController dismissTips];
                        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
                        if (![ISNull isNilOfSender:result] && [result[@"code"] intValue] == 0) {
                            
                            memberCard.isfav = @"1";
                            [arr replaceObjectAtIndex:indexPath.section withObject:memberCard];
                            if ([self.delegate respondsToSelector:@selector(didCollectMemberCardWithArr:)]) {
                                [self.delegate didCollectMemberCardWithArr:arr];
                            }
                            
                            
                            
                        }else{
                            [self presentFailureTips:result[@"message"]];
                        }
                    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                        [self presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
                    }];
                    
                    
                    
                }
            }];
            
        }];
    }
    else {
        //移除
        editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"取消收藏" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            NSArray *arr = (NSArray *)self.data;
            MemberCardModel *memberCard = arr[indexPath.section];
            [UIAlertView bk_showAlertViewWithTitle:@"是否确认取消收藏" message:[NSString stringWithFormat:@"%@",memberCard.cardname] cancelButtonTitle:@"取消" otherButtonTitles:@[@"确认"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    NSMutableArray *arr = (NSMutableArray *)self.data;
                    MemberCardModel *memberCard = arr[indexPath.section];
                    // 收藏会员卡
                    [[UIApplication sharedApplication].keyWindow.rootViewController presentLoadingTips:nil];
                    
                    [[BaseNetConfig shareInstance] configGlobalAPI:KAKATOOL];
                    
                    OperateMemberCardAPI *addMemberCardApi = [[OperateMemberCardAPI alloc]initWithCardId:memberCard.cardid cardType:@"2"];
                    addMemberCardApi.operateMemberCardType = cancnelCollectMemberCardType;
                    [addMemberCardApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                        [[UIApplication sharedApplication].keyWindow.rootViewController dismissTips];
                        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
                        if (![ISNull isNilOfSender:result] && [result[@"code"] intValue] == 0) {
                            
                            memberCard.isfav = @"0";
                            [arr replaceObjectAtIndex:indexPath.section withObject:memberCard];
                            if ([self.delegate respondsToSelector:@selector(didCollectMemberCardWithArr:)]) {
                                [self.delegate didCollectMemberCardWithArr:arr];
                            }
                        }else{
                            [self presentFailureTips:result[@"message"]];
                        }
                    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                        [self presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
                    }];
                    
                    
                    
                }
            }];
            
        }];
    }
    
    //    editAction.backgroundColor = [UIColor purpleColor];
    return @[deleteAction,editAction];
}

//解决滑动时sectionfooterview粘住的问题
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tv)
    {
        UITableView *tableview = (UITableView *)scrollView;
        CGFloat sectionHeaderHeight = 64;
        CGFloat sectionFooterHeight = 120;
        CGFloat offsetY = tableview.contentOffset.y;
        if (offsetY >= 0 && offsetY <= sectionHeaderHeight)
        {
            tableview.contentInset = UIEdgeInsetsMake(-offsetY, 0, -sectionFooterHeight, 0);
        }else if (offsetY >= sectionHeaderHeight && offsetY <= tableview.contentSize.height - tableview.frame.size.height - sectionFooterHeight)
        {
            tableview.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, -sectionFooterHeight, 0);
        }else if (offsetY >= tableview.contentSize.height - tableview.frame.size.height - sectionFooterHeight && offsetY <= tableview.contentSize.height - tableview.frame.size.height)         {
            tableview.contentInset = UIEdgeInsetsMake(-offsetY, 0, -(tableview.contentSize.height - tableview.frame.size.height - sectionFooterHeight), 0);
        }
    }
}


@end

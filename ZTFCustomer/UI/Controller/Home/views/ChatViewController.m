 //
//  ChatViewController.m
//  ztfCustomer
//
//  Created by mac on 16/7/13.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "ChatViewController.h"
//#import "ImageApi.h"
#import "ChatUser.h"
#import "ChatUserManager.h"

@interface ChatViewController ()<UIAlertViewDelegate, EaseMessageViewControllerDelegate, EaseMessageViewControllerDataSource,EMClientDelegate>
{
    UIMenuItem *_copyMenuItem;
    UIMenuItem *_deleteMenuItem;
}

@property (nonatomic) BOOL isPlayingAudio;
@property(nonatomic) BOOL isFromOthers;

@property (nonatomic) NSMutableDictionary *emotionDic;

@end

@implementation ChatViewController

- (instancetype)initWithConversationChatter:(NSString *)conversationChatter
                           conversationType:(EMConversationType)conversationType FromOther:(BOOL)yesOrNo
{
    if (self=[super initWithConversationChatter:conversationChatter conversationType:conversationType]) {
        _isFromOthers =yesOrNo;
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.navigationItem.leftBarButtonItem = [AppTheme backItemWithHandler:^(id sender) {
//        [self.navigationController popViewControllerAnimated:YES];
//    }];

    [self.chatBarMoreView removeItematIndex:4];
    [self.chatBarMoreView removeItematIndex:3];
    
    self.showRefreshHeader = YES;
    self.delegate = self;
    self.dataSource = self;
    
    [self _setupBarButtonItem];
    
    // 头像尺寸和圆角
    [[EaseBaseMessageCell appearance] setAvatarSize:40.f];
    [[EaseBaseMessageCell appearance] setAvatarCornerRadius:2.f];
 
    [[EMClient sharedClient] addDelegate:self delegateQueue:nil];
    
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteAllMessages:) name:KNOTIFICATIONNAME_DELETEALLMESSAGE object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[EMClient sharedClient] removeDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[AppDelegate sharedAppDelegate].tabController setTabBarHidden:YES animated:YES];
    
    [self showNavBarFromOthers];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
//    [self hideNavBarFromOthers];
}

-(void)showNavBarFromOthers
{
    if (self.isFromOthers) {
        [self.navigationController setNavigationBarHidden:NO];
        [self.navigationController.navigationBar setHidden:NO];
        self.navigationController.navigationBar.translucent = NO;
        UINavigationBar *bar = self.navigationController.navigationBar;
        bar.barTintColor = NAV_BG_COLOR;
        bar.tintColor = [UIColor whiteColor];
        [bar setTitleTextAttributes:@{
                                      NSFontAttributeName: [UIFont systemFontOfSize:17],
                                      NSForegroundColorAttributeName: NAV_TEXTCOLOR,
                                      }];
        self.navigationItem.leftBarButtonItem = [AppTheme backItemWithHandler:^(id sender) {
            [[EMClient sharedClient].chatManager removeDelegate:self];
            
            if (self.deleteConversationIfNull) {
                //判断当前会话是否为空，若符合则删除该会话
                EMMessage *message = [self.conversation latestMessage];
                if (message == nil) {
                    [[EMClient sharedClient].chatManager deleteConversation:self.conversation.conversationId deleteMessages:NO];
                }
            }

            [self.navigationController popViewControllerAnimated:YES];
        }];
        self.navigationItem.rightBarButtonItem = [AppTheme itemWithContent:[UIImage imageNamed:@"icon_delete"] handler:^(id sender) {
            if (self.dataArray.count == 0) {
                [self showHint:NSLocalizedString(@"没有信息", @"no messages")];
                return;
            }
             
            [UIAlertView bk_showAlertViewWithTitle:NSLocalizedString(@"提示", @"Prompt") message:NSLocalizedString(@"确定删除", @"please make sure to delete") cancelButtonTitle:NSLocalizedString(@"取消", @"Cancel") otherButtonTitles:@[NSLocalizedString(@"确定", @"OK")] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    self.messageTimeIntervalTag = -1;
                    [self.conversation deleteAllMessages];
                    [self.dataArray removeAllObjects];
                    [self.messsagesSource removeAllObjects];
                    
                    [self.tableView reloadData];
                }
            }];
        }];
    }
    
}

-(void)hideNavBarFromOthers
{
    if (self.isFromOthers) {
//        [self.navigationController setNavigationBarHidden:NO];
//        [self.navigationController.navigationBar setHidden:YES];
//        self.navigationController.navigationBar.translucent = NO;
    }
}


#pragma mark - setup subviews

- (void)_setupBarButtonItem
{
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backButton setImage:[UIImage imageNamed:@"nav_icon_left_arrow"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.cancelButtonIndex != buttonIndex) {
        self.messageTimeIntervalTag = -1;
        [self.conversation deleteAllMessages];
        [self.dataArray removeAllObjects];
        [self.messsagesSource removeAllObjects];
        
        [self.tableView reloadData];
    }
}

#pragma mark - EaseMessageViewControllerDelegate

- (BOOL)messageViewController:(EaseMessageViewController *)viewController
   canLongPressRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (BOOL)messageViewController:(EaseMessageViewController *)viewController
   didLongPressRowAtIndexPath:(NSIndexPath *)indexPath
{
    id object = [self.dataArray objectAtIndex:indexPath.row];
    if (![object isKindOfClass:[NSString class]]) {
        EaseMessageCell *cell = (EaseMessageCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        [cell becomeFirstResponder];
        self.menuIndexPath = indexPath;
        [self _showMenuViewController:cell.bubbleView andIndexPath:indexPath messageType:cell.model.bodyType];
    }
    return YES;
}

- (void)messageViewController:(EaseMessageViewController *)viewController
  didSelectAvatarMessageModel:(id<IMessageModel>)messageModel
{
    
    
}

#pragma mark - EaseMessageViewControllerDataSource

- (id<IMessageModel>)messageViewController:(EaseMessageViewController *)viewController
                           modelForMessage:(EMMessage *)message
{
    id<IMessageModel> model = nil;
    model = [[EaseMessageModel alloc] initWithMessage:message];
//    model.avatarURLPath = message.ext[@"IMicon"];
//    model.nickname = message.ext[@"IMname"];
    
    model.avatarImage = [UIImage imageNamed:@"EaseUIResource.bundle/user"];
    model.failImageName = @"EaseUIResource.bundle/imageDownloadFail";

    if (message.direction==EMMessageDirectionSend) {
        //发送的信息，显示自己姓名与头像
        UserModel *user = [[LocalData shareInstance] getUserAccount];
        if(user){
            model.nickname = user.realname.length==0?user.loginname:user.realname;
            model.avatarURLPath = user.iconurl;
            
            message.ext = @{@"IMname":model.nickname,
                            @"IMicon":model.avatarURLPath};
        }
    }
    else{
        //如果是聊天超级管理员，则不处理
        if ([self.conversation.conversationId isEqualToString:@"admin"]) {
            model.nickname = @"管理员";
            
            return model;
        }
        //        //其他会员
        //        PropertyConstrulantModel *chatuser = [STICache.global objectForKey:@"chatUser"];
        //
        //        if (!chatuser) {
        //            [[ChatUserManager shareInstance] saveChatUserByIm:self.conversation.conversationId];
        //
        //             PropertyConstrulantModel *chatuser = [STICache.global objectForKey:@"chatUser"];
        //
        //            model.nickname = chatuser.name;
        //            model.avatarURLPath = chatuser.headImg;
        //        }
        //        else{
        //            model.nickname = chatuser.name;
        //            model.avatarURLPath = chatuser.headImg;
        //        }
        //        message.ext = @{@"name":model.nickname,
        //                        @"icon":model.avatarURLPath};
        
    }
    
//    model.avatarURLPath = message.ext[@"icon"];
//    model.nickname = message.ext[@"name"];
    
    
    
    return model;
}

- (NSArray*)emotionFormessageViewController:(EaseMessageViewController *)viewController
{
    NSMutableArray *emotions = [NSMutableArray array];
    for (NSString *name in [EaseEmoji allEmoji]) {
        EaseEmotion *emotion = [[EaseEmotion alloc] initWithName:@"" emotionId:name emotionThumbnail:name emotionOriginal:name emotionOriginalURL:@"" emotionType:EMEmotionDefault];
        [emotions addObject:emotion];
    }
    EaseEmotion *temp = [emotions objectAtIndex:0];
    EaseEmotionManager *managerDefault = [[EaseEmotionManager alloc] initWithType:EMEmotionDefault emotionRow:3 emotionCol:7 emotions:emotions tagImage:[UIImage imageNamed:temp.emotionId]];
    
    return @[managerDefault];
}

- (BOOL)isEmotionMessageFormessageViewController:(EaseMessageViewController *)viewController
                                    messageModel:(id<IMessageModel>)messageModel
{
    BOOL flag = NO;
    if ([messageModel.message.ext objectForKey:MESSAGE_ATTR_IS_BIG_EXPRESSION]) {
        return YES;
    }
    return flag;
}

- (EaseEmotion*)emotionURLFormessageViewController:(EaseMessageViewController *)viewController
                                      messageModel:(id<IMessageModel>)messageModel
{
    NSString *emotionId = [messageModel.message.ext objectForKey:MESSAGE_ATTR_EXPRESSION_ID];
    EaseEmotion *emotion = [_emotionDic objectForKey:emotionId];
    if (emotion == nil) {
        emotion = [[EaseEmotion alloc] initWithName:@"" emotionId:emotionId emotionThumbnail:@"" emotionOriginal:@"" emotionOriginalURL:@"" emotionType:EMEmotionGif];
    }
    return emotion;
}

- (NSDictionary*)emotionExtFormessageViewController:(EaseMessageViewController *)viewController
                                        easeEmotion:(EaseEmotion*)easeEmotion
{
    return @{MESSAGE_ATTR_EXPRESSION_ID:easeEmotion.emotionId,MESSAGE_ATTR_IS_BIG_EXPRESSION:@(YES)};
}


#pragma mark - EMClientDelegate

- (void)didLoginFromOtherDevice
{
    if ([self.imagePicker.mediaTypes count] > 0 && [[self.imagePicker.mediaTypes objectAtIndex:0] isEqualToString:(NSString *)kUTTypeMovie]) {
        [self.imagePicker stopVideoCapture];
    }
}

- (void)didRemovedFromServer
{
    if ([self.imagePicker.mediaTypes count] > 0 && [[self.imagePicker.mediaTypes objectAtIndex:0] isEqualToString:(NSString *)kUTTypeMovie]) {
        [self.imagePicker stopVideoCapture];
    }
}

#pragma mark - action

- (void)backAction
{
    [[EMClient sharedClient].chatManager removeDelegate:self];
    
    if (self.deleteConversationIfNull) {
        //判断当前会话是否为空，若符合则删除该会话
        EMMessage *message = [self.conversation latestMessage];
        if (message == nil) {
            [[EMClient sharedClient].chatManager deleteConversation:self.conversation.conversationId deleteMessages:NO];
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

//删除所有信息
- (void)deleteAllMessages:(id)sender
{
    if (self.dataArray.count == 0) {
        [self showHint:NSLocalizedString(@"message.noMessage", @"no messages")];
        return;
    }
    
    if ([sender isKindOfClass:[NSNotification class]]) {
        NSString *groupId = (NSString *)[(NSNotification *)sender object];
        BOOL isDelete = [groupId isEqualToString:self.conversation.conversationId];
        if (self.conversation.type != EMConversationTypeChat && isDelete) {
            self.messageTimeIntervalTag = -1;
            [self.conversation deleteAllMessages];
            [self.messsagesSource removeAllObjects];
            [self.dataArray removeAllObjects];
            
            [self.tableView reloadData];
            [self showHint:NSLocalizedString(@"message.noMessage", @"no messages")];
        }
    }
    else if ([sender isKindOfClass:[UIButton class]]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"sureToDelete", @"please make sure to delete") delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"Cancel") otherButtonTitles:NSLocalizedString(@"ok", @"OK"), nil];
        [alertView show];
    }
}

//复制
- (void)copyMenuAction:(id)sender
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    if (self.menuIndexPath && self.menuIndexPath.row > 0) {
        id<IMessageModel> model = [self.dataArray objectAtIndex:self.menuIndexPath.row];
        pasteboard.string = model.text;
    }
    
    self.menuIndexPath = nil;
}

//删除
- (void)deleteMenuAction:(id)sender
{
    if (self.menuIndexPath && self.menuIndexPath.row > 0) {
        id<IMessageModel> model = [self.dataArray objectAtIndex:self.menuIndexPath.row];
        NSMutableIndexSet *indexs = [NSMutableIndexSet indexSetWithIndex:self.menuIndexPath.row];
        NSMutableArray *indexPaths = [NSMutableArray arrayWithObjects:self.menuIndexPath, nil];
        
        [self.conversation deleteMessageWithId:model.message.messageId];
        [self.messsagesSource removeObject:model.message];
        
        if (self.menuIndexPath.row - 1 >= 0) {
            id nextMessage = nil;
            id prevMessage = [self.dataArray objectAtIndex:(self.menuIndexPath.row - 1)];
            if (self.menuIndexPath.row + 1 < [self.dataArray count]) {
                nextMessage = [self.dataArray objectAtIndex:(self.menuIndexPath.row + 1)];
            }
            if ((!nextMessage || [nextMessage isKindOfClass:[NSString class]]) && [prevMessage isKindOfClass:[NSString class]]) {
                [indexs addIndex:self.menuIndexPath.row - 1];
                [indexPaths addObject:[NSIndexPath indexPathForRow:(self.menuIndexPath.row - 1) inSection:0]];
            }
        }
        
        [self.dataArray removeObjectsAtIndexes:indexs];
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
        
        if ([self.dataArray count] == 0) {
            self.messageTimeIntervalTag = -1;
        }
    }
    
    self.menuIndexPath = nil;
}


#pragma mark - private

- (void)_showMenuViewController:(UIView *)showInView
                   andIndexPath:(NSIndexPath *)indexPath
                    messageType:(EMMessageBodyType)messageType
{
    if (self.menuController == nil) {
        self.menuController = [UIMenuController sharedMenuController];
    }
    
    if (_deleteMenuItem == nil) {
        _deleteMenuItem = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"delete", @"Delete") action:@selector(deleteMenuAction:)];
    }
    
    if (_copyMenuItem == nil) {
        _copyMenuItem = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"copy", @"Copy") action:@selector(copyMenuAction:)];
    }
    
    
    if (messageType == EMMessageBodyTypeText) {
        [self.menuController setMenuItems:@[_copyMenuItem, _deleteMenuItem]];
    } else if (messageType == EMMessageBodyTypeImage){
        [self.menuController setMenuItems:@[_deleteMenuItem]];
    } else {
        [self.menuController setMenuItems:@[_deleteMenuItem]];
    }
    [self.menuController setTargetRect:showInView.frame inView:showInView.superview];
    [self.menuController setMenuVisible:YES animated:YES];
}

@end

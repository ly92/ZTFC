//
//  ComplaintDetailController.m
//  WeiTown
//
//  Created by Ender on 8/29/15.
//  Copyright (c) 2015 Hairon. All rights reserved.
//

#import "ComplaintDetailController.h"
#import "CommentController.h"
#import "SelectCommunityController.h"
#import "SJAvatarBrowser.h"

@interface ComplaintDetailController ()<UIActionSheetDelegate>


@property (weak, nonatomic) IBOutlet UIImageView *uploadImg;
@property (retain, nonatomic) IBOutlet UIScrollView *sv;

@property (retain, nonatomic) IBOutlet UIView *containerView;
@property (retain, nonatomic) IBOutlet UIView *communityView;
@property (retain, nonatomic) IBOutlet UILabel *lblCommunity;
@property (retain, nonatomic) IBOutlet UIPlaceHolderTextView *txtContent;
@property (retain, nonatomic) IBOutlet UILabel *lblDate;
@property (retain, nonatomic) IBOutlet UITextField *lblName;
@property (retain, nonatomic) IBOutlet UITextField *lblMobile;
@property (retain, nonatomic) IBOutlet UIPlaceHolderTextView *txtAddress;
@property (retain, nonatomic) IBOutlet UIButton *btnSubmit;
@property (retain, nonatomic) IBOutlet UILabel *lblImage;
@property (retain, nonatomic) IBOutlet UILabel *lblCommunityTitle;

@property(nonatomic,retain) Community *community;
@property(nonatomic,retain) NSString *maintype;
@property(nonatomic,retain) ComplaintModel *order;
@property(nonatomic,retain) NSData *uploadData;

@property (strong, nonatomic) UIImage *uploadImage;

@end

@implementation ComplaintDetailController

#pragma mark - 视图生命周期

- (instancetype)initWithMainType:(NSString *)aType Order:(ComplaintModel *)item
{
    self = [super init];
    if (self) {
        self.maintype = aType;
        self.order = item;
        self.community=nil;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.btnSubmit setTitleColor:BLUE_TEXTCOLOR forState:UIControlStateNormal];
    [self navigationBar];
    [self prepareLayout];
    
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)navigationBar{
    if([self.maintype isEqualToString:@"1"]){
        self.navigationItem.title = @"投诉";
    }else{
        self.navigationItem.title = @"建议";
    }
    
    self.navigationItem.leftBarButtonItem = [AppTheme backItemWithHandler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark - 布局
-(void)prepareLayout{
    
//    if (IS_IPHONE_5) {
//        [self.sv fixYForIPhone5:NO addHight:YES];
//    }
    
    self.sv.contentSize = CGSizeMake(SCREENWIDTH, 617);
    
    [self.sv addSubview:self.containerView];
    
    if ([self.maintype isEqualToString:@"1"]) {
        self.txtContent.placeholder=@"请描述需要投诉的情况";
        self.lblCommunityTitle.text = @"目前您要投诉的小区为";
        self.lblDate.text = @"投诉时间(系统按照当前默认)";
    }
    else{
        self.txtContent.placeholder=@"请描述需要建议的情况";
        self.lblCommunityTitle.text = @"目前您要建议的小区为";
        self.lblDate.text = @"建议时间(系统按照当前默认)";
    }
    
    [self.uploadImg addTapAction:@selector(uploadImage:) forTarget:self];
    
    [self listenToKeyboard];
}




#pragma mark - 数据
-(void)loadData{
    
    if (self.order) {
        
        
        self.lblCommunity.text = self.order.communityname;
        self.txtContent.text = self.order.content;
        self.lblName.text=self.order.username;
        self.lblMobile.text = self.order.mobile;
        self.txtAddress.text = self.order.address;
        
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[self.order.modifiedtime  longLongValue]];
        self.lblDate.text = [date stringWithFormat:@"yyyy-MM-dd HH:mm"];
        
        NSString *imageurl = self.order.image;
        if ([imageurl complyWithTheRulesOfImage]) {
            
            [self.uploadImg setImageWithURL:[NSURL URLWithString:imageurl] placeholder:[UIImage imageNamed:@""]];
            
        }
        self.lblImage.hidden=YES;
        [self.btnSubmit setTitle:@"评价" forState:UIControlStateNormal];
        
        
        [self.txtContent setEditable:NO];
        [self.lblName setEnabled:NO];
        [self.lblMobile setEnabled:NO];
        [self.txtAddress setEditable:NO];
        
        //根据tag隐藏必填图片
        for (UIView *subView in self.containerView.subviews) {
            if (subView.subviews.count>0) {
                for (UIView *subView2 in subView.subviews){
                    if (subView2.tag>100) {
                        subView2.hidden=YES;
                    }
                }
                
            }
            
            if (subView.tag>100) {
                subView.hidden=YES;
            }
        }
        
        
        
    }
    else{
         UserModel *userModel = [[LocalData shareInstance]getUserAccount];
        self.community = [STICache.global objectForKey:[NSString stringWithFormat:@"%@_crcc",userModel.mobile]];
        if (self.community) {
            self.lblCommunity.text = self.community.name;
        }
        
        UserModel *user = [[LocalData shareInstance]getUserAccount];
        if (user) {
            self.lblName.text = user.realname;
            self.lblMobile.text = user.mobile;
            self.txtAddress.text = user.address;
        }
    }
    
    
    
    
}


#pragma mark - 事件
//点击选择小区
- (IBAction)communityViewClick:(id)sender {
    if (self.order) {
        return;
    }
    
    SelectCommunityController *selectCommunity=[[SelectCommunityController alloc] init];
    
    selectCommunity.selectCommunity = ^(NSDictionary *str){
        
       self.community = [Community mj_objectWithKeyValues:str];
       self.lblCommunity.text = self.community.name;
    };
    
    [self.navigationController pushViewController:selectCommunity animated:YES];
}

//提交数据
- (IBAction)submit:(id)sender{
    
    [self.view endEditing:YES];
    
//    //若已提交订单，跳转到点评
    if (self.order) {
        
        NSString *orderId=self.order.id;
        if (orderId) {
            CommentController *comment=[[CommentController alloc] initWIthType:@"2" ThirdNO:orderId];
            [self.navigationController pushViewController:comment animated:YES];
            return;
        }
    }
    
    //否则提交新订单
    if (!self.community) {
        [self presentFailureTips:@"请选择小区"];
    
        return;
    }
    if (!self.txtContent.text||[self.txtContent.text trim].length==0) {
        [self presentFailureTips:@"请填写内容"];
        
        return;
    }
    if (!self.lblName.text||[self.lblName.text trim].length==0) {
        [self presentFailureTips:@"请填写名称"];
     
        return;
    }
    if (!self.lblMobile.text||[self.lblMobile.text trim].length==0) {
        [self presentFailureTips:@"请填写手机号码"];
        return;
    }
    if (!self.txtAddress.text||[self.txtAddress.text trim].length==0) {
        [self presentFailureTips:@"请填写地址"];
        return;
    }
    
    NSString *communityid = self.community.bid;
    if (!communityid) {
        [self presentFailureTips:@"请选择小区"];
        return;
    }
    
    
    [[BaseNetConfig shareInstance]configGlobalAPI:WETOWN];
    [self presentLoadingTips:nil];
    
    ApplyComplaintAPI *applyComplaintApi = [[ApplyComplaintAPI alloc]initWithCommunityid:communityid type:self.maintype content:self.txtContent.text username:self.lblName.text mobile:self.lblMobile.text address:self.txtAddress.text image:self.uploadImage];
    
    
    [applyComplaintApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        
        if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
            
            [self presentSuccessTips:@"提交成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESH_COMPLAINT" object:nil];
            
            [self.navigationController popViewControllerAnimated:YES];
            
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

//隐藏键盘
- (IBAction)hideKeyboardClicked:(id)sender{
    [self.view endEditing:YES];
}

//选择小区
-(void)chooseCommunity:(id)sender{
    
    if (self.order) {
        return;
    }
    
    SelectCommunityController *selectCommunity=[[SelectCommunityController alloc] init];
    [self.navigationController pushViewController:selectCommunity animated:YES];
}


//上传图片
-(void)uploadImage:(id)sender{
    
    [self.view endEditing:YES];
    if (self.order) {
        [self popupImage];
    }
    else{
        [self popupPicker];
    }
    
    
    
}

#pragma mark - 弹出大图片
-(void)popupImage
{
    
     NSString *imageurl = self.order.image;
    if (imageurl.length > 0) {
        [SJAvatarBrowser
         showImage:self.uploadImg];
    }
    

    
//    NSString *imageurl = self.order.image;

//    if (self.popView == nil) {
//        self.popView = [[PopCouponSN alloc] initWithParentController:self.parentViewController];
//    }
//    if (self.popView) {
//        [self.popView showCard:imageurl];
//    }
//    UIWindow *window = [UIApplication sharedApplication].keyWindow;
//    [window addSubview:self.popView];
    
//    NSString *imageurl = [self.order objectForKey:@"image"];
//    
//    if ([imageurl complyWithTheRulesOfImage]) {
//        if (_imagePopup==nil) {
//            _imagePopup = [[PopupImageView alloc] initWithParentController:self ImageUrl:imageurl];
//        }
//        else{
//            [_imagePopup changeHeaderImage:imageurl];
//        }
//        [self.imagePopup show];
//        
//    }
    
}

#pragma mark - delegate

- (IBAction)hidekeyboardClick:(id)sender {
    [self.view endEditing:YES];
}

#pragma mark - 键盘

-(void)listenToKeyboard
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    [nc addObserver:self selector:@selector(keyboardWillShow:) name:
     UIKeyboardWillShowNotification object:nil];
    
    [nc addObserver:self selector:@selector(keyboardWillHide:) name:
     UIKeyboardWillHideNotification object:nil];
}

-(void)keyboardWillShow:(NSNotification *)note {
    
    NSDictionary* userInfo = [note userInfo];
    
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    
    CGRect keyboardEndFrame;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    CGRect keyboardFrame = [self.view convertRect:keyboardEndFrame toView:nil];
    
    self.sv.contentInset = UIEdgeInsetsMake(0,0,keyboardFrame.size.height,0);
    
}

-(void)keyboardWillHide:(NSNotification *)note
{
    self.sv.contentInset = UIEdgeInsetsMake(0,0,0,0);
}


#pragma mark - 上传图片
-(void)popupPicker
{
    
    
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
    
    sheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    
    [sheet showInView:self.view];
    
}
#pragma mark-actionsheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        //拍照
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.allowsEditing=YES;
            picker.delegate=self;
            [self presentViewController:picker animated:YES completion:nil];
        }
    }else if (buttonIndex == 1) {
        //相册
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            picker.allowsEditing=YES;
            picker.delegate=self;
            [self presentViewController:picker animated:YES completion:nil];
        }
        
    }else if(buttonIndex == 2) {
    }
    
}

#pragma mark - getImage
// 拍照
-(void) takePhoto
{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        [picker setDelegate:self];
        [picker setAllowsEditing:YES];
        [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
        [self presentViewController:picker animated:YES completion:nil];
    }
}

// 获取相册
-(void) pickInPhoto
{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        [picker setDelegate:self];
        [picker setAllowsEditing:YES];
        [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [self presentViewController:picker animated:YES completion:nil];
    }
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if (info) {
        UIImage *editImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];

        if (editImage) {
            if (editImage.size.width>1024||editImage.size.height>1024) {
                
                float newWidth = 1024;
                float newHeight = 1024;
                
                
                if (editImage.size.width>editImage.size.height) {
                    
                    float radio = editImage.size.width/1024;
                    
                    newHeight = editImage.size.height/radio;
                    
                }
                else{
                    
                    float radio = editImage.size.height/1024;
                    
                    newWidth = editImage.size.width/radio;
                }
                
                
                NSLog(@"new width:%f,new height:%f",newWidth,newHeight);
                
//                editImage = [editImage resizedImage:CGSizeMake(newWidth, newHeight) interpolationQuality:kCGInterpolationMedium];
                
            }
        }
        
        self.uploadData =UIImageJPEGRepresentation(editImage,1.0);
        self.uploadImg.image = editImage;
        self.uploadImage = editImage;
        
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    self.uploadData=nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

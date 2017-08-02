//
//  RepairPersonDetailController.m
//  WeiTown
//
//  Created by Ender on 8/29/15.
//  Copyright (c) 2015 Hairon. All rights reserved.
//

#import "RepairPersonDetailController.h"
#import "CommentController.h"
#import "SJAvatarBrowser.h"

@interface RepairPersonDetailController ()<UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (retain, nonatomic) IBOutlet UIScrollView *sv;

@property (retain, nonatomic) IBOutlet UIView *containerView;
@property (retain, nonatomic) IBOutlet UIView *communityView;
@property (retain, nonatomic) IBOutlet UILabel *lblCommunity;
@property (retain, nonatomic) IBOutlet UIView *sutypeView;
@property (retain, nonatomic) IBOutlet UILabel *lblSubtype;
@property (retain, nonatomic) IBOutlet UIPlaceHolderTextView *txtContent;
@property (retain, nonatomic) IBOutlet UILabel *lblDate;
@property (retain, nonatomic) IBOutlet UIImageView *uploadImg;
@property (retain, nonatomic) IBOutlet UITextField *lblName;
@property (retain, nonatomic) IBOutlet UITextField *lblMobile;
@property (retain, nonatomic) IBOutlet UIPlaceHolderTextView *txtAddress;
@property (retain, nonatomic) IBOutlet UIButton *btnSubmit;
@property (retain, nonatomic) IBOutlet UILabel *lblImage;

@property (retain, nonatomic) IBOutlet UITextField *lblUnit;

- (IBAction)submit:(id)sender;
- (IBAction)hideKeyboardClicked:(id)sender;

@property(nonatomic,retain) Community *community;
@property(nonatomic,retain) RepairSubtypeModel *subtype;
@property(nonatomic,retain) NSString *maintype;
@property(nonatomic,retain) ComplaintModel *order;
@property(nonatomic,retain) NSData *uploadData;

@property (strong, nonatomic) UIImage *uploadImage;

@end

@implementation RepairPersonDetailController

#pragma mark - 视图生命周期

- (instancetype)initWithMainType:(NSString *)aType Order:(ComplaintModel *)item
{
    self = [super init];
    if (self) {
        self.maintype = aType;
        self.order = item;
        self.community=nil;
        self.subtype=nil;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.btnSubmit setTitleColor:BLUE_TEXTCOLOR forState:UIControlStateNormal];
    [self navigationBar];
    [self prepareLayout];
    [self setToolbar];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)navigationBar{
    if (self.maintype) {
        
        if([self.maintype isEqualToString:@"1"]){
            self.navigationItem.title = @"公共维修";
        }else{
            self.navigationItem.title = @"个人维修";
        }
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
    
    self.sv.contentSize = CGSizeMake(320, 791);
    
    [self.sv addSubview:self.containerView];
    
    self.txtContent.placeholder=@"请描述需要维修的情况";
    
    [self.communityView addTapAction:@selector(chooseCommunity:) forTarget:self];
    [self.sutypeView addTapAction:@selector(chooseSubtype:) forTarget:self];
    [self.uploadImg addTapAction:@selector(uploadImage:) forTarget:self];
    
    [self listenToKeyboard];
}

#pragma mark - 数据
-(void)loadData{
    
    if (!self.order) {
        
         UserModel *userModel = [[LocalData shareInstance]getUserAccount];
        self.community = [STICache.global objectForKey:[NSString stringWithFormat:@"%@_crcc",userModel.mobile]];
        if (self.community) {
            self.lblCommunity.text = self.community.name;
            NSString *communityid = self.community.bid;
            if (communityid) {
                [self loadUnit:communityid];
            }
        }
        UserModel *user = [[LocalData shareInstance]getUserAccount];
        if (user) {
            self.lblName.text = user.realname;
            self.lblMobile.text = user.mobile;
            self.txtAddress.text = user.address;
        }
        
    }
    else{
        
        self.lblCommunity.text = self.order.communityname;
        self.lblUnit.text = self.order.unit;
        self.lblSubtype.text =self.order.typeName;
        self.txtContent.text = self.order.content;
        self.lblName.text=self.order.username;
        self.lblMobile.text = self.order.mobile;
        self.txtAddress.text = self.order.address;
        
        
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[self.order.modifiedtime  longLongValue]];
        self.lblDate.text = [date stringWithFormat:@"yyyy-MM-dd HH:mm"];
        
        NSString *imageurl = self.order.image;
        if ([imageurl complyWithTheRulesOfImage]) {
            self.uploadImg.imageURL = [NSURL URLWithString:imageurl];
            
        }
        self.lblImage.hidden=YES;
        
        [self.btnSubmit setTitle:@"评价" forState:UIControlStateNormal];
        
        [self.lblUnit setEnabled:NO];
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
}

-(void)loadUnit:(NSString *)communityid
{
    
    [[BaseNetConfig shareInstance]configGlobalAPI:WETOWN];
    GetRepairUnitAPI *getRepairUnitApi = [[GetRepairUnitAPI alloc]initWithCommunityid:communityid];
    [getRepairUnitApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
            
            NSString *unit = [result objectForKey:@"unit"];
            if (unit) {
                self.lblUnit.text = unit;
            }

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


#pragma mark - 事件


//提交数据
- (IBAction)submit:(id)sender{
    [self.view endEditing:YES];
    //若已提交订单，跳转到点评
    if (self.order) {
        
        NSString *orderId=self.order.id;
        if (orderId) {
            CommentController *comment=[[CommentController alloc] initWIthType:@"1" ThirdNO:orderId];
            [self.navigationController pushViewController:comment animated:YES];
            return;
        }
    }
    
    //否则提交新订单
    if (!self.community) {
        [self presentFailureTips:@"请选择小区"];
     
        return;
    }
    if (!self.lblUnit.text||[self.lblUnit.text trim].length==0) {
        [self presentFailureTips:@"请填写单元"];
        return;
    }
    if (!self.subtype) {
        [self presentFailureTips:@"请选择维修类型"];
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
    
    NSString *subtypeid = self.subtype.id;
    if (!subtypeid) {
        [self presentFailureTips:@"请选择维修类型"];
        return;
    }
    
    [self presentLoadingTips:nil];
    
    [[BaseNetConfig shareInstance]configGlobalAPI:WETOWN];
    ApplyRepairAPI *applyRepairApi = [[ApplyRepairAPI alloc]initWithCommunityid:communityid unit:self.lblUnit.text maintype:self.maintype subtype:subtypeid content:self.txtContent.text username:self.lblName.text mobile:self.lblMobile.text address:self.txtAddress.text image:self.uploadImage];
    [applyRepairApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) { 
        
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
            [self presentSuccessTips:@"提交成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESH_REPAIR" object:nil];
            
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
    [self.view endEditing:YES];
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

//选择子类型
-(void)chooseSubtype:(id)sender{
    [self.view endEditing:YES];
    if (self.order) {
        return;
    }
    SelectRepairSubtypeController *selectSubtype=[[SelectRepairSubtypeController alloc] initWithMainType:self.maintype];
    selectSubtype.selectSubtype = ^(RepairSubtypeModel *selectModel){
        self.subtype = selectModel;
        self.lblSubtype.text = self.subtype.name;
    };
    [self.navigationController pushViewController:selectSubtype animated:YES];
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
}
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


-(void)setToolbar{
    //添加toobar
    UIToolbar *toobar= [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 38.0f)];
    toobar.barStyle        = UIBarStyleDefault;
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneBarItem    = [[UIBarButtonItem alloc] initWithTitle:@"完成"
                                                                       style:UIBarButtonItemStyleDone target:self action:@selector(resignKeyboard)];
    
    [toobar setItems:[NSArray arrayWithObjects:flexibleSpace,doneBarItem, nil]];
    self.txtContent.inputAccessoryView   = toobar;
    self.txtAddress.inputAccessoryView = toobar;
    self.lblName.inputAccessoryView = toobar;
    self.lblMobile.inputAccessoryView = toobar;
    self.lblUnit.inputAccessoryView = toobar;
    
}
-(void)resignKeyboard{
    [self.view endEditing:YES];
}
@end

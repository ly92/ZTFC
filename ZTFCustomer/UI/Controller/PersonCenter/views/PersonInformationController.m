//
//  PersonInformationController.m
//  EstateBiz
//
//  Created by wangshanshan on 16/6/15.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import "PersonInformationController.h"
#import "ModifyUsernameController.h"//姓名、地址、邮箱修改
#import "ModifyMobileController.h"
#import "CLPickerView.h"

@interface PersonInformationController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIDatePickerSheetDelegate,CLPickerViewDelegate>
{
    NSInteger _seletedSex;
    NSArray *_sexArray;
}

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;


@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;


@property (weak, nonatomic) IBOutlet UITextField *sexTextField;

@property (weak, nonatomic) IBOutlet UITextField *birthTextField;

@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;


@property (retain, nonatomic)UIDatePickerSheetController *datePicker;

@property (nonatomic, strong) UserModel *user;

@end

@implementation PersonInformationController

+(instancetype)spawn{
    return [PersonInformationController loadFromStoryBoard:@"PersonalCenter"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
     _sexArray = [NSArray arrayWithObjects:@"男",@"女", nil];
    
    [self.tableView tableViewRemoveExcessLine];
    
    self.tableView.backgroundColor = VIEW_BG_COLOR;
    
    [self setNavigationBar];
    
    self.userImageView.layer.cornerRadius = 3;
    
    [self prepareData];
    
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

-(void)setNavigationBar{
    
    self.navigationItem.title = @"个人信息";
    
    self.navigationItem.leftBarButtonItem = [AppTheme backItemWithHandler:^(id sender) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
    
    self.navigationItem.rightBarButtonItem = [AppTheme itemWithContent:@"保存" handler:^(id sender) {
        
        NSString *name = self.user.loginname;
        
        NSString *realname = self.user.realname;
        
        NSString *tel = self.user.mobile;
        
        NSString *identityno = self.user.identityid;
        
        NSString *addr = self.user.address;
        
        NSString *email = self.user.email;
        
        NSString *gender = self.user.gender;
        
        NSString *birthday = self.user.birthday;

        
        NSMutableDictionary *dicInfo = [NSMutableDictionary dictionary];
        [dicInfo setObject:addr forKey:@"address"];
        [dicInfo setObject:name forKey:@"username"];
        [dicInfo setObject:realname forKey:@"realname"];
        [dicInfo setObject:email forKey:@"email"];
        [dicInfo setObject:identityno forKey:@"identityid"];
        [dicInfo setObject:tel forKey:@"mobile"];
        
        [dicInfo setObject:gender forKey:@"gender"];
        [dicInfo setObject:birthday forKey:@"birthday"];
        
        NSString *userinfo = [dicInfo mj_JSONString];
        
        [self presentLoadingTips:nil];
        [[BaseNetConfig shareInstance] configGlobalAPI:WETOWN];
        UpdatePersonInfoAPI *updatePersonInfoApi = [[UpdatePersonInfoAPI alloc]initWithUserinfo:userinfo];
        [updatePersonInfoApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
            [self dismissTips];
            NSDictionary *result = (NSDictionary *)request.responseJSONObject;
            if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
                
                [[LocalData shareInstance] updateUserAccount:self.user];
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
        
    }];
    
}

#pragma mark-prepareData

-(void)prepareData{
    self.user = [[LocalData shareInstance] getUserAccount];
    
    [self.userImageView setImageWithURL:[NSURL URLWithString:self.user.iconurl] placeholder:MemberHeadImage];
    
    self.usernameTextField.text = (self.user.realname.length>0)?self.user.realname:self.user.loginname;
    
    
    if ([self.user.gender isEqualToString:@"1"]) {
        self.sexTextField.text = @"男";
        _seletedSex = 1;
        
        
    }else if ([self.user.gender isEqualToString:@"2"]){
        self.sexTextField.text = @"女";
        _seletedSex = 2;
   

    }
    
    self.birthTextField.text = self.user.birthday;
    
    self.mobileTextField.text = self.user.mobile;
    
    self.emailTextField.text = self.user.email;
    
    self.addressTextField.text = self.user.address;
    
    
}

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 14;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row ==0) {
        //上传图片
        [self beginSelectImage];
    }else if (indexPath.row ==1){
        //姓名
        ModifyUsernameController *info = [ModifyUsernameController spawn];
        [info infoWithName:self.usernameTextField.text activityType:nameType Then:^(NSString *infoString) {
             self.usernameTextField.text = infoString;
            self.user.realname = infoString;
        }];
        [self.navigationController pushViewController:info animated:YES];
    }else if (indexPath.row ==2){
        //性别
        [self showSexPicker];
        
    }else if (indexPath.row ==3){
        //生日
        [self showDatePicker];
        
    }else if (indexPath.row ==4){
        //手机

        ModifyMobileController *modifyMobile = [ModifyMobileController spawn];
        
        modifyMobile.mobileBlock = ^(NSString *mobileString){
            self.mobileTextField.text = mobileString;
            self.user.mobile = mobileString;
        };
        
        [self.navigationController pushViewController:modifyMobile animated:YES];
        
        
    }else if (indexPath.row ==5){
        //电子邮箱
        ModifyUsernameController *info = [ModifyUsernameController spawn];
        [info infoWithName:self.emailTextField.text activityType:emailType Then:^(NSString *infoString) {
            self.emailTextField.text = infoString;
            self.user.email = infoString;
        }];
        [self.navigationController pushViewController:info animated:YES];

    }else if (indexPath.row ==6){
        //我的地址
        ModifyUsernameController *info = [ModifyUsernameController spawn];
        [info infoWithName:self.addressTextField.text activityType:addressType Then:^(NSString *infoString) {
            self.addressTextField.text = infoString;
            self.user.address = infoString;
        }];
        [self.navigationController pushViewController:info animated:YES];

    }
}

#pragma mark - 上传图片
- (void)beginSelectImage
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

# pragma mark - UIImagePickerControllerDelegate && UINavigationControllerDelegate
-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    if (image) {
        if (image.size.width>1024||image.size.height>1024) {
            float newWidth = 1024;
            float newHeight = 1024;
            if (image.size.width>image.size.height) {
                float radio = image.size.width/1024;
                newHeight = image.size.height/radio;
            }
            else{
                float radio = image.size.height/1024;
                newWidth = image.size.width/radio;
            }
            NSLog(@"new width:%f,new height:%f",newWidth,newHeight);
            image = [image fixedCameraImageToSize:CGSizeMake(512, 512)];
        }
    }
        _userImageView.image = image;
    //局部cell刷新
    NSIndexPath *te=[NSIndexPath indexPathForRow:0 inSection:0];//刷新第一个section的第1行
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:te,nil] withRowAnimation:UITableViewRowAnimationNone];
    
    [self presentLoadingTips:nil];
    [[BaseNetConfig shareInstance] configGlobalAPI:KAKATOOL];
    UpdateUserIconAPI *uploadUserIconApi = [[UpdateUserIconAPI alloc]initWithImage:image];
    
    [uploadUserIconApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        [self dismissTips];
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
            
            UserModel *user = [[LocalData shareInstance] getUserAccount];
            user.iconurl = result[@"iconurl"];
            
            self.user = user;
            
            [[LocalData shareInstance] updateUserAccount:user];
            
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
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark-生日

-(void)showDatePicker{
    [self.view endEditing:YES];
    if (_datePicker==nil) {
        _datePicker = [[UIDatePickerSheetController alloc] initWithDefaultNibName];
//        _datePicker.dateMode=1;
        _datePicker.delegate = self;
        [_datePicker setDateTimeMode:UIDatePickerModeDate];
    }
    [_datePicker setDate:[NSDate date]  animated:NO];
    [_datePicker showInViewController:self animated:YES];
    [_datePicker setMaxmunDate:[NSDate date]];
    
}

- (void)datePickerSheet:(UIDatePickerSheetController *)datePickerSheet didFinishWithDate:(NSDate *)date
{
    
//    self.user.birthday = [date toStringWithDateFormat:[NSDate dateFormatString]];
//    
    self.birthTextField.text = [date stringWithFormat:@"yyyy-MM-dd"];
    self.user.birthday = self.birthTextField.text;
    [self.tableView reloadData];
}
- (void)datePickerSheetDidCancel:(UIDatePickerSheetController *)datePickerSheet
{
    
}


#pragma mark-性别
-(void)showSexPicker{
    
    //性别
    CLPickerView *pick = [[CLPickerView alloc]init];
    [pick PickerViewDelegate:self Tag:101 IsShowToobar:NO];
    [pick seletedDefaultRow:(_seletedSex - 1) InComponent:0];
}


#pragma mark 选择性别
-(NSInteger)CLPickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return _sexArray.count;
}
-(NSInteger)CLNumberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSString*)CLPickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return _sexArray[row];
}
-(void)CLPickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    //    self.user.gender = [NSString stringWithFormat:@"%d",row-1];
    
    switch (row) {
        case 0:
        {
            _seletedSex = 1;
            self.user.gender = @"1";
            self.sexTextField.text = @"男";
            
        }
            break;
        case 1:
        {
            _seletedSex = 2;
             self.user.gender = @"2";
             self.sexTextField.text = @"女";
           
        }
            break;
            
        default:
            break;
    }
}

@end

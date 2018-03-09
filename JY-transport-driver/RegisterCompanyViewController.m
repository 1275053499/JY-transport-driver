//
//  RegisterCompanyViewController.m
//  JY-transport-driver
//
//  Created by 永和丽科技 on 17/8/14.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "RegisterCompanyViewController.h"
#import "RegisterCompanyCell.h"
//#import "ServiceLineViewController.h"
#import "CompanyProfileViewController.h"
#import <QiniuSDK.h>
#import "LoginViewController.h"
#import "MineRequestData.h"
@interface RegisterCompanyViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,MineRequestDataDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)FMButton *imgButton;
@property (nonatomic,strong)UIImage *chooseImg;
@property (nonatomic,strong)NSString *phone;
@property (nonatomic,strong)NSString *company;
@property (nonatomic,strong)NSString *businssKey;

@end

@implementation RegisterCompanyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTableView];
    self.navigationItem.title = @"资料";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.barTintColor = BGBlue;
    self.navigationController.navigationBar.translucent = NO;
        self.navigationItem.leftBarButtonItem =  [UIBarButtonItem itemWithIcon:@"return" highIcon:@"return" target:self action:@selector(returnAction)];

}
-(void)createTableView
{
    _phone = @"";
    _company = @"";
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,29, ScreenWidth, 132) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:self.tableView];
    
    
    UIView *photoView = [[UIView alloc] initWithFrame:CGRectMake(0, 166, ScreenWidth, 250)];
    photoView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:photoView];
    
//    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth - 200)/2, 205, 200, 40)];
//    lab.textAlignment = NSTextAlignmentCenter;
//    lab.text = @"上传营业执照照片";
//    lab.font = [UIFont fontWithName:Default_APP_Font_Reg size:20];
//    [photoView addSubview:lab];
    

    _imgButton = [FMButton createFMButton];
    _imgButton.frame = CGRectMake((ScreenWidth - 150 * HOR_SCALE)/2, 30, 150 * HOR_SCALE, 150 * HOR_SCALE);
    _imgButton.backgroundColor = [UIColor whiteColor];
    [_imgButton addTarget:self action:@selector(ChangeInfoImag:) forControlEvents:(UIControlEventTouchUpInside)];
    [_imgButton setBackgroundImage:[UIImage imageNamed:@"join_img_add6"] forState:UIControlStateNormal];
    [photoView addSubview:_imgButton];
    
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.frame = CGRectMake(0, ScreenHeight - 50 - 64, ScreenWidth, 50);
    [nextBtn setBackgroundColor:BGBlue];
    [nextBtn setTitle:@"完成" forState:UIControlStateNormal];
    nextBtn.titleLabel.font = [UIFont fontWithName:Default_APP_Font_Reg size:22];
    [nextBtn addTarget:self action:@selector(nextClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:nextBtn];
    
}
-(void)returnAction
{
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)nextClick:(UIButton *)btn{
    
    MineRequestData *manager = [[MineRequestData alloc] init];
    manager.delegate = self;
    
    if (_phone.length <= 0 ) {
        [MBProgressHUD showInfoMessage:@"手机号码不能为空"];
    }else if (_company.length <= 0){
        [MBProgressHUD showInfoMessage:@"公司名称不能为空"];

    }else if (_businssKey.length <= 0){
        [MBProgressHUD showInfoMessage:@"营业执照不能为空"];

    }
    
    if (_phone.length >0 && _company.length>0 && _businssKey> 0) {
        //把七牛云的图片名称 上传到服务器
        [manager requestDataJoinLog:nil phone:_phone company:_company businessLicense:_businssKey];
        
        LoginViewController *logIn = [[LoginViewController alloc] init];
        
        [self dismissViewControllerAnimated:logIn completion:nil];

    }
    
}


- (void)requestDataJoinInLogisticsForDriverSuccess:(NSDictionary *)resultDic{
    
    NSString *message = [resultDic objectForKey:@"message"];
    if ([message isEqualToString:@"0"]) {
        [MBProgressHUD showSuccessMessage:@"提交成功，等待审核"];

    } if ([message isEqualToString:@"410"]) {
        [MBProgressHUD showInfoMessage:@"此号码已加盟"];
        
    }
    
    
}
- (void)requestDataJoinInLogisticsForDriverFailed:(NSError *)error{
    
    
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    RegisterCompanyCell  *cell = [RegisterCompanyCell cellWithTableView:tableView];
    
    cell.textLabel.font = [UIFont fontWithName:Default_APP_Font size:12];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#333333"];
   

    cell.textfield.delegate = self;
    if (indexPath.row ==0) {
        CGRect frame;
        frame =  cell.imgView.frame;
        frame.size = CGSizeMake(24, 24);
        cell.imgView.frame = frame;
        cell.textfield.tag = 88;
        cell.imgView.image =[UIImage imageNamed:@"icon_gongsi"];
        cell.textfield.font = [UIFont fontWithName:Default_APP_Font_Reg size:16];
        cell.textfield.placeholder=@"请输入公司名称";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
       
        return cell;
    }else if (indexPath.row == 1){
        CGRect frame;
        frame =  cell.imgView.frame;
        frame = CGRectMake(frame.origin.x + 3, frame.origin.y, 18, 27);
        cell.imgView.frame = frame;
        cell.textfield.tag = 89;

        cell.imgView.image =[UIImage imageNamed:@"icon_shouji_zijihua"];
        cell.textfield.keyboardType = UIKeyboardTypeNumberPad;
        cell.textfield.returnKeyType = UIReturnKeyDone;
        cell.textfield.placeholder=@"请输入手机号码";
        cell.textfield.font = [UIFont fontWithName:Default_APP_Font_Reg size:16];

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    
    return cell;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self.view endEditing:YES];
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag == 88) {
        _company = textField.text;

    }else if (textField.tag == 89){
        _phone = textField.text;

    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 2) {
        CompanyProfileViewController *companyVC = [[CompanyProfileViewController alloc] init];
        [self.navigationController pushViewController:companyVC animated:YES];
    }
    
    
}


//调用相机或相册
- (void)ChangeInfoImag:(UIButton *)btn{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *cameraPicker = [[UIImagePickerController alloc] init];
        cameraPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        cameraPicker.delegate = self;
        cameraPicker.allowsEditing = YES;
        cameraPicker.automaticallyAdjustsScrollViewInsets = NO;
        [self presentViewController:cameraPicker animated:YES completion:nil];
        
    }];
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        UIImagePickerController *photoPicker = [[UIImagePickerController alloc] init];
        photoPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        photoPicker.delegate = self;
        photoPicker.allowsEditing = NO;
        photoPicker.automaticallyAdjustsScrollViewInsets = NO;
        [self presentViewController:photoPicker animated:YES completion:nil];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [alert addAction:cameraAction];
    }
    [alert addAction:photoAction];
    [alert addAction:cancelAction];
    
    alert.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    
    [self presentViewController:alert animated:YES completion:nil];
}
// 选择图片成功调用此方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    _chooseImg = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [self chooseDriverReviewImage];
    NSLog(@"%@", info);
    [self getUpVoucher];
}

- (void)chooseDriverReviewImage{
    

    [[_imgButton imageView] setContentMode: UIViewContentModeScaleAspectFill];
    _imgButton.clipsToBounds = YES;
    [_imgButton setImage:_chooseImg forState:UIControlStateNormal];
            
          
}

//从服务器获取 上传七牛的token
- (void)getUpVoucher{
    NSString *baseStr = base_url;
    NSString *urlStr = [baseStr stringByAppendingString:@"app/user/getUpVoucher"];
    
    [[NetWorkHelper shareInstance]Get:urlStr parameter:nil success:^(id responseObj) {
        
        NSString *voucher = [responseObj objectForKey:@"voucher"];
        [self updateheadimage:voucher];
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD showErrorMessage:@"网络异常"];
        NSLog(@"error%@",error);
    }];
    
    
}
//上传图片到七牛
- (void)updateheadimage:(NSString *)str{
    
    QNConfiguration *config = [QNConfiguration build:^(QNConfigurationBuilder *builder) {
        builder.zone = [QNZone zone0];
    }];
    NSString * token = str;
    NSString * keyStr = [NSDate getnowDate:@"YYYYMMddhhmmss"];
    NSString *key = [NSString stringWithFormat:@"BLicense%@%@.png",_phone,keyStr];
  
    QNUploadManager *upManager = [[QNUploadManager alloc] initWithConfiguration:config];
    NSData *data = [NSData imageData:_chooseImg];
    [MBProgressHUD showInfoMessage:@"正在上传"];
    [upManager putData:data key:key token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        
        _businssKey  = key;
        [MBProgressHUD hideHUD];
        [MBProgressHUD showSuccessMessage:@"上传成功"];
       
        
    } option:nil];
    
}

// 取消图片选择调用此方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
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

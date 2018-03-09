//
//  RegisterPersonViewController.m
//  JY-transport-driver
//
//  Created by 闫振 on 2017/9/1.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "RegisterPersonViewController.h"
#import "RegisterCompanyCell.h"
#import  <QiniuSDK.h>
#import "MineRequestData.h"
#import "LoginViewController.h"
@interface RegisterPersonViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MineRequestDataDelegate>

@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)NSString *name;
@property (nonatomic,strong)NSString *phone;
@property (nonatomic,strong)NSString *carID;

@property (nonatomic,strong)UIImage *chooseImg;//选择的图片
@property (nonatomic,assign)NSInteger tagNum;//标记点击哪个按钮

@end

@implementation RegisterPersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTableView];
    _name = @"";
    _phone = @"";
    _carID = @"";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = BGBlue;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.leftBarButtonItem =  [UIBarButtonItem itemWithIcon:@"return" highIcon:@"return" target:self action:@selector(returnAction)];
    
    [self addImageView];
}
- (void)returnAction{
    
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];}

-(void)createTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, ScreenWidth,167) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(167);
    }];
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.frame = CGRectMake(0, ScreenHeight - 50 - 64, ScreenWidth, 50);
    [nextBtn setBackgroundColor:BGBlue];
    [nextBtn setTitle:@"完成" forState:UIControlStateNormal];
    nextBtn.titleLabel.font = [UIFont fontWithName:Default_APP_Font_Reg size:22];
    [nextBtn addTarget:self action:@selector(joinFinishedClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:nextBtn];

    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];

    
}
- (void)addImageView{
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 190, 250, 25)];
    lab.textAlignment = NSTextAlignmentLeft;
    lab.font = [UIFont fontWithName:Default_APP_Font_Reg size:20];
    [self.view addSubview:lab];
    
    NSMutableAttributedString * firstPart = [[NSMutableAttributedString alloc] initWithString:@"添加照片"];
    NSDictionary * firstAttributes = @{ NSFontAttributeName:[UIFont fontWithName:Default_APP_Font_Reg size:15],NSForegroundColorAttributeName:RGB(51, 51, 51)};
    
    [firstPart setAttributes:firstAttributes range:NSMakeRange(0,firstPart.length)];
    
    NSMutableAttributedString * secondPart = [[NSMutableAttributedString alloc] initWithString:@"(请务必保证图片信息的清晰可见)"];
    NSDictionary * secondAttributes = @{NSFontAttributeName:[UIFont fontWithName:Default_APP_Font_Reg size:12],NSForegroundColorAttributeName:RGB(153, 153, 153),};
    
    [secondPart setAttributes:secondAttributes range:NSMakeRange(0,secondPart.length)];
    [firstPart appendAttributedString:secondPart];
   
    lab.attributedText = firstPart;
    
    
    int imgWeight = (ScreenWidth - 15 *4)/3;
    for (int i = 0; i < 3; i++) {
        
        FMButton *imgButtonID = [FMButton createFMButton];
        imgButtonID.tag = 235 + i;
        imgButtonID.backgroundColor = [UIColor whiteColor];
        imgButtonID.frame = CGRectMake(15*(i +1) + imgWeight *i, 230, imgWeight, imgWeight);
        [imgButtonID addTarget:self action:@selector(ChangeInfoImag:) forControlEvents:(UIControlEventTouchUpInside)];
        NSString *imgName = [NSString stringWithFormat:@"join_img_add%d",i + 1];
        [imgButtonID setBackgroundImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
        [self.view addSubview:imgButtonID];
    }

    
}
- (void)joinFinishedClick:(UIButton *)btn{
    
    LoginViewController *logIn = [[LoginViewController alloc] init];
    
    [self dismissViewControllerAnimated:logIn completion:nil];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPat
{
    
    return 54;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RegisterCompanyCell  *cell = [RegisterCompanyCell cellWithTableView:tableView];
    cell.textLabel.text = @"";
    cell.textfield.delegate = self;
    
    if (indexPath.row ==0) {
        CGRect frame;
        frame =  cell.imgView.frame;
        frame.size = CGSizeMake(23, 26);
        cell.imgView.frame = frame;
        cell.textfield.tag = 81;
        cell.imgView.image =[UIImage imageNamed:@"icon_xingmingjiameng"];
        cell.textfield.font = [UIFont fontWithName:Default_APP_Font_Reg size:16];
        cell.textfield.placeholder=@"请输入姓名";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else if (indexPath.row == 1){
        CGRect frame;
        frame =  cell.imgView.frame;
        frame = CGRectMake(frame.origin.x, frame.origin.y, 20, 27);
        cell.imgView.frame = frame;
        cell.textfield.tag = 82;
        
        cell.imgView.image =[UIImage imageNamed:@"icon_shouji_zijihuajiameng"];
        cell.textfield.keyboardType = UIKeyboardTypeNumberPad;
        cell.textfield.returnKeyType = UIReturnKeyDone;
        cell.textfield.placeholder=@"请输入手机号码";
        cell.textfield.font = [UIFont fontWithName:Default_APP_Font_Reg size:16];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        CGRect frame;
        frame =  cell.imgView.frame;
        frame = CGRectMake(frame.origin.x - 3, frame.origin.y, 31, 20);
        cell.imgView.frame = frame;
        cell.textfield.tag = 83;
        
        cell.imgView.image =[UIImage imageNamed:@"icon_shenfenzheng"];
        cell.textfield.keyboardType = UIKeyboardTypeDefault;
        cell.textfield.returnKeyType = UIReturnKeyDone;
        cell.textfield.placeholder=@"请输入身份证号码";
        cell.textfield.font = [UIFont fontWithName:Default_APP_Font_Reg size:16];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
 
    }
    
}
//调用相机或相册
- (void)ChangeInfoImag:(UIButton *)btn{
    
    _tagNum = btn.tag;
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
    
    FMButton *btn = [self.view viewWithTag:235];
    FMButton *btn2 = [self.view viewWithTag:236];
    FMButton *btn3 = [self.view viewWithTag:237];

    if (_tagNum == 235) {
        [[btn imageView] setContentMode: UIViewContentModeScaleAspectFill];
        btn.clipsToBounds = YES;
        [btn setImage:_chooseImg forState:UIControlStateNormal];
    }else if (_tagNum == 236) {
        [[btn2 imageView] setContentMode: UIViewContentModeScaleAspectFill];
        btn2.clipsToBounds = YES;
        [btn2 setImage:_chooseImg forState:UIControlStateNormal];
    }else{
        [[btn2 imageView] setContentMode: UIViewContentModeScaleAspectFill];
        btn2.clipsToBounds = YES;
        [btn3 setImage:_chooseImg forState:UIControlStateNormal];

    }
    
    
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
    NSString *key = [NSString stringWithFormat:@"JoinPerson%@%@.png",_phone,keyStr];
    
    QNUploadManager *upManager = [[QNUploadManager alloc] initWithConfiguration:config];
    NSData *data = [NSData imageData:_chooseImg];
    [MBProgressHUD showInfoMessage:@"正在上传"];
    [upManager putData:data key:key token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        
        [MBProgressHUD hideHUD];
        [MBProgressHUD showSuccessMessage:@"上传成功"];
        
    } option:nil];
    
}
- (void)nextClick:(UIButton *)btn{
    
    MineRequestData *manager = [[MineRequestData alloc] init];
    manager.delegate = self;
    
    if (_phone.length <= 0 ) {
        [MBProgressHUD showInfoMessage:@"手机号码不能为空"];
    }else if (_name.length <= 0){
        [MBProgressHUD showInfoMessage:@"姓名不能为空"];
        
    }else if (_carID.length <= 0){
        [MBProgressHUD showInfoMessage:@"身份证号码不能为空"];
        
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

// 取消图片选择调用此方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self.view endEditing:YES];
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag == 81) {
        _name = textField.text;
        
    }else if (textField.tag == 82){
        _phone = textField.text;
        
    }else if (textField.tag == 83){
        _carID = textField.text;
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

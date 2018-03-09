//
//  DriverApplyViewController.m
//  JY-transport-driver
//
//  Created by 永和丽科技 on 17/5/23.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "DriverApplyViewController.h"
#import "driverApplyCell.h"
#import "AdBannerView.h"
#import "DriverApplyTableViewCell.h"
#import "DriverApplyImgTableViewCell.h"
#import <QiniuSDK.h>
#import "MineRequestData.h"
#import "DriverApplyDemo.h"
@interface DriverApplyViewController ()<UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MineRequestDataDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic,strong)NSString *nameField;
@property (nonatomic,strong)NSString *phoneField;
@property (nonatomic,strong)NSString *carIDField;
@property (nonatomic,strong)FMButton * OKButton;

@property (nonatomic,strong)AdBannerView *bannerView;
@property (nonatomic,strong)UIImage *driverReviewImage;
@property (nonatomic,strong)NSString *IDcardFrontName;
@property (nonatomic,strong)NSString *IDcardReverseSideName;
@property (nonatomic,strong)NSString *carIDFrontName;
@property (nonatomic,assign)NSInteger tagNum;
@property (nonatomic,strong)UIView *supView;// 承载放大的图片view
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSString *carTypeName;
@property (nonatomic,strong)NSArray *carName;
@property (nonatomic,strong)DriverApplyDemo *driverDemo;

@property (nonatomic,strong)UIImage *IDCardImg;
@property (nonatomic,strong)UIImage *drivingLicenseImg;
@property (nonatomic,strong)UIImage *driverIDCardImg;
@property (nonatomic,strong)NSArray *carTypeArr;
@end

@implementation DriverApplyViewController

static NSString *cellID = @"DriverApplyTableViewCell";
static NSString *cellImgID = @"DriverApplyImgTableViewCell";


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BgColorOfUIView;
    self.navigationItem.leftBarButtonItem =  [UIBarButtonItem itemWithIcon:@"return" highIcon:@"return" target:self action:@selector(returnAction)];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = BGBlue;
    self.navigationItem.title = @"我要加盟";
    _carName =  @[@"微面",@"大型面包车",@"依维柯",@"微型货车",@"小型货车",@"中型货车",@"平板车"];
//    _carName = @[@"Car_Iveco",@"Car_BigVan",@"Car_MiniTruck",@"Car_SmallTruck",@"Car_modelcar"];
    _carTypeArr = @[@"MINIVAN",@"LARGEVAN",@"IVECO",@"MINITRUCK",@"SMALLTRUCK",@"MEDIUMTRUCK",@"FLATBED"];

    [self createTableView];
    
    _IDcardFrontName = @"";
    _IDcardReverseSideName = @"";
    _carIDFrontName = @"";
    _IDCardImg = [UIImage imageNamed:@"img_add"];
    _drivingLicenseImg = [UIImage imageNamed:@"img_add"];
    _driverIDCardImg = [UIImage imageNamed:@"img_add"];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveNotificiation:) name:@"carTypeChange" object:nil];
    
    
}

-(void)createTableView{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, ScreenWidth,ScreenHeight - NavigationBarHeight - StateBarHeight - 50) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[DriverApplyTableViewCell class] forCellReuseIdentifier:cellID];
    [self.tableView registerClass:[DriverApplyImgTableViewCell class] forCellReuseIdentifier:cellImgID];
    
    [self.view addSubview:self.tableView];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.frame = CGRectMake(0, ScreenHeight - NavigationBarHeight - StateBarHeight - 50, ScreenWidth, 50);
    [nextBtn setBackgroundColor:BGBlue];
    [nextBtn setTitle:@"提交审核" forState:UIControlStateNormal];
    nextBtn.titleLabel.font = [UIFont fontWithName:Default_APP_Font_Reg size:22];
    [nextBtn addTarget:self action:@selector(ClickOKButton:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:nextBtn];
    
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tableView.mas_bottom);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    
    
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    }else if (section == 1){
        return 1;
    }else{
        return 3;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 ) {
        return 50;
    }else if (indexPath.section ==1){
        
        return 140;
    }else{
        return 180 * HOR_SCALE;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.001;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *v = [[UIView alloc] init];
    return v;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 30;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, ScreenWidth, 30)];
    [view addSubview:lab];
    
    lab.backgroundColor = BgColorOfUIView;
    lab.font = [UIFont fontWithName:Default_APP_Font_Reg size:12];
    lab.textColor = RGB(153, 153, 153);
    
    if (section == 0) {
        lab.text = @"基本信息";
    }else if (section == 1){
        lab.text = @"选择车型";
    }else{
        lab.text =  @"图片信息（请务必保证图片信息的清晰可见）";
    }
    
    return view;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DriverApplyTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    DriverApplyImgTableViewCell  *imgCell = [tableView dequeueReusableCellWithIdentifier:cellImgID];
    imgCell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contenttextField.returnKeyType = UIReturnKeyDone;
    
    cell.contenttextField.delegate = self;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.nameLabel.text = @"姓  名：";
            cell.contenttextField.placeholder=@"请输入您的姓名";
            cell.contenttextField.tag = 81;
            cell.contenttextField.text = _nameField;
        }else if (indexPath.row == 1){
            
            cell.nameLabel.text = @"手机号：";
            cell.contenttextField.placeholder=@"请输入您的手机号";
            cell.contenttextField.tag = 82;
            cell.contenttextField.text = _phoneField;
        }else{
            
            cell.nameLabel.text = @"车牌号：";
            cell.contenttextField.placeholder=@"请输入您的车牌号";
            cell.contenttextField.tag = 83;
            cell.contenttextField.text = _carIDField;
        }
        
        return cell;
    }else if (indexPath.section == 1){
        
        [cell.contentView addSubview:[self creatCarTypeView]];
        
        return cell;
        
    }else{
        
        imgCell.imgBtn.tag = indexPath.row + 335;
        [imgCell.imgBtn addTarget:self action:@selector(imgChooseClick:) forControlEvents:(UIControlEventTouchUpInside)];
        
        
        if (indexPath.row == 0) {
            imgCell.nameLabel.text = @"身份证照片";
            [imgCell.imgBtn setImage:_IDCardImg forState:(UIControlStateNormal)];
            
        }else if (indexPath.row == 1){
            imgCell.nameLabel.text = @"驾驶证照片";

            [imgCell.imgBtn setImage:_driverIDCardImg forState:(UIControlStateNormal)];
        }else{
            imgCell.nameLabel.text = @"行驶证照片";
            [imgCell.imgBtn setImage:_drivingLicenseImg forState:(UIControlStateNormal)];
            
        }
        return imgCell;
        
    }
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
        _nameField = textField.text;
        
    }else if (textField.tag == 82){
        _phoneField = textField.text;
        
    }else if (textField.tag == 83){
        _carIDField = textField.text;
        
    }
}
-(void)receiveNotificiation:(NSNotification*)sender
{
    
    int progress = [[sender.userInfo objectForKey:@"pageControlPage"] intValue];
    _carTypeName = _carTypeArr[progress];
    NSLog(@"view===%d=======%@",progress,_carTypeName);
    
}
- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)imgChooseClick:(UIButton *)btn{
    DriverApplyDemo *driverDemo = [[DriverApplyDemo alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth,ScreenHeight )];
    _driverDemo = driverDemo;
    
    [_driverDemo.finishBtn addTarget:self action:@selector(finishBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    switch (btn.tag) {
        case 335:
            _driverDemo.finishBtn.tag = 401;
            [_driverDemo showImgView:@"img_card"];
            
            break;
        case 336:
            _driverDemo.finishBtn.tag = 402;
            [_driverDemo showImgView:@"img_jiashi"];
            
            break;
        case 337:
            _driverDemo.finishBtn.tag = 403;
            
            [_driverDemo showImgView:@"img_xingshi"];
            [_driverDemo updatHeight:460 * HOR_SCALE imgHeight:355 * HOR_SCALE];
            
            break;
            
        default:
            break;
    }
    
    
}

-(UIView *)creatCarTypeView
{
    if (_bannerView == nil) {
        int height = 70 *HOR_SCALE  + 50; //scrollview高加label高
        _bannerView = [[AdBannerView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, height)];
        _bannerView.carName = _carName;
        [_bannerView initWithImage:@[@"micro_facet",@"big_minibus",@"iveco",@"mini_truck",@"light_van",@"medium_truck",@"pingbanche"]];
        [self.view addSubview:_bannerView];
    }
    
    return _bannerView;
}

-(void)returnAction
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)finishBtnClick:(UIButton*)button{
    [_driverDemo disMissView];
    _tagNum = button.tag;
    [self ChangeInfoImag];
    
    
}
- (void)bigOriginalImage:(UIImage *)btnImage{
    self.navigationController.navigationBarHidden = YES;
    
    _supView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _supView.backgroundColor = [UIColor whiteColor];
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 65)];
    headView.backgroundColor = BgColorOfUIView;
    [_supView addSubview:headView];
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, 1)];
    v.backgroundColor = RGBA(153, 153, 153, 1);
    [headView addSubview:v];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth - 100)/2, 20, 100, 50)];
    lab.textColor = [UIColor blackColor];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.text = @"修改图片";
    [headView addSubview:lab];
    
    
    UIButton *back  = [UIButton buttonWithType:(UIButtonTypeCustom)];
    back.frame = CGRectMake(12, 20, 50, 50);
    [back setTitle:@"返回" forState:(UIControlStateNormal)];
    [back setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(removesupView:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:back];
    
    UIButton *choose  = [UIButton buttonWithType:(UIButtonTypeCustom)];
    choose.frame = CGRectMake(ScreenWidth - 74, 20, 50, 50);
    [choose setTitle:@"选择" forState:(UIControlStateNormal)];
    [choose setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [choose addTarget:self action:@selector(ChangeInfoImag) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:choose];
    
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-64)];
    
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    imgView.clipsToBounds = YES;
    imgView.image = btnImage;
    imgView.userInteractionEnabled = YES;
    [_supView addSubview:imgView];
    [self.view addSubview:_supView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doTapChange:)];
    tap.numberOfTapsRequired = 1;
    [imgView addGestureRecognizer:tap];
    
    
}

- (void)doTapChange:(UIGestureRecognizer *)gesture{
    
    self.navigationController.navigationBarHidden = NO;
    [_supView removeFromSuperview];
    _supView = nil;
}
- (void)removesupView:(UIButton*)button{
    self.navigationController.navigationBarHidden = NO;
    [_supView removeFromSuperview];
    _supView = nil;
}
//调用相机或相册
- (void)ChangeInfoImag{
    
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
    _driverReviewImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self chooseDriverReviewImage];
    // 选择的图片信息存储于info字典中
    NSLog(@"%@", info);
    [self getUpVoucher];
}

- (void)chooseDriverReviewImage{
    
    switch (_tagNum) {
        case 401:
            _IDCardImg = _driverReviewImage;
            break;
        case 402:
            _driverIDCardImg = _driverReviewImage;
            
            break;
        case 403:
            
            _drivingLicenseImg = _driverReviewImage;
            
            break;
        default:
            break;
    }
    
    [self.tableView reloadData];
    
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
    NSString *key = [NSString stringWithFormat:@"DrReview%@%@.png",_phoneField,keyStr];
    if (_tagNum == 401) {
        _IDcardFrontName = key;
    }else if (_tagNum == 402){
        _IDcardReverseSideName = key;
    }else if (_tagNum == 403){
        _carIDFrontName = key;
    }
    QNUploadManager *upManager = [[QNUploadManager alloc] initWithConfiguration:config];
    NSData *data = [NSData imageData:_driverReviewImage];
    [MBProgressHUD showInfoMessage:@"正在上传"];
    [upManager putData:data key:key token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showSuccessMessage:@"上传成功"];
        
        
        if (_supView != nil) {
            [_supView removeFromSuperview];
            _supView = nil;
        }
        
    } option:nil];
    
}
//把七牛云的图片名称 上传到服务器
- (void)requestDataInMineSuccess:(NSDictionary *)resultDic{
    NSString *mess = [resultDic objectForKey:@"message"];
    if ([mess isEqualToString:@"0"] || mess == 0) {
        NSLog(@"上传图片名字成功");
    }
}

- (void)requestDataInMineFailed:(NSError *)error{
    
    
}
// 取消图片选择调用此方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)ClickOKButton:(UIButton *)btn
{
    
    
    
    if ([self.phoneField isEqualToString:@""] || [self.nameField isEqualToString:@""] || [self.carIDField isEqualToString:@""]|| [self.IDcardFrontName isEqualToString:@""]|| [self.IDcardReverseSideName isEqualToString:@""]|| [self.carIDFrontName isEqualToString:@""]) {
        
        
        [MBProgressHUD showSuccessMessage:@"请填全司机信息"];
        return;
        
        
        
    }else{
        
        
        
        // NSDictionary *dic =@{@"phone":self.phoneField.text,@"name":self.nameField.text,@"vehicle":arr[[self.bannerView numberpag]],@"licensePlate":self.carIDField.text};
        //NSString *str = [self dictionaryToJson:dic];
        int sex = 2;
        
        NSString *baseStr = base_url;
        NSString *urlStr = [baseStr stringByAppendingString:@"app/chartered/postTrucker"];
        
        [[NetWorkHelper shareInstance]Post:urlStr parameter:@{@"phone":self.phoneField,@"name":self.nameField,@"vehicle":_carTypeName,@"idCardfront":_IDcardFrontName,@"idCardverso":_IDcardReverseSideName,@"drivingLicense":_carIDFrontName,@"vehicleLicense":@"",@"sexuality":@(sex),@"licensePlate":self.carIDField} success:^(id responseObj) {
            
            if ([[NSString stringWithFormat:@"%d",[responseObj intValue]] isEqualToString:@"0"]) {
                
                [MBProgressHUD showSuccessMessage:@"提交成功"];
                self.nameField = @"";
                self.carIDField = @"";
                self.phoneField = @"";
                [self dismissViewControllerAnimated:YES completion:nil];
                
            }else if([[NSString stringWithFormat:@"%d",[responseObj intValue]] isEqualToString:@"1"]) {
                [MBProgressHUD showErrorMessage:@"提交失败"];
                
                
            }else if([[NSString stringWithFormat:@"%d",[responseObj intValue]] isEqualToString:@"101"]) {
                [MBProgressHUD showInfoMessage:@"资料提交正在审核"];
                
            }else if([[NSString stringWithFormat:@"%d",[responseObj intValue]] isEqualToString:@"100"]) {
                [MBProgressHUD showInfoMessage:@"审核已经通过，无需再次提交"];
                
            }else{
                
                [MBProgressHUD showErrorMessage:@"结束服务失败"];
                
            }
            
        } failure:^(NSError *error) {
            
            NSLog(@"-----------%@",error);
            
            [MBProgressHUD showErrorMessage:@"网络异常"];
            
        }];
        
        
    }
    
    
}

//字典转json格式字符串：
- (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end

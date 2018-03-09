//
//  EditPersonalInfoVC.m
//  JY-transport-driver
//
//  Created by 永和丽科技 on 17/8/1.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "EditPersonalInfoVC.h"
#import "JYEditCompanyCellSecondCell.h"
#import "EditPersonalSexView.h"
#import "UIImage+YHLImage.h"
#import "driverInfoModel.h"
#import "EditorPersonNameVC.h"
#import "BindAccountViewController.h"
#import "JYEditCompanyInfoTableViewCell.h"
#import "BankCardViewController.h"
#import <QiniuSDK.h>
#import <Photos/Photos.h>
#import <UIImageView+WebCache.h>
#import "MineRequestData.h"
#import "TZImagePickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface EditPersonalInfoVC ()<UITableViewDelegate,UITableViewDataSource,QYChangeLabelValue,UIImagePickerControllerDelegate,UINavigationControllerDelegate,EditorPersonNameVCDelegate,MineRequestDataDelegate,TZImagePickerControllerDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSArray *arr;
@property (nonatomic,strong)NSString *sexStr;
@property (nonatomic,strong)driverInfoModel *drivModel;
@property (nonatomic,strong)UIImage *heardImg;
@property (nonatomic,strong)UIImagePickerController *imagePickerVc;
@property (nonatomic,strong)NSString *aliAccount;
//@property (nonatomic,strong)NSString *bankAccount;

@end

@implementation EditPersonalInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatTableView];
    self.arr = @[@"保密",@"男",@"女"];
    self.view.backgroundColor = BgColorOfUIView;
    
    self.navigationItem.leftBarButtonItem =  [UIBarButtonItem itemWithIcon:@"return" highIcon:@"return" target:self action:@selector(returnBackAction)];
    _sexStr = @"保密";
    self.title = @"个人信息";
}
- (void)creatTableView{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.backgroundColor = BgColorOfUIView;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
}
- (void)viewWillAppear:(BOOL)animated{
    
    _drivModel = [JYAccountTool getDriverInfoModelInfo];
    [_tableView reloadData];
    
}
- (void)returnBackAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return 86;
    }else{
        return 49;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section ==1) {
        return 9;
    }else if (section == 2){
        return 35;
    }else{
        
        return 0.001;
    }
    
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 9)];
    view.backgroundColor = BgColorOfUIView;
    if (section == 2) {
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 100, 22)];
        lab.backgroundColor = [UIColor clearColor];
        lab.textColor = RGB(153, 153, 153);
        lab.font = [UIFont fontWithName:Default_APP_Font_Reg size:12];
        lab.text = @"账户绑定";
        [view addSubview:lab];
        return view;
        
    }else{
        return view;
        
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0 ) {
        return 1;
    }else if (section == 1){
        return 5;
    } else{
        return 2;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        JYEditCompanyInfoTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([JYEditCompanyInfoTableViewCell class]) owner:nil options:0][0];
        UIImageView *accessimg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_jiantou2"]];
        cell.accessoryView = accessimg;
        cell.imgView.layer.cornerRadius = 33;
        cell.imgView.layer.masksToBounds = YES;
        NSString *url  = @"http://ory7digfv.bkt.clouddn.com/";
        NSString *urlstr = [NSString stringWithFormat:@"%@%@",url,_drivModel.icon];
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:urlstr] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
        
        return cell;
    }else if (indexPath.section == 1) {
        
        JYEditCompanyCellSecondCell *cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([JYEditCompanyCellSecondCell class]) owner:nil options:0][0];
        cell.imgView.hidden = YES;
        cell.titleLabel.hidden = YES;
        cell.lineView.hidden = NO;
        cell.accessImgView.image =  [UIImage imageNamed:@"icon_jiantou2"];
        cell.accessImgView.hidden = YES;
        if (indexPath.row == 0) {
            cell.accessImgView.hidden = NO;
            
            if (_drivModel.name == nil || [_drivModel.name isEqual:[NSNull null]]) {
                _drivModel.name = userPhone;
            }
            cell.name.text = _drivModel.name;
            cell.type.text = @"名字";
            
        }else if (indexPath.row == 1){
            cell.lineView.hidden = NO;
            
            cell.accessImgView.hidden = NO;
            
            
            if (_drivModel.sexuality == nil || [_drivModel.sexuality isEqual:[NSNull null]]) {
                cell.name.text = @"保密";
            }else{
                if ([_drivModel.sexuality intValue]== 0) {
                    cell.name.text = @"女";
                }else if ([_drivModel.sexuality intValue] == 1 ){
                    cell.name.text = @"男";
                }else{
                    cell.name.text = @"保密";
                }
                
            }
            cell.type.text = @"性别";
        }else if (indexPath.row == 2){
            cell.lineView.hidden = NO;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.name.text = _drivModel.licensePlate;
            cell.type.text = @"车牌";
        }else if (indexPath.row == 3){
            cell.lineView.hidden = NO;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [self judgeVehicle:cell];
            cell.type.text = @"车型";
        }else if (indexPath.row == 4){
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.name.text = _drivModel.phone;
            cell.type.text = @"手机号码";
        }
        
        return cell;
        
    }else{
        JYEditCompanyCellSecondCell *cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([JYEditCompanyCellSecondCell class]) owner:nil options:0][0];
        cell.lineView.hidden = YES;
        
        cell.accessImgView.hidden = NO;
        cell.imgView.hidden = NO;
        cell.titleLabel.hidden = NO;
        cell.titleLabel.textColor = RGB(51, 51, 51);
        
        cell.accessImgView.image = [UIImage imageNamed:@"icon_jiantou2"];
        if (indexPath.row == 0) {
            cell.lineView.hidden = NO;
            cell.imgView.image = [UIImage imageNamed:@"icon_ipay"];
            
            
            if ([self isAilpayAccount]){
                
                cell.name.text = @"已绑定";
                cell.titleLabel.text = _drivModel.ailpayAccount;
                
            }else{
                cell.name.text = @"未绑定";
                cell.titleLabel.text = @"支付宝";
                
                
            }
            
        }else{
            
            cell.imgView.image = [UIImage imageNamed:@"icon_bankcard"];
            
            
            if ([self isBankAccount]) {
                
                NSString * subStr = [_drivModel.bankCard substringFromIndex:_drivModel.bankCard.length - 4];
                NSString *account = [NSString stringWithFormat:@"**** **** **** %@",subStr];
                cell.name.text = @"已绑定";
                cell.titleLabel.text = account;
                
            }else{
                cell.titleLabel.text = @"银行卡";
                
                cell.name.text = @"未绑定";
                
            }
            
        }
        
        return cell;
    }
}

- (void)judgeVehicle:(JYEditCompanyCellSecondCell *)cell{
    if ([_drivModel.vehicle isEqualToString:@"MINIVAN"]) {
        cell.name.text = @"微面";
    }else if ([_drivModel.vehicle isEqualToString:@"LARGEVAN"]){
        cell.name.text = @"大型面包车";
    }else if ([_drivModel.vehicle isEqualToString:@"IVECO"]){
        cell.name.text = @"依维柯";
    }else if ([_drivModel.vehicle isEqualToString:@"MINITRUCK"]){
        cell.name.text = @"微型货车";
    }else if ([_drivModel.vehicle isEqualToString:@"SMALLTRUCK"]){
        cell.name.text = @"小型货车";
    }else if ([_drivModel.vehicle isEqualToString:@"MEDIUMTRUCK"]){
        cell.name.text = @"中型货车";
    }else if ([_drivModel.vehicle isEqualToString:@"FLATBED"]){
        cell.name.text = @"平板车";
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        
        [self ChangeInfoImag];
        
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            EditorPersonNameVC *nameVC = [[EditorPersonNameVC alloc] init];
            nameVC.delegate = self;
            nameVC.name= _drivModel.name;
            [self.navigationController pushViewController:nameVC animated:YES];
        }else if (indexPath.row == 1) {
            EditPersonalSexView *sexView= [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([EditPersonalSexView class]) owner:self options:nil][0];
            sexView.sexHeadLabel.text = @"性别";
            sexView.delegate = self;
            sexView.dataArr = self.arr;
            [sexView showSexView];
        }
        
    }else{
        
        if(indexPath.row == 0){
            
            if ([self isAilpayAccount]) {
                [self presentTipAlert:@"alipay"];
            }else{
                BindAccountViewController *vc = [[BindAccountViewController alloc] init];
                vc.type = BindAccountForAli;
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }else{
            if ([self isBankAccount]) {
                [self presentTipAlert:@"bank"];
            }else{
                
                BankCardViewController *vc = [[BankCardViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
                
            }
            
            
        }
        
    }
}
- (void)presentTipAlert:(NSString *)type{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"解除绑定" message:@"" preferredStyle: UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self cancelBinding:type];
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        
    }];
    
    [alert addAction:cancelAction];
    [alert addAction:action];
    
    [self presentViewController:alert animated:true completion:nil];
    
}

- (void)cancelBinding:(NSString *)type{
    
    NSString *url = [NSString stringWithFormat:base_url];
    NSString *urlstr = [url stringByAppendingString:@"app/truckerGroup/cancelBinding"];
    NSString *phone = userPhone;
    
    [[NetWorkHelper shareInstance]Post:urlstr parameter:@{@"accountType":type,@"phone":phone} success:^(id responseObj) {
        
        NSString *code = [responseObj objectForKey:@"code"];
        
        if ([code isEqualToString:@"200"]) {
            
            if ([type isEqualToString:@"alipay"]) {
                
                _drivModel.ailpayAccount  = @"";
                [JYAccountTool saveDriverInfoModelInfo:_drivModel];
                [MBProgressHUD showSuccessMessage:@"解绑成功"];
                
                
            }else if([type isEqualToString:@"bank"]){
                
                _drivModel.bankCard = @"";
                [JYAccountTool saveDriverInfoModelInfo:_drivModel];
                [MBProgressHUD showSuccessMessage:@"解绑成功"];
            }
        }else{
            [MBProgressHUD showErrorMessage:@"解绑失败"];
            
        }
        
        
        [self.tableView reloadData];
        
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD showErrorMessage:@"网络异常"];
    }];
}
- (BOOL)isAilpayAccount{
    
    if (_drivModel.ailpayAccount == nil || [_drivModel.ailpayAccount isEqual:[NSNull null]] || _drivModel.ailpayAccount.length <= 0 ) {
        return NO;
    }else{
        return YES;
    }
}
- (BOOL)isBankAccount{
    if (_drivModel.bankCard == nil || [_drivModel.bankCard isEqual:[NSNull null]] || _drivModel.bankCard.length <= 0 ) {
        return NO;
        
    }else{
        
        return YES;
    }
}

#pragma mark =============== 性别delegate ===============
- (void)changeLabelValue:(NSString *)value{
    _sexStr = value;
    if ([_sexStr isEqualToString:@"女"]) {
        [self queryDriverInfo:@"sexuality" :@"0"];
    }else if ([_sexStr isEqualToString:@"男"]){
        [self queryDriverInfo:@"sexuality" :@"1"];
        
    }else if ([_sexStr isEqualToString:@"保密"]){
        [self queryDriverInfo:@"sexuality" :@"2"];
    }
    
}
#pragma mark =============== name delegate ===============

- (void)changeNameValue:(NSString *)value{
    
    if (value != nil || value.length > 0) {
        
        [self queryDriverInfo:@"name" :value];
    }
    
}
- (void)queryDriverInfo:(NSString*)tpye :(NSString*)str{
    
    NSString *url = [NSString stringWithFormat:base_url];
    NSString *urlstr = [url stringByAppendingString:@"app/truckerGroup/updateInfo"];
    [[NetWorkHelper shareInstance]Post:urlstr parameter:@{@"id":_drivModel.id,tpye:str} success:^(id responseObj) {
        NSString *statu =  [responseObj objectForKey:@"message"];
        if ([statu isEqualToString:@"0"]) {
            
            if ([tpye isEqualToString:@"name"]) {
                _drivModel.name = str;
            }if ([tpye isEqualToString:@"sexuality"]) {
                _drivModel.sexuality = str;
            }
            
            [JYAccountTool saveDriverInfoModelInfo:_drivModel];
            [self.tableView reloadData];        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD showErrorMessage:@"网络异常"];
    }];
}

- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        UINavigationController *navi = [[UINavigationController alloc] init];
        
        if (iOS7Later) {
            _imagePickerVc.navigationBar.barTintColor = navi.navigationBar.barTintColor;
        }
        _imagePickerVc.navigationBar.tintColor = navi.navigationBar.tintColor;
        UIBarButtonItem *tzBarItem, *BarItem;
        if (iOS9Later) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
        
    }
    return _imagePickerVc;
}

//调用相机或相册
- (void)ChangeInfoImag{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        //        TZImagePickerController *camerPicker = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
        //        camerPicker.needCircleCrop = YES;
        //        camerPicker.allowCrop =YES;
        //        camerPicker.circleCropRadius = (ScreenWidth -30)/2;
        //        [self presentViewController:camerPicker animated:YES completion:nil];
        
        //相机权限
        
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied){
            //没有权限
            [self presentTipAlertAuthStatus:@"请在iPhone的\"设置-隐私-相机\"选项中，允许简运访问你的手机相机"];
        }else{
            
            UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
                self.imagePickerVc.sourceType = sourceType;
                if(iOS8Later) {
                    
                    _imagePickerVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                }
                [self presentViewController:_imagePickerVc animated:YES completion:nil];
            }
            
            
        }
        
    }];
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        //        UIImagePickerController *photoPicker = [[UIImagePickerController alloc] init];
        //        photoPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //        photoPicker.delegate = self;
        //        photoPicker.allowsEditing = YES;
        //        photoPicker.automaticallyAdjustsScrollViewInsets = NO;
        //        [self presentViewController:photoPicker animated:YES completion:nil];
        ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
        if (author ==ALAuthorizationStatusRestricted || author ==ALAuthorizationStatusDenied){
            //无权限 引导去开启
            [self presentTipAlertAuthStatus:@"请在iPhone的\"设置-隐私-照片\"选项中，允许简运访问你的手机相册"];
            
        }else{
            TZImagePickerController *camerPicker = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
            camerPicker.needCircleCrop = YES;
            camerPicker.allowCrop =YES;
            
            camerPicker.circleCropRadius = (ScreenWidth -50)/2;
            [self presentViewController:camerPicker animated:YES completion:nil];
            
            
        }
        
    }];
    
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [alert addAction:cameraAction];
    }
    
    [cameraAction setValue:RGBA(51, 51, 51, 1) forKey:@"_titleTextColor"];
    [photoAction setValue:RGBA(51, 51, 51, 1) forKey:@"_titleTextColor"];
    [cancelAction setValue:RGBA(51, 51, 51, 1) forKey:@"_titleTextColor"];
    
    [alert addAction:photoAction];
    [alert addAction:cancelAction];
    
    alert.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)presentTipAlertAuthStatus:(NSString *)message{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle: UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication]canOpenURL:url]) {
            
            [[UIApplication sharedApplication]openURL:url];
        }
    }];
    //点击按钮的响应事件
    [alert addAction:cancel];
    [alert addAction:action];
    [self presentViewController:alert animated:true completion:nil];
    
}
- (void)loadImageFinished:(UIImage *)image
{
    NSMutableArray *imageIds = [NSMutableArray array];
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        //写入图片到相册
        PHAssetChangeRequest *req = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        //记录本地标识，等待完成后取到相册中的图片对象
        [imageIds addObject:req.placeholderForCreatedAsset.localIdentifier];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        NSLog(@"success = %d, error = %@", success, error);
        if (success)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD showSuccessMessage:@"保存成功"];
            });
            //            //成功后取相册中的图片对象
            //            __block PHAsset *imageAsset = nil;
            //            PHFetchResult *result = [PHAsset fetchAssetsWithLocalIdentifiers:imageIds options:nil];
            //            [result enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            //                imageAsset = obj;
            //                *stop = YES;
            //            }];
            //            if (imageAsset)
            //            {
            //                //加载图片数据
            //                [[PHImageManager defaultManager] requestImageDataForAsset:imageAsset
            //                                                                  options:nil
            //                                                            resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            //                                                                NSLog(@"imageData = %@", imageData);
            //                                                            }];
            //            }
        }
    }];
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{
    
    //    NSLog(@"%@", info);
    _heardImg = [photos firstObject];
    [self getUpVoucher];
    
}
// 选择图片成功调用此方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    //    [self dismissViewControllerAnimated:YES completion:nil];
    // 选择的图片信息存储于info字典中
    NSLog(@"%@", info);
    _heardImg = [info objectForKey:UIImagePickerControllerEditedImage];
    [self getUpVoucher];
}


//从服务器获取上传七牛的token
- (void)getUpVoucher{
    NSString *baseStr = base_url;
    NSString *urlStr = [baseStr stringByAppendingString:@"app/user/getUpVoucher"];
    
    [[NetWorkHelper shareInstance]Get:urlStr parameter:nil success:^(id responseObj) {
        
        NSString *voucher = [responseObj objectForKey:@"voucher"];
        [self updateheadimage:voucher];
    } failure:^(NSError *error) {
        NSLog(@"error%@",error);
    }];
    
    
}

//上传图片到七牛
- (void)updateheadimage:(NSString *)str{
    //
    QNConfiguration *config = [QNConfiguration build:^(QNConfigurationBuilder *builder) {
        builder.zone = [QNZone zone0];
    }];
    NSString * token = str;
    NSString * keyStr = [NSDate getnowDate:@"YYYYMMddhhmmss"];
    NSString *key = [NSString stringWithFormat:@"DrIcon%@%@.png",_drivModel.phone,keyStr];
    QNUploadManager *upManager = [[QNUploadManager alloc] initWithConfiguration:config];
    NSData *data = [NSData imageData:_heardImg];
    [MBProgressHUD showInfoMessage:@"正在上传头像"];
    
    [upManager putData:data key:key token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        [MBProgressHUD showSuccessMessage:@"更换头像成功"];
        MineRequestData *manager = [[MineRequestData alloc] init];
        manager.delegate = self;
        _drivModel.icon = key;
        [JYAccountTool saveDriverInfoModelInfo:_drivModel];
        //把七牛云的图片名称 上传到服务器
        [manager requsetDataUrl:@"app/logisticsgroup/updateLogisticsGroup" Id:_drivModel.id icon:key];
        
        
    } option:nil];
    
}

//把七牛云的图片名称 上传到服务器
- (void)requestDataInMineSuccess:(NSDictionary *)resultDic{
    NSString *mess = [resultDic objectForKey:@"message"];
    if ([mess isEqualToString:@"0"] || mess == 0) {
        NSLog(@"上传图片名字成功");
        _drivModel = [JYAccountTool getDriverInfoModelInfo];
        [_tableView reloadData];
    }
}

- (void)requestDataInMineFailed:(NSError *)error{
    
    
}
// 取消图片选择调用此方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [self dismissViewControllerAnimated:YES completion:nil];
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

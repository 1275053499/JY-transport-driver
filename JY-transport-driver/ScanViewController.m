//
//  ScanViewController.m
//  JY-transport
//
//  Created by 永和丽科技 on 17/7/10.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "ScanViewController.h"
#import "ZZMaskView.h"
#import "ZZWebViewController.h"
#import "ZZTextViewController.h"
#import "StatusViewController.h"
#import "EntryScanViewController.h"
#import "JYMessageRequestData.h"
#import "JYSearchOrderViewController.h"
@interface ScanViewController ()<AVCaptureMetadataOutputObjectsDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,StatusViewControllerDelegate,EntryScanViewControllerDelegate,JYMessageRequestDataDelegate>


@property (nonatomic, strong) AVCaptureSession *session;

@property (strong,nonatomic) AVCaptureVideoPreviewLayer *layer;

@property (nonatomic, strong) AVCaptureConnection *connection;

@property (nonatomic, assign) BOOL flashOpen;

@property (strong,nonatomic) ZZMaskView *maskView;

@property (nonatomic,strong)NSString *btnType;
@property (nonatomic,strong)NSString *operationType;//操作类型
@property (nonatomic,assign)NSInteger index;

@property (nonatomic,strong)NSString *operationContent;//临时标记 操作内容
@property (nonatomic,assign)NSTimeInterval lastLocationTime;


@end

@implementation ScanViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.session startRunning];
    
    [self.maskView repetitionAnimation];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.session stopRunning];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _btnType = @"";
    _operationType = @"";
    _index = 0;
    _lastLocationTime = 0;
    self.navigationItem.leftBarButtonItem =  [UIBarButtonItem itemWithIcon:@"return" highIcon:@"return" target:self action:@selector(returnAction)];

//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"相册" style:UIBarButtonItemStylePlain target:self action:@selector(openPhoto:)];
//    NSDictionary *dic = @{NSFontAttributeName:[UIFont fontWithName:Default_APP_Font_Reg size:18],
//                          NSForegroundColorAttributeName:[UIColor whiteColor]};
//    [rightItem setTitleTextAttributes:dic forState:UIControlStateNormal];
//    self.navigationItem.rightBarButtonItem = rightItem;

    self.title = @"二维码扫描";
    
    [self setupUI];
    
    
    self.view.backgroundColor = [UIColor blueColor];
    
}
- (void)returnAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setupUI{
    
    _maskView = [[ZZMaskView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64)];
    
    [self.view addSubview:_maskView];
    
    [_maskView.lightBtn addTarget:self action:@selector(openLight:) forControlEvents:UIControlEventTouchUpInside];
   
    _layer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    _layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _maskView.imgBtn.selected = YES;

    _layer.frame = self.view.layer.bounds;
    [self.view.layer insertSublayer:_layer atIndex:0];
    
    if ([self.whitchVCFrom isEqualToString:@"JYOrderDetailViewController"]) {
        
        
        self.navigationItem.rightBarButtonItem = nil;

        [_maskView.imgBtn setImage:[UIImage imageNamed:@"icon_saoma_baise"] forState:(UIControlStateNormal)];
        [_maskView.imgBtn setImage:[UIImage imageNamed:@"icon_saoma_lanse"] forState:(UIControlStateSelected)];
        [_maskView.imgBtn setTitle:@"扫码" forState:(UIControlStateNormal)];
        [_maskView.imgBtn addTarget:self action:@selector(addlogOrderNumber:) forControlEvents:UIControlEventTouchUpInside];
        
        [_maskView.createBtn setImage:[UIImage imageNamed:@"icon_xiangce"] forState:(UIControlStateNormal)];
        [_maskView.createBtn setImage:[UIImage imageNamed:@"icon_xiangce_lanse"] forState:(UIControlStateSelected)];
        [_maskView.createBtn setTitle:@"相册" forState:(UIControlStateNormal)];
        [_maskView.createBtn addTarget:self action:@selector(openPhoto:) forControlEvents:UIControlEventTouchUpInside];

    }else if ([self.whitchVCFrom isEqualToString:@"JYSearchOrderViewController"]){

        _maskView.createBtn.hidden = YES;
        _maskView.imgBtn.hidden = YES;
        _maskView.lightBtn.hidden = YES;
        self.navigationItem.rightBarButtonItem = nil;

    }else{
        
        _btnType = @"query";

        [_maskView.imgBtn addTarget:self action:@selector(queryOrderDetail:) forControlEvents:UIControlEventTouchUpInside];
        [_maskView.createBtn addTarget:self action:@selector(createQR:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
   
}

- (void)addlogOrderNumber:(UIButton *)btn{
    
    _btnType = @"query";
}


//操作按钮
-(void)createQR:(UIButton *)sender{
    _btnType = @"operation";
    sender.selected = YES;
    _maskView.imgBtn.selected = NO;
    StatusViewController * StatusVC = [[StatusViewController alloc] init];
    StatusVC.delegate = self;
    [self.navigationController pushViewController:StatusVC animated:YES];
    
}
//添加运输单号
- (void)chooseOrderNumber:(NSString *)str{
    
    if (str != nil || str.length > 0) {
        
        if ([self.whitchVCFrom isEqualToString:@"JYOrderDetailViewController"]) {
        
            [self querytransportNumber:str];
        
        }
       
    }
    
}

- (void)querytransportNumber:(NSString *)str{
    
    JYMessageRequestData *manager  = [JYMessageRequestData shareInstance];
    manager.delegate = self;
    [manager requsetAddtransportNumber:@"app/logisticsorder/inputTransportNumber" orderId:self.orderId transportNumber:str];
}

//添加运输单号
- (void)requsetAddtransportNumberSuccess:(NSDictionary *)resultDic{
    
    NSString *message = [resultDic objectForKey:@"message"];
    if ([message isEqualToString:@"0"]) {
        [MBProgressHUD showSuccessMessage:@"添加成功"];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [MBProgressHUD showErrorMessage:@"添加失败"];
        [self.navigationController popViewControllerAnimated:YES];


    }
}

- (void)requsetAddtransportNumberFailed:(NSError *)error{
    
    [MBProgressHUD showErrorMessage:@"添加失败"];
    [self.navigationController popViewControllerAnimated:YES];


}
- (void)chooseWhichStatus:(NSString *)str index:(NSInteger)index {
    
    if (str != nil || str.length > 0) {
        _operationType = str;
        _index = index;
        [_maskView.createBtn setTitle:str forState:(UIControlStateSelected)];
        [self creatBtn:_maskView.createBtn];

    }
    
}
- (void)queryOrderDetail:(UIButton *)btn{
    _btnType = @"query";
    btn.selected  = YES;
    _maskView.createBtn.selected = NO;

    
}
- (void)creatBtn:(UIButton *)driverButton{
    
    CGSize imgViewSize,titleSize,btnSize;
    UIEdgeInsets imageViewEdge,titleEdge;
    CGFloat heightSpace = 5.0f;
    
    //设置按钮内边距
    imgViewSize = driverButton.imageView.bounds.size;
    titleSize = driverButton.titleLabel.bounds.size;
    btnSize = driverButton.bounds.size;
    
    
    imageViewEdge = UIEdgeInsetsMake(heightSpace,0, btnSize.height -imgViewSize.height - heightSpace, - titleSize.width);
    [driverButton setImageEdgeInsets:imageViewEdge];
    titleEdge = UIEdgeInsetsMake(imgViewSize.height +heightSpace, - imgViewSize.width, 0.0, 0.0);
    [driverButton setTitleEdgeInsets:titleEdge];
    
}
#pragma mark - 闪光灯开关
-(void)openLight:(UIButton *)sender{
    
    _btnType = @"input";
    EntryScanViewController *aboutOurVC = [[EntryScanViewController alloc] init];
//  aboutOurVC.delegate = self;
    aboutOurVC.whitchVCFrom = self.whitchVCFrom;
    aboutOurVC.orderId = self.orderId;
    [self.navigationController pushViewController:aboutOurVC animated:YES];

//    sender.selected = !sender.selected;
//    if (sender.isSelected == YES) { //打开闪光灯
//        AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
//        NSError *error = nil;
//        
//        if ([captureDevice hasTorch]) {
//            BOOL locked = [captureDevice lockForConfiguration:&error];
//            if (locked) {
//                captureDevice.torchMode = AVCaptureTorchModeOn;
//                [captureDevice unlockForConfiguration];
//            }
//        }
//        
//        [sender setImage:[UIImage imageNamed:@"flashk"] forState:UIControlStateNormal];
//        
//    }else{//关闭闪光灯
//        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
//        if ([device hasTorch]) {
//            [device lockForConfiguration:nil];
//            [device setTorchMode: AVCaptureTorchModeOff];
//            [device unlockForConfiguration];
//        }
//        
//        [sender setImage:[UIImage imageNamed:@"flashg"] forState:UIControlStateNormal];
//    }
    
}

#pragma mark - 打开相册
-(void)openPhoto:(UIButton *)sender{
 
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        controller.delegate = self;
        
        [self presentViewController:controller animated:YES completion:NULL];
    }
    else
    {
        [self showAlertWithTitle:@"提示" message:@"设备不支持访问相册" handler:nil];
    }
    
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    __weak __typeof(self) weakSelf = self;
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        
        CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode
                                                  context:nil
                                                  options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
      
        NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
        if (features.count >= 1)
        {
            CIQRCodeFeature *feature = [features firstObject];
            
            BOOL isURL = [weakSelf getUrlLink:feature.messageString];
            
            if (isURL) {
                
                ZZWebViewController *webVC = [[ZZWebViewController alloc] init];
                
                webVC.url = feature.messageString;
                
                [weakSelf.navigationController pushViewController:webVC animated:YES];
                
            }else{
//                ZZTextViewController *tVC = [[ZZTextViewController alloc] init];
//                tVC.contentStr = feature.messageString;
//                [weakSelf.navigationController pushViewController:tVC animated:YES];
                NSString *str = feature.messageString;
                if ([weakSelf.whitchVCFrom isEqualToString:@"JYOrderDetailViewController"]) {
                    
                    [weakSelf querytransportNumber: str];
                }else if ([self.whitchVCFrom isEqualToString:@"JYMineViewController"]){
                    
                    
                        NSString *index = [NSString stringWithFormat:@"%ld",(long)_index];
                        [self queryTransportStatus:str content:_operationType transportTitle:index];
                    
                    
                }
                
            }
            
        }
        else
        {
            [weakSelf showAlertWithTitle:@"提示" message:@"没有发现二维码" handler:nil];
        }
        
    }];
}

//提交操作 更改物流状态
- (void)queryTransportStatus:(NSString *)transportNumber content:(NSString *)content transportTitle:(NSString *)transportTitle{
    
    JYMessageRequestData *manager = [JYMessageRequestData shareInstance];
    manager.delegate = self;
    [manager requsetSubmitTracking:@"app/tracking/submitTracking" content:content transportNumber:transportNumber transportTitle:transportTitle];
}

- (void)requsetSubmitTrackingSuccess:(NSDictionary *)resultDic{

    NSString *message = [resultDic objectForKey:@"message"];
    if ([message isEqualToString:@"0"]) {
        

        [MBProgressHUD showSuccessMessage:@"操作成功"];
    }
    
}

- (void)requsetSubmitTrackingFailed:(NSError *)error{
    
    
}
#pragma mark - AVCaptureMetadataOutputObjectsDelegate
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects.count > 0)
    {
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects firstObject];
        
        BOOL isURL = [self getUrlLink:metadataObject.stringValue];
        
        if (isURL) {
            [self.session stopRunning];

            ZZWebViewController *webVC = [[ZZWebViewController alloc] init];
            
            webVC.url = metadataObject.stringValue;
            [self.session stopRunning];

            [self.navigationController pushViewController:webVC animated:YES];
            
        }else{

//            ZZTextViewController *tVC = [[ZZTextViewController alloc] init];
//            tVC.contentStr = metadataObject.stringValue;
//            [self.navigationController pushViewController:tVC animated:YES];

            NSString *str = metadataObject.stringValue;
            if ([self.whitchVCFrom isEqualToString:@"JYOrderDetailViewController"]) {
                [self.session stopRunning];

                [self querytransportNumber: str];
            }else if ([self.whitchVCFrom isEqualToString:@"JYMineViewController"]){
                
                if ([_btnType isEqualToString:@"operation"]) {
                    
                    NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970];
                    NSTimeInterval time = nowTime - self.lastLocationTime;
                    if (_operationContent != str) {
                        self.lastLocationTime = [[NSDate date] timeIntervalSince1970];

                            NSLog(@"-----====%@",_operationType);
                            NSString *index = [NSString stringWithFormat:@"%ld",(long)_index];
                            [self queryTransportStatus:str content:_operationType transportTitle:index];

                    
                    }
                    if (_operationContent == str && time > 15) {
                        self.lastLocationTime = [[NSDate date] timeIntervalSince1970];

                        NSLog(@"-----====-----%@",_operationType);
                        NSString *index = [NSString stringWithFormat:@"%ld",(long)_index];
                        [self queryTransportStatus:str content:_operationType transportTitle:index];

                    }
                    _operationContent = str;

                }if ([_btnType isEqualToString:@"query"]) {
                    [self.session stopRunning];

                    JYSearchOrderViewController *vc = [[JYSearchOrderViewController alloc] init];
                    vc.transportNumber = str;
                    vc.type = @"willView";
                    [self.navigationController pushViewController:vc animated:YES];
                    
                }
                
                
            }else if ([self.whitchVCFrom isEqualToString:@"JYSearchOrderViewController"]){
                [self.session stopRunning];

                if ([self.delegate respondsToSelector:@selector(chooseScanNumber:)]) {
                    [self.delegate chooseScanNumber:str];
                }
                [MBProgressHUD showSuccessMessage:@"查询成功"];
                [self.navigationController popViewControllerAnimated:YES];
                
            }
            
           
            
        }
        
        
    }
}


#pragma mark - session
- (AVCaptureSession *)session
{
    if (!_session)
    {
        _session = ({
            //获取摄像设备
            AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
            
            //创建输入流
            AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
            if (!input)
            {
                return nil;
            }
            //创建输出流
            AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
            //设置代理 主线程刷新
            [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
            //设置扫描区域
            CGFloat width = 300 / CGRectGetHeight(self.maskView.frame);
            CGFloat height = 300 / CGRectGetWidth(self.maskView.frame);
            output.rectOfInterest = CGRectMake((1 - width) / 2, (1- height) / 2, width, height);
            
            AVCaptureSession *session = [[AVCaptureSession alloc] init];
            //高质量采集率
            [session setSessionPreset:AVCaptureSessionPresetHigh];
            [session addInput:input];
            [session addOutput:output];
            
            
            //设置编码 二维&条形
            output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,
                                           AVMetadataObjectTypeEAN13Code,
                                           AVMetadataObjectTypeEAN8Code,
                                           AVMetadataObjectTypeCode128Code];
            
            
            session;
        });
    }
    
    return _session;
}


#pragma mark - 正则比配URL
- (BOOL)getUrlLink:(NSString *)link {
    
    NSString *regTags = @"((http[s]{0,1}|ftp|HTTP[S]|FTP)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(((http[s]{0,1}|ftp)://|)((?:(?:25[0-5]|2[0-4]\\d|((1\\d{2})|([1-9]?\\d)))\\.){3}(?:25[0-5]|2[0-4]\\d|((1\\d{2})|([1-9]?\\d))))(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regTags];
    
    BOOL isValid = [predicate evaluateWithObject:link];
    
    return isValid;
}


#pragma mark - 提示框
- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message handler:(void (^) (UIAlertAction *action))handler;
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:handler];
    
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end


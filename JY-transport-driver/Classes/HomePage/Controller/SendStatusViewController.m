//
//  SendStatusViewController.m
//  JY-transport-driver
//
//  Created by 闫振 on 2017/12/9.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "SendStatusViewController.h"
#import "photoTableViewCell.h"
#import <QiniuSDK.h>

@interface SendStatusViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,photoTableViewCellDeledate>
@property (nonatomic,assign)CGFloat Heihht;
@property (nonatomic,assign)BOOL iss;
@property (nonatomic,strong)NSMutableArray *photos;
@property (nonatomic,strong)NSMutableArray *assets;
@property (nonatomic,strong)NSMutableArray *photosName;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSString *textContent;
@property (nonatomic,assign)NSInteger num;
@end

@implementation SendStatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BgColorOfUIView;
    _Heihht = 108;
    _assets = [NSMutableArray array];
    _photos = [NSMutableArray array];
    _photosName = [NSMutableArray array];
    _iss = NO;
    _textContent = @"";
    self.navigationItem.title = @"单据";
    self.navigationItem.leftBarButtonItem =  [UIBarButtonItem itemWithIcon:@"return" highIcon:@"return" target:self action:@selector(returnAction)];

    [self createTableView];

}
- (void)returnAction{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)createTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, ScreenWidth, ScreenHeight -49) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = YES;
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.backgroundColor = BgColorOfUIView;
    [self.view addSubview:self.tableView];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}
- (void)photosArrChangeUpdateView:(NSDictionary *)dic{
    if (dic.count <= 0) {
        return;
    }
    CGFloat h = [[dic objectForKey:@"height"] floatValue];
    _photos = [dic objectForKey:@"photos"];
    _assets  = [dic objectForKey:@"assets"];
    _Heihht = h;
    
    [self.tableView reloadData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return _Heihht + 125 + 2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    photoTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"PhotoCell"];
    if (!cell) {
        cell = [[photoTableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 108 + 125) vc:self];
    }
    
    if (_iss) {
        
        [cell setChangeFrame:_photos asset:_assets];
    }
    cell.textview.delegate = self;
    cell.delegate = self;
    cell.textview.text = _textContent;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (cell.textview.text.length > 0) {
        cell.label.hidden  = YES;
    }
    
    _iss = YES;
    
    return cell;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 414, 10)];
    return v;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 100)];
    view.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.frame = CGRectMake(15, 50, ScreenWidth - 30, 50);
    [btn setTitle:@"上传" forState:(UIControlStateNormal)];
    btn.layer.cornerRadius = 5;
    btn.layer.masksToBounds = YES;
    btn.titleLabel.textColor = [UIColor whiteColor];
    btn.titleLabel.font = [UIFont fontWithName:Default_APP_Font_Reg size:18];
    [btn addTarget:self action:@selector(finishClick:) forControlEvents:(UIControlEventTouchUpInside)];
    btn.backgroundColor = BGBlue;
    [view addSubview:btn];
    
    return view;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
   
    return 100;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
- (void)finishClick:(UIButton *)btn{
    
//    dispatch_async(dispatch_get_main_queue(), ^{
        //刷新UI

        [MBProgressHUD showActivityMessageInView:@"正在上传..."];
        
//    });
    [self getPhotosNameFromPhoto];
    [self getUpVoucher];
    
}

- (void)uploadDataForPhotos{
    
    NSString *baseStr = base_url;
    NSString *urlStr = [baseStr stringByAppendingString:@"app/chartered/uploadEnclosure"];
    
  
    NSString *photoNameStr = @"";
    if (_photosName.count > 0) {
      photoNameStr  = [_photosName componentsJoinedByString:@","];

    }
    
    NSDictionary *dic = @{@"orderNo":self.orderNum,
                          @"enclosure":photoNameStr,
                          @"annexDescription":_textContent,
                          };
    
    [[NetWorkHelper shareInstance]Post:urlStr parameter:dic success:^(id responseObj) {
        
        if ([[responseObj objectForKey:@"message"] isEqualToString:@"0"]) {
            [MBProgressHUD hideHUD];
            dispatch_async(dispatch_get_main_queue(), ^{
                //刷新UI
                
                [MBProgressHUD showSuccessMessage:@"上传成功"];
                [self returnAction];
            });
        }
      
    }failure:^(NSError *error) {
        [MBProgressHUD showSuccessMessage:@"上传失败"];
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)textViewDidChange:(UITextView *)textView{
    _textContent = textView.text;
    UILabel *label;
    for (UIView *view in textView.subviews) {
        if (view.tag == 656) {
           label  = (UILabel *)view;
            
        }
    }
    
    if ([textView.text length] == 0) {
        
        label.hidden = NO;
        
    }else{
        
        label.hidden = YES;
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self.view endEditing:YES];
    return YES;
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

//从服务器获取上传七牛的token
- (void)getUpVoucher{
    NSString *baseStr = base_url;
    NSString *urlStr = [baseStr stringByAppendingString:@"app/user/getUpVoucher"];
    _num = 0;
    [[NetWorkHelper shareInstance]Get:urlStr parameter:nil success:^(id responseObj) {
        
        NSString *voucher = [responseObj objectForKey:@"voucher"];
        
        
        for (NSInteger i = 0; i < _photos.count; i ++) {
            
            [self updateheadimage:voucher index:i];
            
            
        }
        
    } failure:^(NSError *error) {
        NSLog(@"error%@",error);
    }];
}

- (void)getPhotosNameFromPhoto{
   
    if (_photos.count > 0) {
        for (int i = 0; i < _photos.count;i++) {
            NSString * keyStr = [NSDate getnowDate:@"YYYYMMddhhmmss"];
            NSString *key = [NSString stringWithFormat:@"ReceiptPhoto%@%@%d",userPhone,keyStr,i];
            [_photosName addObject:key];
            
        }
    }
    
}
//上传图片到七牛
- (void)updateheadimage:(NSString *)str index:(NSInteger)index{
    
    QNConfiguration *config = [QNConfiguration build:^(QNConfigurationBuilder *builder) {
        builder.zone = [QNZone zone0];
    }];
    
    NSString * token = str;
    NSString *key = _photosName[index];
    QNUploadManager *upManager = [[QNUploadManager alloc] initWithConfiguration:config];
    NSData *data = [NSData imageData:_photos[index]];
    
    [upManager putData:data key:key token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
      
        _num ++;
        NSLog(@"单据 上传到七牛云成功");
        if (_num == _photos.count) {
            [self uploadDataForPhotos];
            NSLog(@"0000000");
        }
        
    } option:nil];
    
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

//
//  DriverEvaluateViewController.m
//  JY-transport-driver
//
//  Created by 闫振 on 2018/1/19.
//  Copyright © 2018年 永和丽科技. All rights reserved.
//

#import "DriverEvaluateViewController.h"
#import "ModelOrder.h"
@interface DriverEvaluateViewController ()<UITextViewDelegate>


@property (nonatomic,strong)UILabel *label;
@property (nonatomic,strong)UITextView *textView;
@property (nonatomic,strong)NSString *content;
@end

@implementation DriverEvaluateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"评论";
    self.view.backgroundColor = BgColorOfUIView;
    _content = @"";
    
    self.navigationItem.leftBarButtonItem =  [UIBarButtonItem itemWithIcon:@"return" highIcon:@"return" target:self action:@selector(returnAction)];
    
    //    UIBarButtonItem *rightItem = [UIBarButtonItem addRight_ItemWithTitle:@"提交" target:self action:@selector(beginSureScore)];
    
    //    NSDictionary *dic = [NSDictionary dictionaryWithObject:RGBA(255, 255, 255, 1) forKey:NSForegroundColorAttributeName];
    //    [rightItem setTitleTextAttributes:dic forState:UIControlStateNormal];
    
    //    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    [self creatTextView];
    self.view.backgroundColor = BgColorOfUIView;
    
    
}
- (void)returnAction
{
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)creatTextView{
    
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 200)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    _label = [[UILabel alloc]initWithFrame:CGRectMake(4, 1, 300, 35)];
    _label.textColor = RGB(153, 153, 153);
    _label.font = [UIFont fontWithName:Default_APP_Font_Reg size:15];
    _label.text = @"请填写您对客户的评价";
    _label.enabled = NO;
    _label.backgroundColor = [UIColor clearColor];
    _label.font = [UIFont systemFontOfSize:15];
    _label.textColor = [UIColor lightGrayColor];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(15, 5, ScreenWidth - 30, 200)];
    _textView.returnKeyType = UIReturnKeyDone;
    _textView.font = [UIFont fontWithName:Default_APP_Font_Reg size:15];
    
    [_textView addSubview:_label];
    _textView.delegate = self;
    [bottomView addSubview:_textView];
    
    UIButton *finishBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    finishBtn.backgroundColor = BGBlue;
    finishBtn.frame =CGRectMake(15, 250, ScreenWidth - 30, 50);
    [finishBtn setTitle:@"提交" forState:(UIControlStateNormal)];
    [finishBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [finishBtn addTarget:self action:@selector(finishBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    finishBtn.layer.cornerRadius = 5;
    finishBtn.layer.masksToBounds = YES;
    
    [self.view addSubview:finishBtn];
    
    
    if (@available(iOS 11.0, *)) {
        self.textView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
}
- (void)finishBtnClick:(UIButton *)btn{
    
    [self postContent];
}
-(void)postContent{
    NSString *url = [NSString stringWithFormat:base_url];
    NSString *urlstr = [url stringByAppendingString:@"app/truckevuser/commitEv"];
    NSString *phone = userPhone;
    NSDictionary *dic = @{@"evaluator":phone,@"comment":_content,@"orderNo":self.model.orderNo,@"evObject":self.model.reqApplicant};
    [[NetWorkHelper shareInstance] Post:urlstr parameter:dic success:^(id responseObj) {
        
        
        //if ([responseObj integerValue] == 0 ) {
        NSLog(@"提交评价成功%@",responseObj);
        //        }
        
        [MBProgressHUD showSuccessMessage:@"提交成功"];
        [self performSelector:@selector(returnAction) withObject:nil afterDelay:0.5];
        
    } failure:^(NSError *error) {
        [MBProgressHUD showErrorMessage:@"网络异常"];
    }];
    
    
    
}
- (void)textViewDidChange:(UITextView *)textView{
    
    _content = textView.text;
    if ([textView.text length] == 0) {
        
        [_label setHidden:NO];
        
    }else
        
    {
        [_label setHidden:YES];
        
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

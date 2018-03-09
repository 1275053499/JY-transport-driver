//
//  CompanyProfileViewController.m
//  JY-transport-driver
//
//  Created by 永和丽科技 on 17/8/18.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "CompanyProfileViewController.h"

@interface CompanyProfileViewController ()<UITextViewDelegate>
@property (nonatomic,strong)UILabel *label;
@property (nonatomic,strong)UITextView *textView;
@property (nonatomic,assign)NSInteger showNum;
@property (nonatomic,assign)NSInteger hideNum;
@end

@implementation CompanyProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     _showNum = 0;
     _hideNum = 0;
    self.navigationItem.title = @"资料";
    self.view.backgroundColor = BgColorOfUIView;
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(returnAction)];
    NSDictionary *dic = @{NSFontAttributeName:[UIFont fontWithName:Default_APP_Font_Reg size:18],
                          NSForegroundColorAttributeName:[UIColor whiteColor]};
    [leftItem setTitleTextAttributes:dic forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    
    UIBarButtonItem *rightItem = [UIBarButtonItem addRight_ItemWithTitle:@"保存" target:self action:@selector(finshBtnBtnClick:)];
    
  
    [rightItem setTitleTextAttributes:dic forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightItem;
    
   

    
    [self creatTextView];
//    //监听当键盘将要出现时
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillShow:)
//                                                 name:UIKeyboardWillShowNotification
//                                               object:nil];
//    
//    //监听当键将要退出时
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillHide:)
//                                                 name:UIKeyboardWillHideNotification
//                                               object:nil];
    
    
}

- (void)finshBtnBtnClick:(UIButton *)btn{
    
    if ([self.delegate respondsToSelector:@selector(changeIntroductionsValue:)]) {
        [self.delegate changeIntroductionsValue:_textView.text];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    

    
}

- (void)creatTextView{
//    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 300, 35)];
    _label.text = @"请认真填写您的公司简介";
    _label.enabled = NO;
    _label.backgroundColor = [UIColor clearColor];
    _label.font = [UIFont systemFontOfSize:15];
    _label.textColor = [UIColor lightGrayColor];
    
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(8, 8, ScreenWidth - 16, ScreenHeight -64)];
    _textView.font = [UIFont systemFontOfSize:15];
    _textView.returnKeyType = UIReturnKeyDone;
    [_textView addSubview:_label];
     self.textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _textView.delegate = self;
    [self.view addSubview:_textView];
    
    
    if (_profileStr.length > 0) {
        
        [_label setHidden:YES];
        _textView.text = _profileStr;
    }
    
}
- (void)textViewDidChange:(UITextView *)textView{
    
    if ([textView.text length] == 0) {
        
        [_label setHidden:NO];
        
    }else
        
    {
        [_label setHidden:YES];
        
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
- (void)returnAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}


//
//
////当键盘出现
//- (void)keyboardWillShow:(NSNotification *)notification
//{
//    // 第三方键盘回调三次问题，监听仅执行最后一次
//   
//    if (_showNum != 0) {
//        return;
//    }
//     CGRect end = [[[notification userInfo] objectForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
//        CGRect frame = self.view.frame;
//        frame.size.height = frame.size.height - end.size.height;
//        self.view.frame =frame;
//        _showNum++;
//}
//
////当键退出
//- (void)keyboardWillHide:(NSNotification *)notification
//{
//     // 第三方键盘回调三次问题，监听仅执行最后一次
//
//    if (_hideNum != 0) {
//        return;
//    }
//    CGRect end = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    CGRect frame = self.view.frame;
//    frame.size.height = end.size.height + frame.size.height;
//    self.view.frame =frame;
//    _hideNum++;
//
//}

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

//
//  EditorPersonNameVC.m
//  JY-transport-driver
//
//  Created by 永和丽科技 on 17/8/1.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "EditorPersonNameVC.h"

@interface EditorPersonNameVC ()<UITextFieldDelegate>
@property (nonatomic,strong)UITextField *textField;
@end

@implementation EditorPersonNameVC




- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BgColorOfUIView;
    
    self.navigationItem.title = @"修改昵称";
    self.navigationItem.leftBarButtonItem =  [UIBarButtonItem itemWithIcon:@"return" highIcon:@"return" target:self action:@selector(returnAction)];
//    NSDictionary *dic = @{NSFontAttributeName:[UIFont fontWithName:Default_APP_Font_Reg size:18],
//                          NSForegroundColorAttributeName:[UIColor whiteColor]};
//    [leftItem setTitleTextAttributes:dic forState:UIControlStateNormal];
    
    
    UIBarButtonItem *rightItem = [UIBarButtonItem addRight_ItemWithTitle:@"保存" target:self action:@selector(finshBtnBtnClick:)];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [self creatTextField];
}
- (void)finshBtnBtnClick:(UIButton *)btn{
    
    BOOL name = [self saveDateNickname:_textField.text];
    if (name) {
        if ([self.delegate respondsToSelector:@selector(changeNameValue:)]) {
            [self.delegate changeNameValue:_textField.text];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        
        [self prentTip];
    }
}
- (void)prentTip{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"昵称只能由中文、字母或数字组成" preferredStyle: UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
    }]];
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
    
}
- (BOOL)saveDateNickname:(NSString *)nickname {
    
    //    NSString *regex =@"[\u4e00-\u9fa5]+[A-Za-z0-9]{6,20}+$";
    NSString *regex = @"[a-zA-Z\u4e00-\u9fa5][a-zA-Z0-9\u4e00-\u9fa5]{0,7}+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL  inputString = [predicate evaluateWithObject:nickname];
    return inputString;
}
- (void)returnAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)creatTextField{
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 8, ScreenWidth, 50)];
    _textField.delegate = self;
    _textField.returnKeyType = UIReturnKeyDone;
    [_textField round:2.0 RectCorners:(UIRectCornerAllCorners)];
    _textField.font = [UIFont fontWithName:Default_APP_Font_Reg size:16];
    
    _textField.text = _name;
    
    _textField.backgroundColor = [UIColor whiteColor];
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    button.frame = CGRectMake(0, 0, 44, 44);
    [button setImage:[UIImage imageNamed:@"icon_shangchu"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    _textField.rightView = button;
    _textField.rightViewMode = UITextFieldViewModeAlways;
    
    //以下代码为了让光标右移
    UILabel * leftView = [[UILabel alloc] initWithFrame:CGRectMake(0,0,20,26)];
    leftView.backgroundColor = [UIColor clearColor];
    _textField.leftView = leftView;
    _textField.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:_textField];
    [_textField becomeFirstResponder];
    
}
- (void)buttonClick:(UIButton *)btn{
    
    _textField.text = @"";
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}

@end
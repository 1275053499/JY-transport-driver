//
//  JYEditCompanyPhoneViewController.m
//  JY-transport-driver
//
//  Created by 闫振 on 2017/8/30.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "JYEditCompanyPhoneViewController.h"

@interface JYEditCompanyPhoneViewController ()<UITextFieldDelegate>

@property (nonatomic,strong)UITextField *textField;

@end

@implementation JYEditCompanyPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BgColorOfUIView;
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(returnAction)];
    NSDictionary *dic = @{NSFontAttributeName:[UIFont fontWithName:Default_APP_Font_Reg size:18],
                          NSForegroundColorAttributeName:[UIColor whiteColor]};
    [leftItem setTitleTextAttributes:dic forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    
    UIBarButtonItem *rightItem =  [UIBarButtonItem addRight_ItemWithTitle:@"保存" target:self action:@selector(finshBtnBtnClick:)];
    
   
    [rightItem setTitleTextAttributes:dic forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightItem;

    [self creatTextField];
}
- (void)finshBtnBtnClick:(UIButton *)btn{
  
        if ([self.delegate respondsToSelector:@selector(changePhoneValue:)]) {
            [self.delegate changePhoneValue:_textField.text];
        }
    
    [self.navigationController popViewControllerAnimated:YES];
    

    
}
- (void)returnAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)creatTextField{
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 8, ScreenWidth, 50)];
    _textField.text = _phoneStr;
    _textField.returnKeyType = UIReturnKeyDone;
    _textField.delegate = self;

    _textField.font = [UIFont fontWithName:Default_APP_Font_Reg size:16];
    [_textField round:2.0 RectCorners:(UIRectCornerAllCorners)];

    
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
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
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

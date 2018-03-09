//
//  StatusAddViewController.m
//  JY-transport-driver
//
//  Created by 闫振 on 2017/9/9.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "StatusAddViewController.h"

@interface StatusAddViewController ()<UITextFieldDelegate>

@property (nonatomic,strong)NSString *textContent;
@end

@implementation StatusAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BgColorOfUIView;
    _textContent = @"";
    self.navigationItem.leftBarButtonItem =  [UIBarButtonItem itemWithIcon:@"return" highIcon:@"return" target:self action:@selector(returnAction)];
    self.navigationItem.title = @"状态添加";
    
    UIBarButtonItem *RightItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finishedClick)];
    NSDictionary *dic = @{NSFontAttributeName:[UIFont fontWithName:Default_APP_Font_Reg size:18],
                          NSForegroundColorAttributeName:[UIColor whiteColor]};
    [RightItem setTitleTextAttributes:dic forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = RightItem;

    
    
    UITextField *text = [[UITextField alloc] initWithFrame:CGRectMake(0, 9, ScreenWidth , 50)];
    text.backgroundColor = [UIColor whiteColor];
    text.returnKeyType = UIReturnKeyDone;
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 10)];
    text.leftView = leftView;
    text.leftViewMode = UITextFieldViewModeAlways;// 必须设置leftViewMode属性，不然leftView不会显示出来
    [text addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    text.delegate = self;
    [self.view addSubview:text];
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        [text becomeFirstResponder];

    });
    
}
- (void)returnAction{
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)finishedClick{

    [self returnAction];
    if ([self.delegate respondsToSelector:@selector(addLogStatus:)]) {
        
        [self.delegate addLogStatus:_textContent];
    }

}


    


- (void)textFieldDidChange:(UITextField *)textField{
    
    _textContent = textField.text;

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    _textContent = textField.text;
    [self.view endEditing:YES];

    return YES;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
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

//
//  BankPickerView.h
//  JY-transport-driver
//
//  Created by 闫振 on 2018/1/16.
//  Copyright © 2018年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BankPickerView : UIView

@property (nonatomic,copy)void(^bankNameBlock)(NSString *name,NSString *nameID);
- (void)showBankPickView;
@end

//
//  RefundDepositView.h
//  JY-transport-driver
//
//  Created by 闫振 on 2018/1/18.
//  Copyright © 2018年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RefundDepositView : UIView

@property (nonatomic,copy)void(^refundDepositBlock)(void);

- (void)showBankPickView;
- (void)setModel:(NSString *)tipContent title:(NSString *)title;

@end

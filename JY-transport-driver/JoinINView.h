//
//  JoinINView.h
//  JY-transport-driver
//
//  Created by 永和丽科技 on 17/8/14.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JoinINViewDelegate <NSObject>

- (void)JoinINViewPressentVC:(NSString *)isSelect;

@end
@interface JoinINView : UIView

@property (nonatomic,strong)id <JoinINViewDelegate>delegate;
- (void)showJoinView;
@end

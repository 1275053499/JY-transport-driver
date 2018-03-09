//
//  EditorPersonNameVC.h
//  JY-transport-driver
//
//  Created by 永和丽科技 on 17/8/1.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol EditorPersonNameVCDelegate <NSObject>

-(void)changeNameValue:(NSString *)value;

@end

@interface EditorPersonNameVC : UIViewController

@property (nonatomic,strong)NSString *name;

@property (nonatomic,strong)id <EditorPersonNameVCDelegate> delegate;
@end

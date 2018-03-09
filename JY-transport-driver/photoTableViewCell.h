//
//  photoTableViewCell.h
//  TZImagePickerController
//
//  Created by 闫振 on 2017/12/9.
//  Copyright © 2017年 谭真. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol photoTableViewCellDeledate <NSObject>

//存储照片的数组发生变化，需要刷新ui
- (void)photosArrChangeUpdateView:(NSDictionary *)dic;

@end

@interface photoTableViewCell : UITableViewCell

@property (nonatomic,strong)id <photoTableViewCellDeledate>delegate;
@property (nonatomic,strong)UILabel *label;
@property (nonatomic,strong)UITextView *textview;
- (instancetype)initWithFrame:(CGRect)frame vc:(UIViewController *)vc;
- (void)setChangeFrame:(NSMutableArray *)photos asset:(NSMutableArray *)asset;
@end

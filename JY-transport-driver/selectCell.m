//
//  selectCell.m
//  TZImagePickerController
//
//  Created by 闫振 on 2017/12/8.
//  Copyright © 2017年 谭真. All rights reserved.
//

#import "selectCell.h"
#define MaxCount  5
#define columnNum 4 //相册里每行个数

#define sendColumnNum 4 //发布时每行个数
#define scrreenWidth [UIScreen mainScreen].bounds.size.width - 30

#define kimageEdge  8
#define kimageWidth (scrreenWidth - (sendColumnNum + 1) *kimageEdge) / sendColumnNum



@interface selectCell ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIView *phoneSuperView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phoneViewConstraintHeight;

@end
@implementation selectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

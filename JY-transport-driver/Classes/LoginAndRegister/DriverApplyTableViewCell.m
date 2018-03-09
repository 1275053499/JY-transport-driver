//
//  DriverApplyTableViewCell.m
//  JY-transport-driver
//
//  Created by 闫振 on 2018/1/9.
//  Copyright © 2018年 永和丽科技. All rights reserved.
//

#import "DriverApplyTableViewCell.h"

@interface DriverApplyTableViewCell()

@end
@implementation DriverApplyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.contenttextField];
    }
    
    return self;
    
}
- (UILabel *)nameLabel{
    if (_nameLabel == nil) {
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 65, 50)];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.font = [UIFont fontWithName:Default_APP_Font_Reg size:16];
        _nameLabel.textColor = RGB(51, 51, 51);
    }
    
    return _nameLabel;
}


-(UITextField *)contenttextField{
    
    if (_contenttextField == nil) {
        
        _contenttextField = [[UITextField alloc] initWithFrame:CGRectMake(65 + 15, 0, ScreenWidth -95 , 50)];
        _contenttextField.textAlignment = NSTextAlignmentLeft;
        _contenttextField.font = [UIFont fontWithName:Default_APP_Font_Reg size:16];
        _contenttextField.textColor = RGB(51, 51, 51);
        
    }
    
    return _contenttextField;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

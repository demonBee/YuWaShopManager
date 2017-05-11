//
//  YWBankTableViewCell.m
//  YuWaShop
//
//  Created by Tian Wei You on 16/11/24.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWBankTableViewCell.h"
#import "JWTools.h"

@implementation YWBankTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.passBtn.layer.borderWidth = 1.f;
    self.passBtn.layer.borderColor = [UIColor colorWithHexString:@"#A1D59C"].CGColor;
    self.passBtn.layer.cornerRadius = 3.f;
    self.passBtn.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setModel:(YWBankModel *)model{
    if (!model)return;
    _model = model;
    [self dataSet];
    [self layoutSet];
}

- (void)dataSet{
    //23333333333
}

- (void)layoutSet{
    self.nameLabelWidth.constant = [JWTools labelWidthWithLabel:self.nameLabel];
    
    [self setNeedsLayout];
}


@end

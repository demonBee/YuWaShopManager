//
//  YWBankTableViewCell.h
//  YuWaShop
//
//  Created by Tian Wei You on 16/11/24.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YWBankModel.h"

@interface YWBankTableViewCell : UITableViewCell

@property (nonatomic,strong)YWBankModel * model;

@property (weak, nonatomic) IBOutlet UIImageView *showImageView;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIButton *teamBtn;
@property (weak, nonatomic) IBOutlet UIButton *cutBtn;
@property (weak, nonatomic) IBOutlet UIButton *passBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLabelWidth;


@end

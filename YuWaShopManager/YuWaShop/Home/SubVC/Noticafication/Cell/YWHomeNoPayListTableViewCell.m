//
//  YWHomeQuickPayListTableViewCell.m
//  YuWaShop
//
//  Created by Tian Wei You on 16/11/29.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWHomeNoPayListTableViewCell.h"
#import "JWTools.h"

@implementation YWHomeNoPayListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setModel:(YWHomeNoPayListModel *)model{
    if (!model)return;
    _model = model;
    [self dataSet];
}
- (void)dataSet{
    self.nameLabel.text = self.model.order.customer_name;
    self.timeLabel.text = [JWTools dateWithStr:(![self.model.order.pay_time isEqualToString:@""]?self.model.order.create_time:self.model.order.pay_time)];
    self.priceLabel.text = [NSString stringWithFormat:@"+%@元",self.model.order.seller_money];
    
    NSString * cutStr;
    NSInteger cutInter = (int)[self.model.order.discount floatValue]*100;
    if (cutInter==0)cutInter = 100;
    if (cutInter%10 == 0) {
        cutStr = cutInter== 100?@" 折扣:无":[NSString stringWithFormat:@" 折扣:%zi折",(cutInter/10)];
    }else{
        cutStr = [NSString stringWithFormat:@" 折扣:%zi折",cutInter];
    }
    self.cutLabel.text = [NSString stringWithFormat:@"原价:%@ 不打折:%@ 实付:%@%@",[self strDelZeraWithStr:self.model.order.total_money],[self strDelZeraWithStr:self.model.order.non_discount_money],[self strDelZeraWithStr:self.model.order.pay_money],cutStr];
    
    if (![self.model.order.is_coupon isEqualToString:@"0"])self.couponLabel.text = [NSString stringWithFormat:@"优惠券减%@元",[self strDelZeraWithStr:self.model.order.coupon_money]];
}

- (NSString *)strDelZeraWithStr:(NSString *)str{
    NSString * priceStr = [str stringByReplacingOccurrencesOfString:@".00" withString:@""];
    priceStr = [priceStr stringByReplacingOccurrencesOfString:@".0" withString:@""];
    return priceStr;
}

@end

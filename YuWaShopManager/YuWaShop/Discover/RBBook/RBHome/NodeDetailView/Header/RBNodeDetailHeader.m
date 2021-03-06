//
//  RBNodeDetailHeader.m
//  NewVipxox
//
//  Created by Tian Wei You on 16/9/12.
//  Copyright © 2016年 WeiJiang. All rights reserved.
//

#import "RBNodeDetailHeader.h"
#import "HttpObject.h"
#import "JWTools.h"

@implementation RBNodeDetailHeader

- (void)awakeFromNib{
    [super awakeFromNib];
    self.attentiionBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.attentiionBtn.layer.borderWidth = 1.f;
    self.attentiionBtn.layer.cornerRadius = 5.f;
    self.attentiionBtn.layer.masksToBounds = YES;
    [self.attentiionBtn setUserInteractionEnabled:NO];
    
    self.iconImageView.layer.cornerRadius = 13.f;
    self.iconImageView.layer.masksToBounds = YES;
    
    self.frame = CGRectMake(0.f, 0.f, kScreen_Width, 55.f);
}

- (void)tapAction{
    self.otherBlock();
}

- (void)setIsUser:(BOOL)isUser{
    _isUser = isUser;
    self.attentiionBtn.hidden = self.isUser;
}

- (void)setInfavs:(NSString *)infavs{
    if (!infavs)return;
    _infavs = infavs;
    if ([self.infavs isEqualToString:@"0"]) {
        self.attentiionBtn.backgroundColor = CNaviColor;
        [self.attentiionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.attentiionBtn setTitle:@"+ 关注" forState:UIControlStateNormal];
    }else{
        self.attentiionBtn.backgroundColor = [UIColor whiteColor];
        [self.attentiionBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.attentiionBtn setTitle:@"已关注" forState:UIControlStateNormal];
    }
}

- (void)setModel:(RBNodeUserModel *)model{
    if (!model)return;
    _model = model;
    [self dataSet];
    [self layoutSet];
}

- (void)dataSet{
    self.nameLabel.text = self.model.nickname;
    if(self.model.user_type)self.levelImageView.hidden = [self.model.user_type integerValue]>=2?NO:YES;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:self.model.images] placeholderImage:[UIImage imageNamed:@"Head-portrait"] completed:nil];
    [self.levelImageView sd_setImageWithURL:[NSURL URLWithString:self.model.level.image] placeholderImage:[UIImage imageNamed:@"level11"] completed:nil];
    
    [self.attentiionBtn setUserInteractionEnabled:YES];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [self addGestureRecognizer:tap];
}

- (void)layoutSet{
    NSDictionary * attributes = @{NSFontAttributeName:self.nameLabel.font};
    CGRect conRect = [self.nameLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT,self.nameLabel.height) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attributes context:nil];
    self.nameLabelWidth.constant = conRect.size.width + 5.f;
    [self setNeedsLayout];
}

- (IBAction)attentiionBtnAction:(id)sender {
    if ([UserSession instance].isLogin) {
        self.infavs = [self.infavs isEqualToString:@"0"]?@"1":@"0";
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if ([self.infavs isEqualToString:@"1"]) {
                [self requestAttention];
            }else{
                [self requestAttentionCancel];
            }
        });
    }else{
        self.careBlock();
    }
}

#pragma mark - Http
- (void)requestAttention{//关注此人
    NSDictionary * pragram = @{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"attention_id":self.model.userid,@"user_type":@([UserSession instance].isVIP==3?2:1)};
    
    [[HttpObject manager]postNoHudWithType:YuWaType_RB_ATTENTION_ADD withPragram:pragram success:^(id responsObj) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code is %@",responsObj);
    } failur:^(id responsObj, NSError *error) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code error is %@",responsObj);
    }];
}
- (void)requestAttentionCancel{
    NSDictionary * pragram = @{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"attention_id":self.model.userid,@"user_type":@([UserSession instance].isVIP==3?2:1)};
    
    [[HttpObject manager]postNoHudWithType:YuWaType_RB_ATTENTION_CANCEL withPragram:pragram success:^(id responsObj) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code is %@",responsObj);
    } failur:^(id responsObj, NSError *error) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code error is %@",responsObj);
    }];
}

@end

//
//  CommentTableViewCell.m
//  YuWa
//
//  Created by 黄佳峰 on 16/9/23.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "CommentTableViewCell.h"
#import "CommentModel.h"
#import "JWTools.h"

@interface CommentTableViewCell()
@property(nonatomic,strong)NSMutableArray*maSaveImageView;

@property(nonatomic,strong)UIView*lineView;
@property(nonatomic,strong)UIImageView*messageImageView;
@property(nonatomic,strong)UILabel*sellerShowLabel;

@end
@implementation CommentTableViewCell

-(void)awakeFromNib{
    [super awakeFromNib];
    
    UIButton*accordButton=[self viewWithTag:233];
    accordButton.userInteractionEnabled=NO;
}

-(void)giveValueWithModel:(ShopdetailModel *)model{
    //默认的数据
    UIImageView*imageView=[self viewWithTag:1];
    [imageView sd_setImageWithURL:[NSURL URLWithString:model.customer_img] placeholderImage:[UIImage imageNamed:@"placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    
    
    UILabel*nameLabel=[self viewWithTag:2];
    nameLabel.text=model.customer_name;
    
    UILabel*timeLabel=[self viewWithTag:3];
    timeLabel.text=[JWTools getTime:model.ctime];
    
    //星星数量 -------------------------------------------------------
    CGFloat realZhengshu;
    CGFloat realXiaoshu;

    NSString*starNmuber=model.score;
    NSString*zhengshu=[starNmuber substringToIndex:1];
    realZhengshu=[zhengshu floatValue];
    NSString*xiaoshu=[starNmuber substringFromIndex:1];
    CGFloat CGxiaoshu=[xiaoshu floatValue];
    
    if (CGxiaoshu>0.5) {
        realXiaoshu=0;
        realZhengshu= realZhengshu+1;
    }else if (CGxiaoshu>0&&CGxiaoshu<=0.5){
        realXiaoshu=0.5;
    }else{
        realXiaoshu=0;
        
    }
    
    for (int i=30; i<35; i++) {
        UIImageView*imageView=[self viewWithTag:i];
        if (imageView.tag-30<realZhengshu) {
            //亮
            imageView.image=[UIImage imageNamed:@"home_lightStar"];
        }else if (imageView.tag-30==realZhengshu&&realXiaoshu!=0){
            //半亮
            imageView.image=[UIImage imageNamed:@"home_halfStar"];
            
        }else{
            //不亮
            imageView.image=[UIImage imageNamed:@"home_grayStar"];
        }
        
        
    }

    // --------------------------------------------------------
    
#pragma  50 的地方
    NSString*detailStr=model.customer_content;
    UILabel*detailLabel=[self viewWithTag:112];
    if (!detailLabel) {
        detailLabel=[[UILabel alloc]initWithFrame:CGRectMake(65, 50, kScreen_Width-65-50, 0)];
        detailLabel.font=FONT_CN_24;
        detailLabel.numberOfLines=0;
        detailLabel.tag=112;
       [self.contentView addSubview:detailLabel];
    }
    
       detailLabel.text=detailStr;
    CGFloat strHeight=[detailStr boundingRectWithSize:CGSizeMake(kScreen_Width-65-50, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;
    detailLabel.height=strHeight;
  
    
    
    NSArray*imageArray=model.img_url;
    CGFloat Top=detailLabel.bottom+10;
    CGFloat Left=65;
    CGFloat HJianju=10;
    CGFloat VJianJu=10;
    CGFloat With=(kScreen_Width-65-30-2*HJianju)/3;
    CGFloat Height=With;
    
    for (UIView*view in self.maSaveImageView) {
        [view removeFromSuperview];
    }
    _maSaveImageView=[NSMutableArray array];
    for (int i=0; i<imageArray.count; i++) {
        int HNmuber=i%3;
        int VNumber=i/3;
        
        
        UIImageView*imageView=[[UIImageView alloc]initWithFrame:CGRectMake(Left+(With+HJianju)*HNmuber, Top+(Height+VJianJu)*VNumber, With, Height)];
        imageView.contentMode=UIViewContentModeScaleAspectFit;
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageArray[i]] placeholderImage:[UIImage imageNamed:@"placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
        [self.contentView addSubview:imageView];
        [_maSaveImageView addObject:imageView];
        
    }
    
    //图片的底部
    NSUInteger VNumber=(imageArray.count-1)/3;
    CGFloat imageVHeight;

    if (imageArray.count>0) {
        imageVHeight=Height+(Height+VJianJu)*VNumber+10;
    }else{
        imageVHeight=0;
    }
    
       CGFloat realImageViewBottom=Top+imageVHeight;     //图片底部的位置
    
    [self.lineView removeFromSuperview];
    [self.messageImageView removeFromSuperview];
    [self.sellerShowLabel removeFromSuperview];
    self.sellerShowLabel=nil;
    
    
    
    
    NSString*seller_content=model.seller_content;
    if (seller_content==nil||[seller_content isEqualToString:@""]) {
        return;
    }
    
    self.lineView=[[UIView alloc]initWithFrame:CGRectMake(65, realImageViewBottom, kScreen_Width-65, 1)];
    self.lineView.backgroundColor=RGBCOLOR(226, 226, 226, 1);
    [self.contentView addSubview:self.lineView];
    
    self.messageImageView=[[UIImageView alloc]initWithFrame:CGRectMake(65, self.lineView.bottom+10, 20, 20)];
    self.messageImageView.image=[UIImage imageNamed:@"messageImage"];
    [self.contentView addSubview:self.messageImageView];
    
    self.sellerShowLabel=[[UILabel alloc]initWithFrame:CGRectMake(65+20+10, self.lineView.bottom+10, kScreen_Width-65-30, 0)];
    self.sellerShowLabel.text=seller_content;
    self.sellerShowLabel.font=[UIFont systemFontOfSize:14];
    self.sellerShowLabel.numberOfLines=0;
    CGFloat labelHeight=[seller_content boundingRectWithSize:CGSizeMake(kScreen_Width-65-30, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;
    self.sellerShowLabel.height =labelHeight;
    [self.contentView addSubview:self.sellerShowLabel];
    
    
    
    
    
}




+(CGFloat)getCellHeight:(ShopdetailModel*)model{

     NSString*detailStr=model.customer_content;
    CGFloat strHeight=[detailStr boundingRectWithSize:CGSizeMake(kScreen_Width-65-50, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;
    CGFloat imageTop =50+strHeight+10;
    
      NSArray*imageArray=model.img_url;
//    CGFloat Top=imageTop;
//    CGFloat Left=65;
    CGFloat HJianju=10;
    CGFloat VJianJu=10;
    CGFloat With=(kScreen_Width-65-30-2*HJianju)/3;
    CGFloat Height=With;
//    for (int i=0; i<imageArray.count; i++) {
//        int HNmuber=i%3;
//        int VNumber=i/3;
//    }
    CGFloat imageBottom;
    
    if (imageArray.count>0) {
        NSUInteger VNumber=(imageArray.count-1)/3;
        CGFloat imageVHeight=Height+(Height+VJianJu)*VNumber+10;
        imageBottom=imageTop+imageVHeight;

    }else{
        imageBottom=imageTop;
    }
    
    
    if (model.seller_content==nil||[model.seller_content isEqualToString:@""]) {
        return imageBottom;
    }

    
    //图片的底部
    CGFloat labelHeight=[model.seller_content boundingRectWithSize:CGSizeMake(kScreen_Width-65-30, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;

    
    
    return imageBottom+10+labelHeight+10;
}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

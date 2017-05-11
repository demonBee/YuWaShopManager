//
//  YWPersonShopModel.m
//  YuWaShop
//
//  Created by Tian Wei You on 16/11/24.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWPersonShopModel.h"

@implementation YWPersonShopModel

static YWPersonShopModel * shop =nil;

+ (YWPersonShopModel *)sharePersonShop{
    if (!shop) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            shop = [[YWPersonShopModel alloc]init];
            [YWPersonShopModel defaultInfoSet];
        });
    }
    return shop;
}

+ (void)defaultInfoSet{
    NSString * showCut;
    if ([UserSession instance].cut%10 == 0) {
        showCut = [UserSession instance].cut== 100?@"全付":[NSString stringWithFormat:@"%zi折",([UserSession instance].cut/10)];
    }else{
        showCut = [NSString stringWithFormat:@"%zi折",[UserSession instance].cut];
    }
    shop.dataArr = [NSMutableArray arrayWithArray:@[@[],@[[UserSession instance].nickName,@"",@""],@[@"",showCut,@""],@[@""]]];
}


@end

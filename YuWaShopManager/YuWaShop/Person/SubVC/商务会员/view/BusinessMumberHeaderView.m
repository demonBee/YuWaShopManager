//
//  BusinessMumberHeaderView.m
//  YuWa
//
//  Created by 黄佳峰 on 2016/11/24.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "BusinessMumberHeaderView.h"

@implementation BusinessMumberHeaderView


-(void)awakeFromNib{
     [super awakeFromNib];
    
    UIView*totailView=[self viewWithTag:21];
    UITapGestureRecognizer*totailTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchTotailTap)];
    [totailView addGestureRecognizer:totailTap];
    
    UIView*WillView=[self viewWithTag:22];
    UITapGestureRecognizer*WillTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchWillTap)];
    [WillView addGestureRecognizer:WillTap];

    
}


-(void)touchTotailTap{
   
    if (self.TotailBlock) {
        self.TotailBlock();
    }
    
}

-(void)touchWillTap{
    if (self.waitBlock) {
        self.waitBlock();
    }
    
}

@end

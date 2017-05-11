//
//  YWPersonCooperaViewController.m
//  YuWaShop
//
//  Created by Tian Wei You on 16/11/23.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWPersonCooperaViewController.h"

@interface YWPersonCooperaViewController ()

@property (nonatomic,copy)NSString * phoneStr;

@end

@implementation YWPersonCooperaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"业务合作";
    [self requestPhoneNumber];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self callService];
    if (self.phoneStr) {
        [self callService];
    }else{
        [self requestPhoneNumber];
    }
}

- (void)callService{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:[UserSession instance].phone style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIWebView* callWebview =[[UIWebView alloc] init];
        NSURL * telURL =[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",@"2333333333"]];
        [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
        [self.view addSubview:callWebview];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Http
- (void)requestPhoneNumber{
    if (![UserSession instance].phone||[[UserSession instance].phone isEqualToString:@""]) {
        [self showHUDWithStr:@"暂无数据,请稍后重试" withSuccess:NO];
        return;
    }
    self.phoneStr = [UserSession instance].phone;
}

@end

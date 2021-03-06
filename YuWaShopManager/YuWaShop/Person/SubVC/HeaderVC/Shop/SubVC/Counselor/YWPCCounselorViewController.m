//
//  YWPCCounselorViewController.m
//  YuWaShop
//
//  Created by Tian Wei You on 16/11/24.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWPCCounselorViewController.h"
#import "NSString+JWAppendOtherStr.h"

@interface YWPCCounselorViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation YWPCCounselorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"营销顾问";
    if ([[UserSession instance].serventPhone isEqualToString:@""]||![UserSession instance].serventPhone) {
        self.nameLabel.text = @"暂无营销顾问电话,请稍后重试";
    }else{
        self.nameLabel.attributedText = [NSString stringWithFirstStr:@"有疑问,请拨打" withFont:[UIFont systemFontOfSize:16.f] withColor:[UIColor blackColor] withSecondtStr:[UserSession instance].serventPhone withFont:[UIFont systemFontOfSize:16.f] withColor:[UIColor colorWithHexString:@"#ff6632"]];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self callService];
}

- (void)callService{
    if ([[UserSession instance].serventPhone isEqualToString:@""]||![UserSession instance].serventPhone) {
        [self showHUDWithStr:@"暂无营销顾问电话,请稍后重试" withSuccess:NO];
        return;
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:[UserSession instance].serventPhone style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIWebView* callWebview =[[UIWebView alloc] init];
        NSURL * telURL =[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",[UserSession instance].serventPhone]];
        [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
        [self.view addSubview:callWebview];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}


@end

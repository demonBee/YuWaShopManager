//
//  PointMoneyViewController.m
//  YuWa
//
//  Created by 黄佳峰 on 2016/11/25.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "PointMoneyViewController.h"
#import "pointMoneyHeaderView.h"   //headerView


#import "JWTools.h"

#import "YWShowGetMoneyViewController.h"

@interface PointMoneyViewController ()

@property(nonatomic,strong)UILabel*currentPointLabel;
@end

@implementation PointMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"积分分红";
    self.view.backgroundColor=[UIColor whiteColor];
    [self addHeaderView];
    [self addBottomImageView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:0];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:1];

}

-(void)addHeaderView{
    pointMoneyHeaderView*view=[[NSBundle mainBundle]loadNibNamed:@"pointMoneyHeaderView" owner:nil options:nil].firstObject;
    view.frame=CGRectMake(0, 0, kScreen_Width, 300);
    [self.view addSubview:view];
    
    
    UILabel*label2=[view viewWithTag:2];
    label2.text=[NSString stringWithFormat:@"当前兑换比例:%@",self.model.pay_scale];
    
    UILabel*label3=[view viewWithTag:3];
    label3.text=[NSString stringWithFormat:@"当前积分：%@",self.model.my_score];
    self.currentPointLabel=label3;
    
    
    UIButton*button5=[view viewWithTag:5];
//    label5.text=[NSString stringWithFormat:@"历史总积分：%@",self.model.total_score];
    [button5 setTitle:[NSString stringWithFormat:@"历史总积分：%@",self.model.total_score] forState:UIControlStateNormal];
    
    UIButton*button6=[view viewWithTag:6];
//    label6.text=[NSString stringWithFormat:@"待结算积分：%@",self.model.settlement_score];
    [button6 setTitle:[NSString stringWithFormat:@"待结算积分：%@",self.model.settlement_score] forState:UIControlStateNormal];
    
    
    view.touchGetMoney=^(){
      //提现
        [self alertViewGetMoney];
        
    };
    
    
    view.touchPointDetail=^(){
      //积分详情
        YWShowGetMoneyViewController*vc=[[YWShowGetMoneyViewController alloc]init];
        vc.time=@"4";
        vc.type=@"2";
        [self.navigationController pushViewController:vc animated:YES];
    };
    
    
}


-(void)alertViewGetMoney{
  NSString*message=[NSString stringWithFormat:@"确实要全部积分(%@)提现？",self.model.my_score];
    UIAlertController*alertVC=[UIAlertController alertControllerWithTitle:@"积分提现" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction*cancelAction=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction*selectedAction=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self getMoneyDatas];
        
    }];
    

    [alertVC addAction:cancelAction];
    [alertVC addAction:selectedAction];
    [self presentViewController:alertVC animated:YES completion:nil];
    
    
    
}


-(void)addBottomImageView{
    UIImageView*bottomImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, kScreen_Height-ACTUAL_HEIGHT(234), kScreen_Width, ACTUAL_HEIGHT(234))];
    bottomImageView.image=[UIImage imageNamed:@"pointBottom.jpg"];
    [self.view addSubview:bottomImageView];
    
}


#pragma mark  --getDatas




-(void)getMoneyDatas{
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,SHOP_POINT_GETMONEY];
    if (!self.model.my_score) {
      
        self.model.my_score=@"0.00";
    }
    NSDictionary*params=@{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"score":self.model.my_score};
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDatasWithUrl:urlStr withParams:params compliation:^(id data, NSError *error) {
        NSLog(@"%@",data);
        NSNumber*number=data[@"errorCode"];
        NSString*errorCode=[NSString stringWithFormat:@"%@",number];
        if ([errorCode isEqualToString:@"0"]) {
            [JRToast showWithText:data[@"msg"]];
            self.model.my_score=@"0.00";
            self.currentPointLabel.text=[NSString stringWithFormat:@"当前积分：%@",self.model.my_score];
            
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
        }
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

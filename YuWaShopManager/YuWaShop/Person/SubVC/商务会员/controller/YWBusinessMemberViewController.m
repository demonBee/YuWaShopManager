//
//  YWBusinessMemberViewController.m
//  YuWa
//
//  Created by 黄佳峰 on 2016/11/24.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWBusinessMemberViewController.h"
#import "BusinessMumberHeaderView.h"   //头
#import "BusinessMoneyTableViewCell.h" //3个cell
#import "MyUserCell.h"       //底部的cell

#import "JWTools.h"

#import "BusinessBaseInfoModel.h"   
#import "introduceModel.h"
//#import "BusinessMoneyModel.h"
#import "ScoreModel.h"
#import "BindingPersonModel.h"


#import "IntroduceMoneyViewController.h"   //介绍分红
//#import "BusinessMoneyViewController.h"   //商务分红
#import "PointMoneyViewController.h"     //积分分红界面
#import "SignUserViewController.h"    //我锁定的人

#import "YWShowGetMoneyViewController.h"   //展示收入界面

#define CELL0  @"BusinessMoneyTableViewCell"
#define CELL1  @"MyUserCell"


@interface YWBusinessMemberViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView*tableView;


@property(nonatomic,strong)BusinessBaseInfoModel*base_infoModel;
@property(nonatomic,strong)introduceModel*introduceModel;
@property(nonatomic,strong)ScoreModel*scoreModel;
@property(nonatomic,strong)BindingPersonModel*BiningModel;



@end

@implementation YWBusinessMemberViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:CELL0 bundle:nil] forCellReuseIdentifier:CELL0];
    [self.tableView registerNib:[UINib nibWithNibName:CELL1 bundle:nil] forCellReuseIdentifier:CELL1];
    
    [self setUpMJRefresh];
    

    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:0];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[[self.navigationController.navigationBar subviews]objectAtIndex:0] setAlpha:1];
    
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat aa =scrollView.contentOffset.y;
    MyLog(@"%f",aa);
    if (aa<=190) {
          [[[self.navigationController.navigationBar subviews]objectAtIndex:0] setAlpha:0];
    }else if (190<aa&&aa<=250){
        CGFloat scale=(aa-190)/60;
        
        [[[self.navigationController.navigationBar subviews]objectAtIndex:0] setAlpha:scale];

        
    }else if (aa>250){
        [[[self.navigationController.navigationBar subviews]objectAtIndex:0] setAlpha:1];

    }else{
        [[[self.navigationController.navigationBar subviews]objectAtIndex:0] setAlpha:0];

    }
    
}

-(void)setUpMJRefresh{

    
    self.tableView.mj_header=[UIScrollView scrollRefreshGifHeaderWithImgName:@"newheader" withImageCount:60 withRefreshBlock:^{
        [self getDatas];
        
    }];
    

    
    [self.tableView.mj_header beginRefreshing];
    
    
    
}

#pragma mark  --UI
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BusinessMoneyTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:CELL0];
    cell.selectionStyle=NO;
    
    //图标
    UIImageView*imageView=[cell viewWithTag:1];
    //titleLabel
    UILabel*titleLabel=[cell viewWithTag:2];
    //topLabel
    UILabel*topLabel=[cell viewWithTag:4];
    //
    UILabel*subLabel=[cell viewWithTag:5];
    //
    UILabel*timeLabel=[cell viewWithTag:6];
    
    
    //
    UILabel*totailLabel=[cell viewWithTag:12];
    //
    UILabel*todayLabel=[cell viewWithTag:14];
    //
    UILabel*waitLabel=[cell viewWithTag:16];
    
    
    if (indexPath.section==0) {
        //介绍分红
        imageView.image=[UIImage imageNamed:@"介绍分红"];
        titleLabel.text=@"介绍分红";
        topLabel.text=[NSString stringWithFormat:@"%@",self.introduceModel.rose_introduce];
        subLabel.text=@"近一周涨幅";
        timeLabel.text=[JWTools currentTime];
        
        totailLabel.text=self.introduceModel.total_introduce;
        todayLabel.text=self.introduceModel.today_introduce;
        waitLabel.text=self.introduceModel.settlement_introduce;
        
    }else if (indexPath.section==1){
        // 积分分红
         imageView.image=[UIImage imageNamed:@"积分分红"];
        titleLabel.text=@"积分分红";
        topLabel.text=[NSString stringWithFormat:@"%@",self.scoreModel.my_score];
        subLabel.text=@"当前积分";
        timeLabel.text=[JWTools currentTime];
        
        totailLabel.text=self.scoreModel.total_score;
        todayLabel.text=self.scoreModel.today_score;
        waitLabel.text=self.scoreModel.settlement_score;

        
        
    }
    
    
    if (indexPath.section==2) {
        MyUserCell*cell=[tableView dequeueReusableCellWithIdentifier:CELL1];
        cell.selectionStyle=NO;
        
        UILabel*directBinding=[cell viewWithTag:1];   //直接锁定
        directBinding.text=[NSString stringWithFormat:@"%@人",self.BiningModel.my_direct_user_nums];
        
        UILabel*indirectBinding=[cell viewWithTag:22];  //间接锁定
        indirectBinding.text=[NSString stringWithFormat:@"%@人",self.BiningModel.my_indirect_user_nums];
        
        return cell;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        IntroduceMoneyViewController*vc=[[IntroduceMoneyViewController alloc]init];
        vc.model=self.introduceModel;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.section==1){
        PointMoneyViewController*vc=[[PointMoneyViewController alloc]init];
        vc.model=self.scoreModel;
        [self.navigationController pushViewController:vc animated:YES];
        
        
    }else if (indexPath.section==2){
        SignUserViewController*vc=[[SignUserViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
    
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0) {
        BusinessMumberHeaderView*view=[[NSBundle mainBundle]loadNibNamed:@"BusinessMumberHeaderView" owner:nil options:nil].firstObject;
        
        //今日收益
        UILabel*label2=[view viewWithTag:2];
        label2.text=self.base_infoModel.today_money;
        
        //总收益
        UILabel*label4=[view viewWithTag:4];
        label4.text=self.base_infoModel.total_money;
        
        //总待结算收益
        UILabel*label5=[view viewWithTag:5];
        label5.text=@"总待结算收益";
        
        UILabel*label6=[view viewWithTag:6];
        label6.text=self.base_infoModel.total_settlement;
        
        
        //总共的 详情
        view.TotailBlock=^(){
            YWShowGetMoneyViewController*vc=[[YWShowGetMoneyViewController alloc]init];
            vc.time=@"4";
            vc.type=@"3";
            [self.navigationController pushViewController:vc animated:YES];

        };
        
        //总的待结算
        view.waitBlock=^(){
            YWShowGetMoneyViewController*vc=[[YWShowGetMoneyViewController alloc]init];
            vc.time=@"4";
            vc.type=@"4";
            [self.navigationController pushViewController:vc animated:YES];

            
        };
        
        
        return view;
        
    }
    
    return nil;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 250;
    }
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 215;
}




#pragma mark  --getDatas
-(void)getDatas{
   
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,SHOP_HOME_SHAREMONEY];
    NSDictionary*params=@{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid)};
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDatasNoHudWithUrl:urlStr withParams:params compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        NSNumber*number=data[@"errorCode"];
        NSString*errorCode=[NSString stringWithFormat:@"%@",number];
        if ([errorCode isEqualToString:@"0"]) {
            self.base_infoModel=[BusinessBaseInfoModel yy_modelWithDictionary:data[@"data"][@"base_info"]];
            self.introduceModel=[introduceModel yy_modelWithDictionary:data[@"data"][@"introduce"]];
            self.scoreModel=[ScoreModel yy_modelWithDictionary:data[@"data"][@"score"]];
            self.BiningModel=[[BindingPersonModel alloc]init];
            self.BiningModel.my_direct_user_nums=data[@"data"][@"my_direct_user_nums"];
            self.BiningModel.my_indirect_user_nums=data[@"data"][@"my_indirect_user_nums"];
            
            [self.tableView reloadData];
            
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
        }
        
        [self.tableView.mj_header endRefreshing];

        
        
        
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

#pragma mark  --set
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
    }
    return _tableView;
}

@end

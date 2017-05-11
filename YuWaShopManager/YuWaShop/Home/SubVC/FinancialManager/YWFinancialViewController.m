//
//  YWFinancialViewController.m
//  YuWaShop
//
//  Created by 黄佳峰 on 2016/12/5.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWFinancialViewController.h"
#import "FinancialTableViewCell.h"

#import "FinancailBaseModel.h"
#import "FinancailListModel.h"

#import "UIScrollView+JWGifRefresh.h"


#import "DayDetailViewController.h"





#define CELL0     @"FinancialTableViewCell"
@interface YWFinancialViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView*tableView;
@property(nonatomic,strong)UISegmentedControl*typeSegmentView;

@property(nonatomic,assign)NSInteger type;  //0为结算   1为记录
@property(nonatomic,assign)int pagen;
@property(nonatomic,assign)int pages;
@property(nonatomic,strong)NSMutableArray*allDatasModel;
@property(nonatomic,strong)FinancailBaseModel*baseModel;
@end

@implementation YWFinancialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.navigationController.navigationBar  setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:CELL0 bundle:nil] forCellReuseIdentifier:CELL0];
    [self makeTopView];
    [self setupRefresh];
}
#pragma mark - TableView Refresh
- (void)setupRefresh{
    self.allDatasModel=[NSMutableArray array];
    self.tableView.mj_header = [UIScrollView scrollRefreshGifHeaderWithImgName:@"newheader" withImageCount:60 withRefreshBlock:^{
        self.allDatasModel=[NSMutableArray array];
        self.pagen=10;
        self.pages=0;
        [self getDatas];
     
    }];
    self.tableView.mj_footer = [UIScrollView scrollRefreshGifFooterWithImgName:@"newheader" withImageCount:60 withRefreshBlock:^{
        self.pagen=10;
        self.pages++;
        [self getDatas];

    }];
    
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark  --  UI
-(void)makeTopView{
  
    
    self.typeSegmentView=[[UISegmentedControl alloc]initWithItems:@[@"结算",@"记录"]];
    self.typeSegmentView.frame=CGRectMake(0, 0, 150, 35);
    self.typeSegmentView.selectedSegmentIndex=0;
    [self.typeSegmentView setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    [self.typeSegmentView setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:CNaviColor} forState:UIControlStateSelected];
    self.typeSegmentView.layer.borderColor=[UIColor whiteColor].CGColor;
    self.typeSegmentView.layer.borderWidth=2;
    self.typeSegmentView.layer.cornerRadius = 17.f;
    self.typeSegmentView.layer.masksToBounds = YES;
    [self.typeSegmentView addTarget:self action:@selector(segmentControlAction:) forControlEvents:UIControlEventValueChanged];

      self.navigationItem.titleView=self.typeSegmentView;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.type==0) {
        //结算
        return 1;
    }else{
        //记录    如果没有数据 就显示空的
        return self.allDatasModel.count;
        
    }
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.type==0) {
        FinancialTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:CELL0];
        
        UILabel*label2=[cell viewWithTag:2];
        label2.text=self.baseModel.pay_type;
        
         UILabel*label4=[cell viewWithTag:4];
        label4.text=self.baseModel.pay_time;
        
         UILabel*label6=[cell viewWithTag:6];
        NSString*time=[JWTools getTime:self.baseModel.tomorrow];
        label6.text=[NSString stringWithFormat:@"%@(共%@)",time,self.baseModel.next_money];
        
      
        return cell;
        
        
    }else{
        UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
            
        }
        FinancailListModel*model=self.allDatasModel[indexPath.row];
        
        
        NSString*time=[JWTools getTime:model.ctime];
        cell.textLabel.text=time;
        NSString*status;
        if ([model.is_pay isEqualToString:@"0"]) {
            status=@"未结算";
        }else{
            status=@"已结算";
        }
        
        cell.detailTextLabel.text=[NSString stringWithFormat:@"%@(%@)",model.money,status];
        
        return cell;
        
    }
   
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.type==1) {
        //记录
        FinancailListModel*model=self.allDatasModel[indexPath.row];
        
        DayDetailViewController*vc=[[DayDetailViewController alloc]init];
        vc.ctime=model.ctime;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}


-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.type==0) {
        UIView*headerView=[[NSBundle mainBundle]loadNibNamed:@"FinancialHeaderView" owner:nil options:nil].firstObject;
        headerView.frame=CGRectMake(0, 0, kScreen_Width, 170);
        
        
        UILabel*moneyLabel=[headerView viewWithTag:2];
        moneyLabel.text=self.baseModel.total_settlement;
        
        UILabel*todayLabel=[headerView viewWithTag:4];
        todayLabel.text=self.baseModel.today_money;
        
        return headerView;
    }else{
        UIView*accordView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 35)];
        accordView.backgroundColor=[UIColor whiteColor];
        
        UILabel*titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, kScreen_Width/2, 20)];
        titleLabel.centerY=accordView.centerY;
        titleLabel.textColor=RGBCOLOR(160, 161, 165, 1);
        titleLabel.font=[UIFont systemFontOfSize:15];
        titleLabel.text=@"账单记录";
        [accordView addSubview:titleLabel];
        
        return accordView;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.type==0) {
        return 100;
    }else{
        return 44;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.type==0) {
        return 170;
    }
    return 35;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001f;
}

#pragma mark  --getDatas
-(void)getDatas{
    if (self.type==0) {
        //这里是结算
        [self financialInfo];
    }else{
        //这里是记录的列表
        [self financialList];
    }
  
    
    
    
    
    
}

-(void)financialInfo{
      NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,SHOP_FINANCIALBASE];
    NSDictionary*params=@{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid)};
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDatasNoHudWithUrl:urlStr withParams:params compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        NSNumber*number=data[@"errorCode"];
        NSString*errorCode=[NSString stringWithFormat:@"%@",number];
        if ([errorCode isEqualToString:@"0"]) {
            self.baseModel=[FinancailBaseModel yy_modelWithDictionary:data[@"data"]];
            
            
            [self.tableView reloadData];
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
        }
        
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];

        
    }];
    
    
}

-(void)financialList{
     NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,SHOP_FINANCIALLIST];
    NSString*pagen=[NSString stringWithFormat:@"%d",self.pagen];
    NSString*pages=[NSString stringWithFormat:@"%d",self.pages];
    
     NSDictionary*params=@{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"pagen":pagen,@"pages":pages};
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDatasNoHudWithUrl:urlStr withParams:params compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        NSNumber*number=data[@"errorCode"];
        NSString*errorCode=[NSString stringWithFormat:@"%@",number];
        if ([errorCode isEqualToString:@"0"]) {
            for ( NSDictionary*dict  in data[@"data"]) {
                FinancailListModel*model=[FinancailListModel yy_modelWithDictionary:dict];
                [self.allDatasModel addObject:model];
                
            }
            
            
            [self.tableView reloadData];
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
        }
        
        
        
        
        
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];

    }];
    
}


#pragma mark  --touch
- (void)segmentControlAction:(UISegmentedControl *)sender{
    self.type = sender.selectedSegmentIndex;
    [self.tableView.mj_header beginRefreshing];

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

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
    }
    return _tableView;
}


@end

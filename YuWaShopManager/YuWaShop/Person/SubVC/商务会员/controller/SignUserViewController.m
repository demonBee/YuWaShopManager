//
//  SignUserViewController.m
//  YuWa
//
//  Created by 黄佳峰 on 2016/11/28.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "SignUserViewController.h"
#import "SignUserTableViewCell.h"
#import "YJSegmentedControl.h"

#import "SignUserModel.h"

#import "JWTools.h"

#define CELL0    @"SignUserTableViewCell"

@interface SignUserViewController ()<UITableViewDelegate,UITableViewDataSource,YJSegmentedControlDelegate>

@property(nonatomic,strong)UITableView*tableView;

@property(nonatomic,strong)NSMutableArray*maMallDatas;
@property(nonatomic,strong)NSString*type;   //0直接绑定  1间接绑定
@property(nonatomic,assign)int pagen;
@property(nonatomic,assign)int pages;

@end

@implementation SignUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   self.title=@"锁定会员";
    self.type=@"0";
    self.automaticallyAdjustsScrollViewInsets=NO;
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:CELL0 bundle:nil] forCellReuseIdentifier:CELL0];
    [self makeTopChooseView];
    [self setUpMJRefresh];
    
//    UILabel*label=[[UILabel alloc]init];

    
}

#pragma mark  --UI
-(void)setUpMJRefresh{
    self.pagen=10;
    self.pages=0;
    self.maMallDatas=[NSMutableArray array];
    
    self.tableView.mj_header=[UIScrollView scrollRefreshGifHeaderWithImgName:@"newheader" withImageCount:60 withRefreshBlock:^{
        self.pages=0;
        self.maMallDatas=[NSMutableArray array];
        [self getDatas];
        
    }];
    
    //上拉刷新
    self.tableView.mj_footer = [UIScrollView scrollRefreshGifFooterWithImgName:@"newheader" withImageCount:60 withRefreshBlock:^{
        self.pages++;
        [self getDatas];
        
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
    
    
}



-(void)makeTopChooseView{
    NSArray*arrayTitle=@[@"直接锁定",@"间接锁定"];
    YJSegmentedControl*chooseView=[YJSegmentedControl segmentedControlFrame:CGRectMake(0, 64, kScreen_Width, 40) titleDataSource:arrayTitle backgroundColor:[UIColor whiteColor] titleColor:[UIColor blackColor] titleFont:[UIFont systemFontOfSize:14] selectColor:CNaviColor buttonDownColor:CNaviColor Delegate:self];
    [self.view addSubview:chooseView];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.maMallDatas.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SignUserTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:CELL0];
    cell.selectionStyle=NO;
    
    SignUserModel*model=self.maMallDatas[indexPath.row];
    
    UILabel*nameLabel=[cell viewWithTag:1];
    nameLabel.text=model.user_name;
   
    UILabel*moneyLabel=[cell viewWithTag:2];
    moneyLabel.text=[NSString stringWithFormat:@"总分红金额:%@",model.money];
    
    UILabel*timeLabel=[cell viewWithTag:3];
    timeLabel.text=[JWTools getTime:model.ctime];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 88;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}


#pragma mark  --delegate
-(void)segumentSelectionChange:(NSInteger)selection{
    if (selection==0) {
        self.type=@"0";
    }else{
        self.type=@"1";
    }
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark  --getDatas
-(void)getDatas{
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,SHOP_BIND_USER];
    NSDictionary*params=@{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"type":self.type};
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDatasWithUrl:urlStr withParams:params compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        NSNumber*number=data[@"errorCode"];
        NSString*errorCode=[NSString stringWithFormat:@"%@",number];
        if ([errorCode isEqualToString:@"0"]) {
            for (NSDictionary*dict in data[@"data"]) {
                SignUserModel*model=[SignUserModel yy_modelWithDictionary:dict];
                [self.maMallDatas addObject:model];
                
            }
            
            [self.tableView reloadData];
            
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
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
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64+40, kScreen_Width, kScreen_Height-64-40) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
    }
    return _tableView;
}

@end

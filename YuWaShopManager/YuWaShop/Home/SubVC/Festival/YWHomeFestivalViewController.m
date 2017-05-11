//
//  YWHomeFestivalViewController.m
//  YuWaShop
//
//  Created by Tian Wei You on 16/11/29.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWHomeFestivalViewController.h"
#import "YWHomeFestivalTableViewCell.h"
#import "YWHomeAddFastivalViewController.h"
#import "NSDictionary+Attributes.h"

@interface YWHomeFestivalViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)NSMutableArray * dataArr;
@property (nonatomic,copy)NSString * pagens;
@property (nonatomic,assign)NSInteger pages;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *addFastivalBtn;
@property (nonatomic,strong)UIView * headerView;
@property (nonatomic,strong)UISegmentedControl * typeSegmentView;
@property (nonatomic,assign)NSInteger type;

@end

@implementation YWHomeFestivalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"节日管理";
    [self makeUI];
    [self dataSet];
    [self setupRefresh];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView.mj_header beginRefreshing];
}

- (void)makeUI{
    self.addFastivalBtn.layer.cornerRadius = 5.f;
    self.addFastivalBtn.layer.masksToBounds = YES;
    self.headerView = [[UIView alloc]initWithFrame:CGRectMake(0.f, 0.f, kScreen_Width, 47.f)];
    self.headerView.backgroundColor = [UIColor whiteColor];
    
    self.typeSegmentView = [[UISegmentedControl alloc]initWithItems:@[@"未开始",@"进行中",@"已结束"]];
    self.typeSegmentView.frame = CGRectMake(20.f, 5.f, kScreen_Width - 40.f, 30.f);
    self.typeSegmentView.selectedSegmentIndex = 0;
    [self.typeSegmentView setTitleTextAttributes:[NSDictionary dicOfTextAttributeWithFont:[UIFont systemFontOfSize:15.f] withTextColor:[UIColor colorWithHexString:@"#25C0E9"]] forState:UIControlStateNormal];
    [self.typeSegmentView setTitleTextAttributes:[NSDictionary dicOfTextAttributeWithFont:[UIFont systemFontOfSize:15.f] withTextColor:[UIColor whiteColor]] forState:UIControlStateSelected];
    self.typeSegmentView.tintColor = CNaviColor;
    self.typeSegmentView.layer.borderColor = CNaviColor.CGColor;
    [self.typeSegmentView setDividerImage:[UIImage imageNamed:@"segmentLine"] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    self.typeSegmentView.layer.borderWidth = 2.f;
    self.typeSegmentView.layer.cornerRadius = 5.f;
    self.typeSegmentView.layer.masksToBounds = YES;
    [self.typeSegmentView addTarget:self action:@selector(segmentControlAction:) forControlEvents:UIControlEventValueChanged];
    [self.headerView addSubview:self.typeSegmentView];
}

- (void)dataSet{
    self.type = 1;
    self.pagens = @"10";
    self.dataArr = [NSMutableArray arrayWithCapacity:0];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"YWHomeFestivalTableViewCell" bundle:nil] forCellReuseIdentifier:@"YWHomeFestivalTableViewCell"];
}

- (IBAction)addFastivalBtnAction:(id)sender {
    YWHomeAddFastivalViewController * vc = [[YWHomeAddFastivalViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)segmentControlAction:(UISegmentedControl *)sender{
    self.type = sender.selectedSegmentIndex+1;
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 47.f;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.headerView;
}
- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle ==UITableViewCellEditingStyleDelete){
        UIAlertAction * OKAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            YWHomeFestivalModel * model = self.dataArr[indexPath.row];
            [self requestDelFastivalWithID:model.fastivalID withIndexPath:indexPath];
        }];
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
        UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认删除节日活动?" preferredStyle:UIAlertControllerStyleAlert];
        [alertVC addAction:cancelAction];
        [alertVC addAction:OKAction];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertVC animated:YES completion:nil];
    }
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YWHomeFestivalTableViewCell * festivalCell = [tableView dequeueReusableCellWithIdentifier:@"YWHomeFestivalTableViewCell"];
    festivalCell.model = self.dataArr[indexPath.row];
    festivalCell.status = self.type;
    return festivalCell;
}

#pragma mark - TableView Refresh
- (void)setupRefresh{
    self.tableView.mj_header = [UIScrollView scrollRefreshGifHeaderWithImgName:@"newheader" withImageCount:60 withRefreshBlock:^{
        [self headerRereshing];
    }];
    self.tableView.mj_footer = [UIScrollView scrollRefreshGifFooterWithImgName:@"newheader" withImageCount:60 withRefreshBlock:^{
        [self footerRereshing];
    }];
}
- (void)headerRereshing{
    self.pages = 0;
    [self requestDataWithPages:0];
}
- (void)footerRereshing{
    self.pages++;
    [self requestDataWithPages:self.pages];
}
- (void)cancelRefreshWithIsHeader:(BOOL)isHeader{
    if (isHeader) {
        [self.tableView.mj_header endRefreshing];
    }else{
        [self.tableView.mj_footer endRefreshing];
    }
}

#pragma mark - Http
- (void)requestDataWithPages:(NSInteger)page{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(RefreshTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self cancelRefreshWithIsHeader:(page==0?YES:NO)];
    });
    NSInteger status;
    switch (self.type) {
        case 1:
            status = 2;
            break;
        case 2:
            status = 1;
            break;
        case 3:
            status = 3;
            break;
            
        default:
            break;
    }
    
    NSDictionary * pragram = @{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"type":@(status),@"pagen":@([self.pagens integerValue]),@"pages":@(page)};
    
    [[HttpObject manager]postNoHudWithType:YuWaType_Shoper_ShopAdmin_HolidayLists withPragram:pragram success:^(id responsObj) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code is %@",responsObj);
        if (page == 0)[self.dataArr removeAllObjects];
        NSArray * dataArr = responsObj[@"data"];
        for (int i = 0; i<dataArr.count; i++) {
            [self.dataArr addObject:[YWHomeFestivalModel yy_modelWithDictionary:dataArr[i]]];
        }
        [self.tableView reloadData];
    } failur:^(id responsObj, NSError *error) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code error is %@",responsObj);
    }];
}

- (void)requestDelFastivalWithID:(NSString *)bankID withIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * pragram = @{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"id":@([bankID integerValue])};
    
    [[HttpObject manager]postDataWithType:YuWaType_Shoper_ShopAdmin_DelHoliday withPragram:pragram success:^(id responsObj) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code is %@",responsObj);
        [self.dataArr removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [self showHUDWithStr:@"删除成功" withSuccess:YES];
    } failur:^(id responsObj, NSError *error) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code error is %@",responsObj);
    }];
}

@end

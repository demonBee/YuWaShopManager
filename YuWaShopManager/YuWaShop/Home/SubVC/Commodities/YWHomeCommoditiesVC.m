//
//  YWHomeCommoditiesVC.m
//  YuWaShop
//
//  Created by Tian Wei You on 16/11/29.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWHomeCommoditiesVC.h"
#import "YWHomeAddCommoditiesVC.h"
#import "YWHomeCommoditiesTableViewCell.h"

@interface YWHomeCommoditiesVC ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *addCommoditiesBtn;
@property (nonatomic,copy)NSString * pagens;
@property (nonatomic,assign)NSInteger pages;
@property (nonatomic,strong)NSMutableArray * dataArr;

@end

@implementation YWHomeCommoditiesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商品管理";
    [self makeUI];
    [self dataSet];
    [self setupRefresh];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView.mj_header beginRefreshing];
}

- (void)makeUI{
    self.addCommoditiesBtn.layer.cornerRadius = 5.f;
    self.addCommoditiesBtn.layer.masksToBounds = YES;
}

- (void)dataSet{
    self.pagens = @"10";
    self.dataArr = [NSMutableArray arrayWithCapacity:0];
    [self.tableView registerNib:[UINib nibWithNibName:@"YWHomeCommoditiesTableViewCell" bundle:nil] forCellReuseIdentifier:@"YWHomeCommoditiesTableViewCell"];
}

- (IBAction)addCommoditiesBtnAction:(id)sender {
    YWHomeAddCommoditiesVC * vc = [[YWHomeAddCommoditiesVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90.f;
}
- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle ==UITableViewCellEditingStyleDelete){
        UIAlertAction * OKAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            YWHomeCommoditiesModel * model = self.dataArr[indexPath.row];
            [self requestDelWithID:model.commoditiesID withIndexPath:indexPath];
        }];
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
        UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认删除此商品?" preferredStyle:UIAlertControllerStyleAlert];
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
    YWHomeCommoditiesTableViewCell * commoditiesCell = [tableView dequeueReusableCellWithIdentifier:@"YWHomeCommoditiesTableViewCell"];
    commoditiesCell.model = self.dataArr[indexPath.row];
    return commoditiesCell;
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
    
    NSDictionary * pragram = @{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"pagen":@([self.pagens integerValue]),@"pages":@(page)};
    
    [[HttpObject manager]postNoHudWithType:YuWaType_Shoper_ShopAdmin_GoodsLists withPragram:pragram success:^(id responsObj) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code is %@",responsObj);
        if (page == 0)[self.dataArr removeAllObjects];
        NSArray * dataArr = responsObj[@"data"];
        for (int i = 0; i<dataArr.count; i++) {
            YWHomeCommoditiesModel * model = [YWHomeCommoditiesModel yy_modelWithDictionary:dataArr[i]];
            [self.dataArr addObject:model];
        }
        [self.tableView reloadData];
    } failur:^(id responsObj, NSError *error) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code error is %@",responsObj);
    }];
}
- (void)requestDelWithID:(NSString *)commoditiesID withIndexPath:(NSIndexPath *)indexPath{
    YWHomeCommoditiesModel * model = self.dataArr[indexPath.row];
    
    NSDictionary * pragram = @{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"goods_id":@([model.commoditiesID integerValue])};
    
    [[HttpObject manager]postDataWithType:YuWaType_Shoper_ShopAdmin_DelGoods withPragram:pragram success:^(id responsObj) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code is %@",responsObj);
        [self.dataArr removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [self.tableView reloadData];
    } failur:^(id responsObj, NSError *error) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code error is %@",responsObj);
    }];
}

@end

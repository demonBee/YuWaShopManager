//
//  YWBankViewController.m
//  YuWaShop
//
//  Created by Tian Wei You on 16/11/23.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWBankViewController.h"
#import "YWBankTableViewCell.h"
#import "NSString+JWAppendOtherStr.h"

@interface YWBankViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray * bankArr;

@end

@implementation YWBankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeNavi];
    [self dataSet];
    [self requestData];
}

- (void)dataSet{
    self.nameLabel.attributedText = [NSString stringWithFirstStr:@"如需要修改银行卡信息,请您联系" withFont:[UIFont systemFontOfSize:13.f] withColor:[UIColor blackColor] withSecondtStr:@"责任销售" withFont:[UIFont systemFontOfSize:13.f] withColor:CNaviColor];
    self.bankArr = [NSMutableArray arrayWithCapacity:0];
    [self.tableView registerNib:[UINib nibWithNibName:@"YWBankTableViewCell" bundle:nil] forCellReuseIdentifier:@"YWBankTableViewCell"];
}

- (void)makeNavi{
    self.title = @"银行卡管理";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barItemWithImageName:nil withSelectImage:nil withHorizontalAlignment:UIControlContentHorizontalAlignmentCenter withTittle:@"添加银行卡" withTittleColor:[UIColor whiteColor] withTarget:self action:@selector(addBankAction) forControlEvents:UIControlEventTouchUpInside withWidth:90.f];
}

- (void)addBankAction{
    [self showHUDWithStr:@"敬请期待" withSuccess:NO];
    //2333333333333添加银行卡
    //23333333333333删
//    YWBankModel * model = [[YWBankModel alloc]init];
//    model.bankID = @"1";
//    [self.bankArr addObject:model];
//    [self.tableView reloadData];
    //2333333333333删
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 73.f;
}
- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle ==UITableViewCellEditingStyleDelete){
        UIAlertAction * OKAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            YWBankModel * model = self.bankArr[indexPath.row];
            [self requestDelBankWithID:model.bankID withIndexPath:indexPath];
            }];
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
        UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认删除银行卡?" preferredStyle:UIAlertControllerStyleAlert];
        [alertVC addAction:cancelAction];
        [alertVC addAction:OKAction];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertVC animated:YES completion:nil];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.bankArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YWBankTableViewCell * bankCell = [tableView dequeueReusableCellWithIdentifier:@"YWBankTableViewCell"];
    bankCell.model = self.bankArr[indexPath.row];
    return bankCell;
}

#pragma mark - Http
- (void)requestData{
    //h33333333333银行信息
    
    //23333333333删
//    YWBankModel * model = [[YWBankModel alloc]init];
//    model.bankID = @"1";
//    [self.bankArr addObject:model];
    //23333333333删
//    [self.tableView reloadData];
}

- (void)requestDelBankWithID:(NSString *)bankID withIndexPath:(NSIndexPath *)indexPath{
    //h3333333333删除银行卡
    [self.bankArr removeObjectAtIndex:indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
}

@end

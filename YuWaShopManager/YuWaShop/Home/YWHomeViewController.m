//
//  YWHomeViewController.m
//  YuWaShop
//
//  Created by Tian Wei You on 16/11/17.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWHomeViewController.h"
#import "YWFinancialViewController.h"   //财务管理
#import "ShowMoreCommitViewController.h"   //口碑管理
#import "StorePhotoViewController.h"      //相册管理
#import "YWHomeNoticaficationViewController.h"
#import "YWHomeQuickPayListVC.h"
#import "YWHomePayBillViewController.h"

#import "YWPersonShopViewController.h"
#import "YWHomeCommoditiesVC.h"
#import "YWHomeRefundVC.h"
#import "YWHomeFestivalViewController.h"
#import "YWHomeCompareViewController.h"
#import "YWHomeCouponViewController.h"
#import "YWHomeAdvanceOrderViewController.h"

#import "YWHomeCollectionViewCell.h"
#import "YWHomeCollectionHeaderView.h"


@interface YWHomeViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong)NSArray * nameArr;
@property (nonatomic,strong)NSArray * imgNameArr;
@property (nonatomic,strong)NSArray * subVCArr;

@property (nonatomic,strong)UIBarButtonItem * rightBarBtn;

@end

@implementation YWHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeNavi];
    [self dataSet];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:0.f];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [self isNewNotification:[UserSession instance].isNewNoticafication];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:1.f];
}

- (void)makeNavi{
    self.title = @"首页";
    self.rightBarBtn = [UIBarButtonItem barItemWithImageName:@"MessageNoChatWhite" withSelectImage:@"MessageNoChatWhite" withHorizontalAlignment:UIControlContentHorizontalAlignmentCenter withTarget:self action:@selector(messageAction) forControlEvents:UIControlEventTouchUpInside withWidth:30.f];
    CGFloat redWidth = 8.f;
    UILabel * redLabel = [[UILabel alloc]initWithFrame:CGRectMake(20.f, 5.f, redWidth, redWidth)];
    redLabel.backgroundColor = [UIColor redColor];
    redLabel.layer.cornerRadius = redWidth/2;
    redLabel.layer.masksToBounds = YES;
    redLabel.tag = 1001;
    redLabel.hidden = YES;
    [self.rightBarBtn.customView addSubview:redLabel];
    self.navigationItem.rightBarButtonItem = self.rightBarBtn;
}

- (void)isNewNotification:(BOOL)isNew{
    UILabel * redLabel = (UILabel *)[self.rightBarBtn.customView viewWithTag:1001];
    redLabel.hidden = !isNew;
}

- (void)dataSet{
    self.nameArr = @[@"财务管理",@"商品管理",@"现金券",@"口碑品牌",@"退款管理",@"预定管理",@"节日管理",@"相册管理",@"同业排行"];
    self.imgNameArr = @[@"Home_IMG0",@"Home_IMG1",@"Home_IMG2",@"Home_IMG3",@"Home_IMG4",@"Home_IMG5",@"Home_IMG6",@"Home_IMG7",@"Home_IMG8"];
    self.subVCArr = @[[YWFinancialViewController class],[YWHomeCommoditiesVC class],[YWHomeCouponViewController class],[ShowMoreCommitViewController class],[YWHomeRefundVC class],[YWHomeAdvanceOrderViewController class],[YWHomeFestivalViewController class],[StorePhotoViewController class],[YWHomeCompareViewController class]];
    [self.collectionView registerNib:[UINib nibWithNibName:@"YWHomeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"YWHomeCollectionViewCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"YWHomeCollectionHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"YWHomeCollectionHeaderView"];
}

- (void)messageAction{
    if (![UserSession userToComfired])return;
    YWHomeNoticaficationViewController * vc = [[YWHomeNoticaficationViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UICollectionViewDataSource
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    YWHomeCollectionHeaderView * header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"YWHomeCollectionHeaderView" forIndexPath:indexPath];
    WEAKSELF;
    header.payBlock = ^(){
        if ([UserSession userToComfired]){
            YWHomePayBillViewController * vc = [[YWHomePayBillViewController alloc]init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
        }
    };
    header.recordBlock = ^(){
        if ([UserSession userToComfired]){
            YWHomeQuickPayListVC * vc = [[YWHomeQuickPayListVC alloc]init];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
    };
    return header;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.nameArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    YWHomeCollectionViewCell * homeCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YWHomeCollectionViewCell" forIndexPath:indexPath];
    homeCell.nameLabel.text = self.nameArr[indexPath.row];
    homeCell.showImage.image = [UIImage imageNamed:self.imgNameArr[indexPath.row]];
    return homeCell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (![UserSession userToComfired])return;
    Class viewClass = (Class)self.subVCArr[indexPath.row];
    UIViewController * vc = [[viewClass alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(kScreen_Width/3, ACTUAL_WIDTH(110.f));
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(kScreen_Width, 175.f);
}

@end

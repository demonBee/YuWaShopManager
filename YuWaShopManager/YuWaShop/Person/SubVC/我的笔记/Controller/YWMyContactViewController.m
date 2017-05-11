//
//  YWMyContactViewController.m
//  YuWaShop
//
//  Created by 黄佳峰 on 2016/12/9.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWMyContactViewController.h"
#import "PCBottomTableViewCell.h"

#import "YJSegmentedControl.h"

#import "RBHomeCollectionViewCell.h"
#import "RBCenterAlbumModel.h"

#import "TZImagePickerController.h"
#import "RBNodeShowViewController.h"
#import "YWNodeAddAldumViewController.h"
#import "MyAlbumViewController.h"

#define CELL0   @"PCBottomTableViewCell"
@interface YWMyContactViewController ()<UITableViewDelegate,UITableViewDataSource,YJSegmentedControlDelegate,PCBottomTableViewCellDelegate,TZImagePickerControllerDelegate>

@property(nonatomic,strong)UITableView*tableView;
@property (nonatomic,strong)RBHomeCollectionViewCell * heighCell;   //collectionView 的cell

@property(nonatomic,assign)NSInteger type; //0为笔记   1为专辑
@property(nonatomic,assign)int pagen;
@property(nonatomic,assign)int pages;
@property(nonatomic,strong)NSMutableArray*allDatasModel;

@end

@implementation YWMyContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   self.title=@"我的笔记";
    [self addChooseView];
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:CELL0 bundle:nil] forCellReuseIdentifier:CELL0];
    [self setUpMJRefresh];
     self.heighCell = [[[NSBundle mainBundle]loadNibNamed:@"RBHomeCollectionViewCell" owner:nil options:nil]firstObject];
}


#pragma mark  --make  UI
-(void)addChooseView{
    self.automaticallyAdjustsScrollViewInsets=NO;
    NSArray*titleArray=@[@"笔记",@"专辑"];
    YJSegmentedControl*segment=[YJSegmentedControl segmentedControlFrame:CGRectMake(0, 64, kScreen_Width, 30) titleDataSource:titleArray backgroundColor:[UIColor whiteColor] titleColor:[UIColor grayColor] titleFont:[UIFont systemFontOfSize:14] selectColor:CNaviColor buttonDownColor:CNaviColor Delegate:self];
    [self.view addSubview:segment];
    
}

-(void)setUpMJRefresh{
    self.pagen=10;
    self.pages=0;
    self.allDatasModel=[NSMutableArray array];
    
    self.tableView.mj_header=[UIScrollView scrollRefreshGifHeaderWithImgName:@"newheader" withImageCount:60 withRefreshBlock:^{
        self.pages=0;
        self.allDatasModel=[NSMutableArray array];
        [self getDatas];
        
    }];
    
    //上拉刷新
    self.tableView.mj_footer = [UIScrollView scrollRefreshGifFooterWithImgName:@"newheader" withImageCount:60 withRefreshBlock:^{
        self.pages++;
        [self getDatas];
        
    }];
    
     [self.tableView.mj_header beginRefreshing];
}


#pragma mark  --make tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PCBottomTableViewCell*cell=[[PCBottomTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil andDatas:self.allDatasModel andWhichCategory:self.type];
    cell.delegate=self;
    cell.selectionStyle=NO;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //分所选的区域的
    //        return 1000;
    if (self.type==0) {
   
        NSMutableArray*alldatas=self.allDatasModel;
        __block CGFloat rightRowHeight = 0.f;
        __block CGFloat leftRowHeight = ACTUAL_HEIGHT(170);
        [alldatas enumerateObjectsUsingBlock:^(RBHomeModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
            if (model.cellHeight < 10.f){
                self.heighCell.model = model;
                model.cellHeight = self.heighCell.cellHeight;
            }
            if (rightRowHeight<leftRowHeight) {
                rightRowHeight += model.cellHeight + 10.f;
            }else{
                leftRowHeight += model.cellHeight + 10.f;
            }
        }];
        
        return rightRowHeight>leftRowHeight?rightRowHeight:leftRowHeight;
        
        //            return 1000;
        
    }else{
      
        NSMutableArray*alldatas=self.allDatasModel;
        CGFloat height = 180.f - 55.25f + (kScreen_Width - 20.f - 75.f)/4;
        return (height+10)*(alldatas.count+1);
        
        
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark  --delegate
-(void)segumentSelectionChange:(NSInteger)selection{
    MyLog(@"%ld",(long)selection);
    self.type=selection;
    [self.tableView.mj_header beginRefreshing];
    
}


//笔记界面的点击方法   -1 为发布笔记
-(void)DelegateForNote:(NSInteger)number{
    if (number==-1) {
        //发布笔记
        TZImagePickerController *imagePickerVC = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
        imagePickerVC.allowPickingVideo = NO;
        [imagePickerVC setDidFinishPickingPhotosHandle:^(NSArray * photos , NSArray * assets,BOOL isSelectOriginalPhoto){
            
        }];
        
        [self presentViewController:imagePickerVC animated:YES completion:nil];
        
        
    }else{
        
        RBNodeShowViewController * vc = [[RBNodeShowViewController alloc]init];
        vc.model = self.allDatasModel[number];
        [self.navigationController pushViewController:vc animated:NO];
        
        
        
        
    }
    
}


-(void)DelegateForAlbum:(NSInteger)number andMax:(NSInteger)maxNumber{
    if (number==maxNumber) {
        //专辑
        MyLog(@"创建专辑");
        YWNodeAddAldumViewController*vc=[[YWNodeAddAldumViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        MyLog(@"点击某个专辑%lu",(long)number);
        MyAlbumViewController*vc=[[MyAlbumViewController alloc]init];
        RBCenterAlbumModel * model = self.allDatasModel[number];
        vc.albumDetail = model.aldumID;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
    
}


#pragma mark  -- Datas
-(void)getDatas{
    switch (self.type) {
        case 0:{
            [self getNotesDatas];
            break;}
        case 1:{
            [self getAlbumDatas];
            break;}
    
        default:
            break;
    }
    
}


-(void)getNotesDatas{
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_GETNOTES];
    NSString*pagen=[NSString stringWithFormat:@"%d",self.pagen];
    NSString*pages=[NSString stringWithFormat:@"%d",self.pages];
    NSDictionary*params=@{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"pagen":pagen,@"pages":pages};
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDatasNoHudWithUrl:urlStr withParams:params compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        NSNumber*number=data[@"errorCode"];
        NSString*errorCode=[NSString stringWithFormat:@"%@",number];
        if ([errorCode isEqualToString:@"0"]) {
            for (NSDictionary*dict in data[@"data"]) {
                NSMutableDictionary * dataDic = [RBHomeModel dataDicSetWithDic:dict];
                [self.allDatasModel addObject:[RBHomeModel yy_modelWithDictionary:dataDic]];
                
                [UserSession instance].note_nums =data[@"total_nums"];
            }
            
            [self.tableView reloadData];
            
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
        }
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
    }];

    
    
//    [self.tableView reloadData];
//    [self.tableView.mj_header endRefreshing];
//    [self.tableView .mj_footer endRefreshing];
}

-(void)getAlbumDatas{
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_GETALBUMS];
    NSString*pagen=[NSString stringWithFormat:@"%d",self.pagen];
    NSString*pages=[NSString stringWithFormat:@"%d",self.pages];
    NSDictionary*params=@{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"pagen":pagen,@"pages":pages};
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDatasNoHudWithUrl:urlStr withParams:params compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        NSNumber*number=data[@"errorCode"];
        NSString*errorCode=[NSString stringWithFormat:@"%@",number];
        if ([errorCode isEqualToString:@"0"]) {
            for (NSDictionary*dict in data[@"data"]) {
                RBCenterAlbumModel*model=[RBCenterAlbumModel yy_modelWithDictionary:dict];
                model.user = [[RBHomeUserModel alloc]init];
                model.user.nickname = [UserSession instance].nickName;
                model.user.images = [UserSession instance].logo;
                [self.allDatasModel addObject:model];
                
                //有多少内容
                [UserSession instance].album_nums=data[@"total_nums"];
            }
            [self.tableView reloadData];
            
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
        }
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
    }];

    
    
//    [self.tableView reloadData];
//    [self.tableView.mj_header endRefreshing];
//    [self.tableView .mj_footer endRefreshing];

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
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64+30, kScreen_Width, kScreen_Height-64-30) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

@end

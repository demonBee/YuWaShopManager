//
//  YWHomeAddCommoditiesVC.m
//  YuWaShop
//
//  Created by Tian Wei You on 16/11/29.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWHomeAddCommoditiesVC.h"

@interface YWHomeAddCommoditiesVC ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *introTextField;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (weak, nonatomic) IBOutlet UIButton *imageBtn;
@property (weak, nonatomic) IBOutlet UIImageView *shopImage;

@property (nonatomic,copy)NSString * cameraImageStr;

@end

@implementation YWHomeAddCommoditiesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加商品信息";
    [self makeUI];
}

- (void)makeUI{
    self.submitBtn.layer.cornerRadius = 5.f;
    self.submitBtn.layer.masksToBounds = YES;
}

- (IBAction)submitBtnAction:(id)sender {
    [self requestChangeIcon];
}

- (IBAction)imageBtnAction:(id)sender {
    [self makeLocalImagePicker];
}
- (void)makeLocalImagePicker{
    WEAKSELF;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [weakSelf myImagePickerWithType:UIImagePickerControllerSourceTypeCamera];
        } else {
            MyLog(@"照片源不可用");
        }
    }]];

    [alertController addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf myImagePickerWithType:UIImagePickerControllerSourceTypePhotoLibrary];

    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)myImagePickerWithType:(UIImagePickerControllerSourceType)sourceType{
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        [picker setSourceType:sourceType];
        [picker setAllowsEditing:YES];
        [picker setDelegate:self];
        [self presentViewController:picker animated:YES completion:nil];
    } else {
        MyLog(@"照片源不可用");
    }
}

#pragma mark - ImagePickerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    self.shopImage.image = info[@"UIImagePickerControllerEditedImage"];
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Http
- (void)requestChangeIcon{
    if ([self.nameTextField.text isEqualToString:@""]) {
        [self showHUDWithStr:@"请输入商品名称哟~" withSuccess:NO];
        return;
    }else if ([self.introTextField.text isEqualToString:@""]) {
        [self showHUDWithStr:@"请输入商品介绍哟~" withSuccess:NO];
        return;
    }else if ([self.priceTextField.text isEqualToString:@""]||[self.priceTextField.text floatValue]<=0.f) {
        self.priceTextField.text = @"";
        [self showHUDWithStr:@"请输入正确的商品价格哟~" withSuccess:NO];
        return;
    }
    
    if (!self.shopImage.image) {
        [self showHUDWithStr:@"请添加商品相片哟~" withSuccess:NO];
        return;
    }
    
    self.priceTextField.text = [NSString stringWithFormat:@"%.2f",[self.priceTextField.text floatValue]];
    
    NSDictionary * pragram = @{@"img":@"img"};
    
    [[HttpObject manager]postPhotoWithType:YuWaType_IMG_UP withPragram:pragram success:^(id responsObj) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code is %@",responsObj);
        self.cameraImageStr = responsObj[@"data"];
        if (!self.cameraImageStr)self.cameraImageStr=@"";
        [self requestUpData];;
    } failur:^(id errorData, NSError *error) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code error is %@",error);
    } withPhoto:UIImagePNGRepresentation(self.shopImage.image)];
}
- (void)requestUpData{
    NSDictionary * pragram = @{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"goods_name":self.nameTextField.text,@"goods_info":self.introTextField.text,@"goods_price":@([self.priceTextField.text floatValue]),@"goods_img":self.cameraImageStr};
    
    [[HttpObject manager]postDataWithType:YuWaType_Shoper_ShopAdmin_AddGoods withPragram:pragram success:^(id responsObj) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code is %@",responsObj);
        [self showHUDWithStr:@"恭喜!添加成功" withSuccess:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    } failur:^(id responsObj, NSError *error) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code error is %@",responsObj);
    }];
}

@end

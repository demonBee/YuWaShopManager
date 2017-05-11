//
//  YWLoginViewController.m
//  YuWa
//
//  Created by Tian Wei You on 16/9/19.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWLoginViewController.h"
#import "YWRegisterViewController.h"
#import "YWForgetPassWordViewController.h"
#import "YJSegmentedControl.h"
#import "JPUSHService.h"
#import "VIPTabBarController.h"

@interface YWLoginViewController ()<UITextFieldDelegate,YJSegmentedControlDelegate>

@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordtextField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *hiddenPasswordBtn;

@property (nonatomic,strong)YJSegmentedControl * segmentControl;
@property (nonatomic,assign)BOOL isHiddenPassword;

@property (weak, nonatomic) IBOutlet UIView *quickLoginView;
@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;
@property (weak, nonatomic) IBOutlet UITextField *secuirtyCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *secuirtyCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *quickLoginBtn;
@property (nonatomic,strong)NSTimer * timer;
@property (nonatomic,assign)NSInteger time;
@property (nonatomic,assign)NSInteger state;

@end

@implementation YWLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeNavi];
    [self makeUI];
    self.time = 60;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.state == 0) {
        [self.accountTextField becomeFirstResponder];
    }else{
        [self.mobileTextField becomeFirstResponder];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.timer.isValid) {
        [self.timer invalidate];
    }
    self.timer=nil;
}

- (void)makeNavi{
    self.title = @"登录";
    
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(registerAction)];
}

- (void)makeUI{
    self.passwordtextField.secureTextEntry = YES;
    
    self.loginBtn.layer.cornerRadius = 5.f;
    self.loginBtn.layer.masksToBounds = YES;
    self.quickLoginBtn.layer.cornerRadius = 5.f;
    self.quickLoginBtn.layer.masksToBounds = YES;
    self.secuirtyCodeBtn.layer.cornerRadius = 3.f;
    self.secuirtyCodeBtn.layer.masksToBounds = YES;
    
    self.segmentControl = [YJSegmentedControl segmentedControlFrame:CGRectMake(0.f, NavigationHeight, kScreen_Width, 40.f) titleDataSource:@[@"账号密码登录",@"手机号快捷登录"] backgroundColor:[UIColor whiteColor] titleColor:CtitleColor titleFont:[UIFont systemFontOfSize:15.f] selectColor:CNaviColor buttonDownColor:CNaviColor Delegate:self];
    [self.view addSubview:self.segmentControl];
}

#pragma mark - ButtonAction
- (void)registerAction{
    YWRegisterViewController * vc = [[YWRegisterViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)backBarAction{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)hiddenPasswordBtnAction:(id)sender {
    self.passwordtextField.secureTextEntry = self.isHiddenPassword;
    [self.hiddenPasswordBtn setBackgroundImage:[UIImage imageNamed:self.isHiddenPassword == NO?@"showPassword":@"hiddenPassword"] forState:UIControlStateNormal];
    self.isHiddenPassword = !self.isHiddenPassword;
}

- (IBAction)loginBtnAction:(id)sender {
    if ([self canSendRequset]) {
        [self requestLoginWithAccount:self.accountTextField.text withPassword:self.passwordtextField.text];
    }
}

- (IBAction)forgetPasswordBtnAction:(id)sender {
    YWForgetPassWordViewController * vc = [[YWForgetPassWordViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (BOOL)canSendRequset{
    if (![JWTools checkTelNumber:self.accountTextField.text]) {
        [self showHUDWithStr:@"请输入11位手机号" withSuccess:NO];
        return NO;
    }else if (![JWTools isRightPassWordWithStr:self.passwordtextField.text]){
        [self showHUDWithStr:@"请输入6-16位密码" withSuccess:NO];
        return NO;
    }
    return YES;
}

- (IBAction)secuirtyCodeBtnAction:(id)sender {
    if (![JWTools checkTelNumber:self.mobileTextField.text]) {
        [self showHUDWithStr:@"请输入11位手机号" withSuccess:NO];
        return ;
    }
    [self requestQuickLoginCode];
}
- (IBAction)quickLoginBtnAction:(id)sender {
    if ([self canQuickSendRequset]) {
        [self requestLoginWithMobile:self.mobileTextField.text withSecuirtyCode:self.secuirtyCodeTextField.text];
    }
}
- (BOOL)canQuickSendRequset{
    if (![JWTools checkTelNumber:self.mobileTextField.text]) {
        [self showHUDWithStr:@"请输入11位手机号" withSuccess:NO];
        return NO;
    }else if ([self.secuirtyCodeTextField.text isEqualToString:@""]){
        [self showHUDWithStr:@"请输入验证码" withSuccess:NO];
        return NO;
    }
    return YES;
}

- (void)securityCodeBtnTextSet{//重置文字
    if (self.time <= 0) {
        [self.timer invalidate];
        self.timer = nil;
        self.time = 60;
        [self.secuirtyCodeBtn setTitle:[NSString stringWithFormat:@"重获验证码"] forState:UIControlStateNormal];
        self.secuirtyCodeBtn.backgroundColor = CNaviColor;
        [self.secuirtyCodeBtn setUserInteractionEnabled:YES];
        return;
    }
    [self.secuirtyCodeBtn setTitle:[NSString stringWithFormat:@"获取中(%zi)s",self.time] forState:UIControlStateNormal];
    self.time--;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.tag == 1) {//passwordTextField
        if ([self canSendRequset]) {
            [textField resignFirstResponder];
            [self requestLoginWithAccount:self.accountTextField.text withPassword:self.passwordtextField.text];
        }
    }else{//secuirtyCodeTextField
        if ([self canQuickSendRequset]) {
            [textField resignFirstResponder];
            [self requestLoginWithMobile:self.mobileTextField.text withSecuirtyCode:self.secuirtyCodeTextField.text];
        }
    }
    return YES;
}

#pragma mark - YJSegmentedControlDelegate
- (void)segumentSelectionChange:(NSInteger)selection{
    self.state = selection;
    self.quickLoginView.hidden = selection==0?YES:NO;
    if (selection == 0) {
        [self.accountTextField becomeFirstResponder];
    }else{
        [self.mobileTextField becomeFirstResponder];
    }
}

#pragma mark - Http
- (void)requestLoginWithAccount:(NSString *)account withPassword:(NSString *)password{
    NSDictionary * pragram = @{@"phone":account,@"password":password};
    [[HttpObject manager]postDataWithType:YuWaType_Logion withPragram:pragram success:^(id responsObj) {
        MyLog(@"Pragram is %@",pragram);
        MyLog(@"Data is %@",responsObj);
        [UserSession saveUserLoginWithAccount:account withPassword:password];
        [UserSession saveUserInfoWithDic:responsObj[@"data"]];
        [self showHUDWithStr:@"登录成功" withSuccess:YES];
        EMError *errorLog = [[EMClient sharedClient] loginWithUsername:[NSString stringWithFormat:@"2%@",account] password:[UserSession instance].hxPassword];
        if (!errorLog){
            [[EMClient sharedClient].options setIsAutoLogin:NO];
            MyLog(@"环信登录成功");
        }else{
            EMError *error = [[EMClient sharedClient] registerWithUsername:[NSString stringWithFormat:@"2%@",account] password:account];
            if (error==nil) {
                MyLog(@"环信注册成功");
                BOOL isAutoLogin = [EMClient sharedClient].options.isAutoLogin;
                if (!isAutoLogin) {
                    EMError *errorLog = [[EMClient sharedClient] loginWithUsername:[NSString stringWithFormat:@"2%@",account] password:[NSString stringWithFormat:@"2%@",account]];
                    if (errorLog==nil){
                        [[EMClient sharedClient].options setIsAutoLogin:YES];
                        MyLog(@"环信登录成功");
                    }
                }
            }
        }
        
        if ([UserSession instance].comfired_Status == 2||[UserSession instance].isVIP == 3){
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [JPUSHService setAlias:[UserSession instance].account callbackSelector:nil object:nil];
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
        }else{
            [self.navigationController popToRootViewControllerAnimated:YES];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                VIPTabBarController * rootTabBarVC = (VIPTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
                rootTabBarVC.selectedIndex = 0;
                rootTabBarVC.hidesBottomBarWhenPushed = NO;

            });
        }
    } failur:^(id responsObj, NSError *error) {
        MyLog(@"Pragram is %@",pragram);
        MyLog(@"Data Error error is %@",responsObj);
        MyLog(@"Error is %@",error);
    }];
}

- (void)requestLoginWithMobile:(NSString *)account withSecuirtyCode:(NSString *)secuirty{
    
    NSDictionary * pragram = @{@"phone":account,@"code":secuirty};
    [[HttpObject manager]postDataWithType:YuWaType_Logion_Quick withPragram:pragram success:^(id responsObj) {
        MyLog(@"Pragram is %@",pragram);
        MyLog(@"Data is %@",responsObj);
        
        [UserSession saveUserInfoWithDic:responsObj[@"data"]];
        [self showHUDWithStr:@"登录成功" withSuccess:YES];
        
        [UserSession saveUserLoginWithAccount:account withPassword:[UserSession instance].password];
        EMError *errorLog = [[EMClient sharedClient] loginWithUsername:[NSString stringWithFormat:@"2%@",account] password:[UserSession instance].hxPassword];
        if (!errorLog){
            [[EMClient sharedClient].options setIsAutoLogin:NO];
            MyLog(@"环信登录成功");
        }else{
            EMError *error = [[EMClient sharedClient] registerWithUsername:[NSString stringWithFormat:@"2%@",account] password:account];
            if (error==nil) {
                MyLog(@"环信注册成功");
                BOOL isAutoLogin = [EMClient sharedClient].options.isAutoLogin;
                if (!isAutoLogin) {
                    EMError *errorLog = [[EMClient sharedClient] loginWithUsername:[NSString stringWithFormat:@"2%@",account] password:[NSString stringWithFormat:@"2%@",account]];
                    if (errorLog==nil){
                        [[EMClient sharedClient].options setIsAutoLogin:YES];
                        MyLog(@"环信登录成功");
                    }
                }
            }
        }
        
        if ([UserSession instance].comfired_Status == 2||[UserSession instance].isVIP == 3){
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [JPUSHService setAlias:[UserSession instance].account callbackSelector:nil object:nil];
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else{
            [self.navigationController popViewControllerAnimated:YES];
            VIPTabBarController * rootTabBarVC = (VIPTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            rootTabBarVC.selectedIndex = 0;
            rootTabBarVC.hidesBottomBarWhenPushed = NO;
        }
    } failur:^(id responsObj, NSError *error) {
        MyLog(@"Pragram is %@",pragram);
        MyLog(@"Data Error error is %@",responsObj);
        MyLog(@"Error is %@",error);
        [self showHUDWithStr:responsObj[@"errorMessage"] withSuccess:NO];
        self.time = 0;//失败后重置验证码
        [self securityCodeBtnTextSet];
    }];
}

- (void)requestQuickLoginCode{
    NSDictionary * pragram = @{@"phone":self.mobileTextField.text,@"tpl_id":@22073};
    
    [[HttpObject manager]postNoHudWithType:YuWaType_Logion_Code withPragram:pragram success:^(id responsObj) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code is %@",responsObj);
        [self.secuirtyCodeBtn setUserInteractionEnabled:NO];
        self.secuirtyCodeBtn.backgroundColor = CNaviColor;
        [self securityCodeBtnTextSet];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(securityCodeBtnTextSet) userInfo:nil repeats:YES];
    } failur:^(id responsObj, NSError *error) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code error is %@",responsObj);
    }];
}

@end

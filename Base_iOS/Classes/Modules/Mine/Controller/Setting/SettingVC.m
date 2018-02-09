//
//  SettingVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/12/14.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "SettingVC.h"

#import "AppMacro.h"
#import "APICodeMacro.h"

#import "TLAlert.h"
#import "NSString+Check.h"
//M
#import "SettingGroup.h"
#import "SettingModel.h"
//V
#import "SettingTableView.h"
#import "SettingCell.h"
//C
#import "TLChangeMobileVC.h"
#import "TLPwdRelatedVC.h"
#import "NavigationController.h"
#import "TLUserLoginVC.h"

@interface SettingVC ()

@property (nonatomic, strong) SettingGroup *group;

@property (nonatomic, strong) UIButton *loginOutBtn;

@property (nonatomic, strong) SettingTableView *tableView;

@end

@implementation SettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"个人设置";
    
    [self setGroup];
    
    [self initTableView];
}

#pragma mark - Init

- (void)initTableView {
    
    self.tableView = [[SettingTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight) style:UITableViewStyleGrouped];
    
    self.tableView.group = self.group;
    
    [self.view addSubview:self.tableView];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 150)];
    
    [footerView addSubview:self.loginOutBtn];
    
    self.tableView.tableFooterView = footerView;
    
    
}

- (void)setGroup {
    
    BaseWeakSelf;
    
    //修改手机号
    SettingModel *changeMobile = [SettingModel new];
    changeMobile.text = @"修改手机号";
    [changeMobile setAction:^{
        
        TLChangeMobileVC *changeMobileVC = [[TLChangeMobileVC alloc] init];
        
        [weakSelf.navigationController pushViewController:changeMobileVC animated:YES];
        
    }];
    
    //修改登录密码
    SettingModel *changeLoginPwd = [SettingModel new];
    changeLoginPwd.text = @"修改登录密码";
    [changeLoginPwd setAction:^{
        
        TLPwdRelatedVC *pwdRelatedVC = [[TLPwdRelatedVC alloc] initWithType:TLPwdTypeReset];
        
        pwdRelatedVC.success = ^{
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [weakSelf.navigationController popViewControllerAnimated:YES];
                
            });
        };
        
        [weakSelf.navigationController pushViewController:pwdRelatedVC animated:YES];
        
    }];
    
    self.group = [SettingGroup new];
    
    self.group.sections = @[@[changeMobile, changeLoginPwd]];
    
}

#pragma mark- 退出登录

- (UIButton *)loginOutBtn {
    
    if (!_loginOutBtn) {
        
        _loginOutBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 55, kScreenWidth - 30, 45)];
        _loginOutBtn.backgroundColor = kAppCustomMainColor;
        [_loginOutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        [_loginOutBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        _loginOutBtn.layer.cornerRadius = 5;
        _loginOutBtn.clipsToBounds = YES;
        _loginOutBtn.titleLabel.font = FONT(15);
        [_loginOutBtn addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginOutBtn;
    
}

- (void)logout {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.navigationController popViewControllerAnimated:NO];
        
    });
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kUserLoginOutNotification object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

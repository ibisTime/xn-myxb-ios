//
//  MineVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/7.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "MineVC.h"

//Manager
#import "TLUploadManager.h"
//Macro
#import "APICodeMacro.h"
//Framework
//Category
#import "NSString+Extension.h"
//Extension
#import <UIImageView+WebCache.h>
#import "TLProgressHUD.h"
//M
#import "MineGroup.h"
//V
#import "MineTableView.h"
#import "MineHeaderView.h"
#import "TLImagePicker.h"
//C
#import "SettingVC.h"
#import "IntegralMallVC.h"

@interface MineVC ()<MineHeaderSeletedDelegate>
//模型
@property (nonatomic, strong) MineGroup *group;
//
@property (nonatomic, strong) MineTableView *tableView;
//头部
@property (nonatomic, strong) MineHeaderView *headerView;
//选择头像
@property (nonatomic, strong) TLImagePicker *imagePicker;

@end

@implementation MineVC

#pragma mark - Life Cycle

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的";
    
    //模型
    if ([[TLUser user].kind isEqualToString:@"C"]) {
        //美容院
        [self initSclonGroup];
    } else {
        
        [self initGroup];
    }
    //通知
    [self addNotification];
    //
    [self initTableView];
    //
    [self changeInfo];

}

#pragma mark - Init

- (void)initSclonGroup {
    
    BaseWeakSelf;
    
    //积分余额
    MineModel *jfBalance = [MineModel new];
    
    jfBalance.text = @"积分余额";
    jfBalance.imgName = @"积分余额";
    jfBalance.action = ^{
        
        IntegralMallVC *integralMallVC = [IntegralMallVC new];
        
        [weakSelf.navigationController pushViewController:integralMallVC animated:YES];
    };
    
    //行程列表
    MineModel *travelList = [MineModel new];
    
    travelList.text = @"行程列表";
    travelList.imgName = @"行程列表";
    travelList.action = ^{
        
    };
    
    //成果订单
    MineModel *order = [MineModel new];
    
    order.text = @"成果订单";
    order.imgName = @"成果订单";
    order.action = ^{
        
    };
    
    //我的资料
    MineModel *information = [MineModel new];
    
    information.text = @"我的资料";
    information.imgName = @"我的资料";
    information.action = ^{
        
    };
    
    //我的排名
    MineModel *ranking = [MineModel new];
    
    ranking.text = @"我的排名";
    ranking.imgName = @"我的排名";
    ranking.action = ^{
        
    };
    
    //帮助中心
    MineModel *helpCenter = [MineModel new];
    
    helpCenter.text = @"帮助中心";
    helpCenter.imgName = @"帮助中心";
    helpCenter.action = ^{
        
    };
    
    self.group = [MineGroup new];
    
    self.group.sections = @[@[jfBalance, travelList, order, information], @[ranking], @[helpCenter]];
}

- (void)initGroup {
    
    BaseWeakSelf;
    
    //积分余额
    MineModel *jfBalance = [MineModel new];
    
    jfBalance.text = @"积分余额";
    jfBalance.imgName = @"积分余额";
    jfBalance.action = ^{
        
        IntegralMallVC *integralMallVC = [IntegralMallVC new];
        
        [weakSelf.navigationController pushViewController:integralMallVC animated:YES];
    };
    
    //行程列表
    MineModel *travelList = [MineModel new];
    
    travelList.text = @"行程列表";
    travelList.imgName = @"行程列表";
    travelList.action = ^{
        
    };
    
    //成果订单
    MineModel *order = [MineModel new];
    
    order.text = @"成果订单";
    order.imgName = @"成果订单";
    order.action = ^{
        
    };
    
    //我的资料
    MineModel *information = [MineModel new];
    
    information.text = @"我的资料";
    information.imgName = @"我的资料";
    information.action = ^{
        
    };
    
    //我的排名
    MineModel *ranking = [MineModel new];
    
    ranking.text = @"我的排名";
    ranking.imgName = @"我的排名";
    ranking.action = ^{
        
    };
    
    //帮助中心
    MineModel *helpCenter = [MineModel new];
    
    helpCenter.text = @"帮助中心";
    helpCenter.imgName = @"帮助中心";
    helpCenter.action = ^{
        
    };
    
    self.group = [MineGroup new];
    
    self.group.sections = @[@[jfBalance, travelList, order, information], @[ranking], @[helpCenter]];
    
}

- (void)initTableView {
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 110 + kNavigationBarHeight)];
    
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.image = kImage(@"我的-背景");
    
    imageView.tag = 1500;
    
    [self.view addSubview:imageView];
    
    self.tableView = [[MineTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kTabBarHeight) style:UITableViewStyleGrouped];
    
    self.tableView.mineGroup = self.group;
    
    [self.view addSubview:self.tableView];
    
    //tableview的header
    self.headerView = [[MineHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 110 + kNavigationBarHeight)];
    
    self.headerView.delegate = self;
    
    self.tableView.tableHeaderView = self.headerView;
    
}

- (TLImagePicker *)imagePicker {
    
    if (!_imagePicker) {
        
        BaseWeakSelf;
        
        _imagePicker = [[TLImagePicker alloc] initWithVC:self];
        
        _imagePicker.allowsEditing = NO;
        _imagePicker.clipHeight = kScreenWidth;
        
        _imagePicker.pickFinish = ^(UIImage *photo, NSDictionary *info){
            
            UIImage *image = info == nil ? photo: info[@"UIImagePickerControllerOriginalImage"];
            
            NSData *imgData = UIImageJPEGRepresentation(image, 0.1);
            
            //进行上传
            [TLProgressHUD show];
            
            TLUploadManager *manager = [TLUploadManager manager];
            
            manager.imgData = imgData;
            manager.image = image;
            
            [manager getTokenShowView:weakSelf.view succes:^(NSString *key) {
                
                [weakSelf changeHeadIconWithKey:key imgData:imgData];
                
            } failure:^(NSError *error) {
                
            }];
        };
    }
    
    return _imagePicker;
}

#pragma mark - Notification
- (void)addNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeInfo) name:kUserInfoChange object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginOut) name:kUserLoginOutNotification object:nil];
}

#pragma mark - Events
- (void)changeInfo {
    //
    [self.headerView.userPhoto sd_setImageWithURL:[NSURL URLWithString:[[TLUser user].photo convertImageUrl]] placeholderImage:USER_PLACEHOLDER_SMALL];
    
//    self.headerView.nameLbl.text = [TLUser user].mobile;
    self.headerView.nameLbl.text = @"CzyGod";
    self.headerView.genderIV.image = kImage(@"男");
    self.headerView.infoLbl.text = @"专家 · 养生";
}

- (void)loginOut {
    
    self.headerView.nameLbl.text = @"";
    
    self.headerView.userPhoto.image = USER_PLACEHOLDER_SMALL;
}

#pragma mark - Data
- (void)changeHeadIconWithKey:(NSString *)key imgData:(NSData *)imgData {
    
    TLNetworking *http = [TLNetworking new];
    
    //    http.showView = self.view;
    http.code = USER_CHANGE_USER_PHOTO;
    http.parameters[@"userId"] = [TLUser user].userId;
    http.parameters[@"photo"] = key;
    http.parameters[@"token"] = [TLUser user].token;
    [http postWithSuccess:^(id responseObject) {
        
        [TLProgressHUD dismiss];
        
        [TLAlert alertWithSucces:@"修改头像成功"];
        
        [TLUser user].photo = key;
        //替换头像
        [self.headerView.userPhoto sd_setImageWithURL:[NSURL URLWithString:[key convertImageUrl]] placeholderImage:USER_PLACEHOLDER_SMALL];
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - MineHeaderSeletedDelegate

- (void)didSelectedWithType:(MineHeaderSeletedType)type idx:(NSInteger)idx {
    
    switch (type) {
        case MineHeaderSeletedTypeDefault:
        {
            SettingVC *settingVC = [SettingVC new];

            [self.navigationController pushViewController:settingVC animated:YES];
            
        }break;
            
        case MineHeaderSeletedTypeSelectPhoto:
        {
            [self.imagePicker picker];
            
        }break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

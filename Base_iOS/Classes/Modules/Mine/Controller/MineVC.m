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
#import "AppMacro.h"
//Category
#import "NSString+Extension.h"
//Extension
#import <UIImageView+WebCache.h>
#import "TLProgressHUD.h"
#import "NSString+Check.h"
#import "UIControl+Block.h"
//M
#import "MineGroup.h"
//V
#import "MineTableView.h"
#import "MineHeaderView.h"
#import "TLImagePicker.h"
//C
#import "SettingVC.h"
#import "IntegralMallVC.h"
#import "HTMLStrVC.h"
//专家
#import "TripListVC.h"
#import "MyRankVC.h"
#import "MyInfomationVC.h"
#import "AchievementOrderVC.h"
//美容院
#import "BrandOrderVC.h"
#import "AppointmentOrderVC.h"
#import "MyCommentVC.h"

#import "MyViewController.h"
#import "IntregalFlowVC.h"
#import "WithdrawalVC.h"

//网络图谱
#import "TreeMaoVC.h"

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
    
    //模型
    if ([[TLUser user].kind isEqualToString:kUserTypeSalon]) {
        ///经销商
        [self initSclonGroup];
    }
    else if ([[TLUser user].kind isEqualToString:kUserTypeBeautyGuide])
    {
        //服务团队
        [self initServiceTeam];
        
    }
    else if ([[TLUser user].kind isEqualToString:kUserTypePartner/*kUserTypeLecturer*/])
    {
        //合伙人
        [self initGroup];
    }
    else {
        
        
        //销售精英
        [self salesOfTheElite];
    }
    
    self.tableView.mineGroup = self.group;

    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的";
    
    //通知
    [self addNotification];
    //
    [self initTableView];
    //
    [self changeInfo];
    [[TLUser user] requestAccountNumberWith:@"CNY"];
    [[TLUser user] requestAccountNumberWith:@"JF"];
    
    NSLog(@"---->%@",[TLUser user].kind);

}

#pragma mark - 经销商
- (void)initSclonGroup {
    
    BaseWeakSelf;
    //积分余额
    MineModel *jfBalance = [MineModel new];
    
    if ([[TLUser user].signStatus integerValue] == 0) {
        jfBalance.text = @"我要成为经销商";

    }
    else
    {
        jfBalance.text = @"我的图谱";

    }
    
    jfBalance.imgName = @"积分余额";
    jfBalance.action = ^{
        
        if ([[TLUser user].signStatus integerValue] != 0) {
            TreeMaoVC *treeMap = [TreeMaoVC new];
            
            [weakSelf.navigationController pushViewController:treeMap animated:YES];
        }
        else
        {
            [TLAlert alertWithMsg:@"我要成为经销商"];
        }
    };

    //成果订单
    MineModel *order2 = [MineModel new];
    
    order2.text = @"我的订单";
    order2.imgName = @"成果订单";
    order2.action = ^{
        
        BrandOrderVC *orderVC = [BrandOrderVC new];
        
        [weakSelf.navigationController pushViewController:orderVC animated:YES];
        
//        AchievementOrderVC *orderVC = [AchievementOrderVC new];
//
//        [weakSelf.navigationController pushViewController:orderVC animated:YES];
    };
    //预约
    MineModel *appointmnet = [MineModel new];
    
    appointmnet.text = @"我的预约";
    appointmnet.imgName = @"预约";
    appointmnet.action = ^{
        
        
        
        AppointmentOrderVC *orderVC = [AppointmentOrderVC new];
        
        [weakSelf.navigationController pushViewController:orderVC animated:YES];
    };

    
    self.group = [MineGroup new];
    self.group.sections = @[@[jfBalance],@[order2],@[appointmnet]];
//    AdviserUser *user = [TLUser user].adviserUser;
//
//    //积分余额
//    MineModel *jfBalance = [MineModel new];
//
//    jfBalance.text = @"积分余额";
//    jfBalance.imgName = @"积分余额";
//    jfBalance.action = ^{
//
//        IntegralMallVC *integralMallVC = [IntegralMallVC new];
//
//        [weakSelf.navigationController pushViewController:integralMallVC animated:YES];
//    };
//
//    //品牌订单
//    MineModel *brandOrder = [MineModel new];
//
//    brandOrder.text = @"品牌订单";
//    brandOrder.imgName = @"行程列表";
//    brandOrder.action = ^{
//
//        BrandOrderVC *orderVC = [BrandOrderVC new];
//
//        [weakSelf.navigationController pushViewController:orderVC animated:YES];
//    };
//
//    //预约
//    MineModel *appointmnet = [MineModel new];
//
//    appointmnet.text = @"预约";
//    appointmnet.imgName = @"预约";
//    appointmnet.action = ^{
//
//        AppointmentOrderVC *orderVC = [AppointmentOrderVC new];
//
//        [weakSelf.navigationController pushViewController:orderVC animated:YES];
//    };
//
//    //我的评论
//    MineModel *myComment = [MineModel new];
//
//    myComment.text = @"我的评论";
//    myComment.imgName = @"我的评论";
//    myComment.action = ^{
//
//        MyCommentVC *myCommentVC = [MyCommentVC new];
//
//        [weakSelf.navigationController pushViewController:myCommentVC animated:YES];
//    };
//
//    //团队顾问
//    MineModel *teamAdvisor = [MineModel new];
//
//    teamAdvisor.text = @"团队顾问";
//    teamAdvisor.imgName = @"团队顾问";
//    teamAdvisor.action = ^{
//        //获取团队手机号
//        [weakSelf requestLinkMobile];
//
//    };
//
//    //帮助中心
//    MineModel *helpCenter = [MineModel new];
//
//    helpCenter.text = @"帮助中心";
//    helpCenter.imgName = @"帮助中心";
//    helpCenter.action = ^{
//
//        HTMLStrVC *htmlVC = [[HTMLStrVC alloc] init];
//
//        htmlVC.type = HTMLTypeHelpCenter;
//
//        [weakSelf.navigationController pushViewController:htmlVC animated:YES];
//    };
//
//    self.group = [MineGroup new];
//
//    self.group.sections = @[@[jfBalance, brandOrder, appointmnet, myComment], @[teamAdvisor], @[helpCenter]];
}
#pragma mark - 合伙人
- (void)initGroup {
    
    BaseWeakSelf;
    //网络图谱
    MineModel *netMap = [MineModel new];
    
    netMap.text = @"网络图谱";
    netMap.imgName = @"帮助中心";
    netMap.action = ^{
        
        TreeMaoVC *treeMap = [TreeMaoVC new];
        
        [weakSelf.navigationController pushViewController:treeMap animated:YES];
    };
    
    //团队行程
    MineModel *travelListTeam = [MineModel new];
    
    travelListTeam.text = @"团队行程";
    travelListTeam.imgName = @"我的排名";
    travelListTeam.action = ^{
        

        TripListVC *tripListVC = [TripListVC new];
        
        [weakSelf.navigationController pushViewController:tripListVC animated:YES];
    };
    
    //成果订单
    MineModel *order2 = [MineModel new];
    
    order2.text = @"我的订单";
    order2.imgName = @"成果订单";
    order2.action = ^{
        
        
        BrandOrderVC *orderVC = [BrandOrderVC new];
        
        [weakSelf.navigationController pushViewController:orderVC animated:YES];
//        AchievementOrderVC *orderVC = [AchievementOrderVC new];
//        
//        [weakSelf.navigationController pushViewController:orderVC animated:YES];
    };
    self.group = [MineGroup new];
    
    self.group.sections = @[@[netMap],@[travelListTeam],@[order2]];
    
//    //积分余额
//    MineModel *jfBalance = [MineModel new];
//    
//    jfBalance.text = @"积分余额";
//    jfBalance.imgName = @"积分余额";
//    jfBalance.action = ^{
//        
//        IntegralMallVC *integralMallVC = [IntegralMallVC new];
//        
//        [weakSelf.navigationController pushViewController:integralMallVC animated:YES];
//    };
//    
//    //行程列表
//    MineModel *travelList = [MineModel new];
//    
//    travelList.text = @"行程列表";
//    travelList.imgName = @"行程列表";
//    travelList.action = ^{
//      
//        TripListVC *tripListVC = [TripListVC new];
//        
//        [weakSelf.navigationController pushViewController:tripListVC animated:YES];
//    };
//    
//    //成果订单
//    MineModel *order = [MineModel new];
//    
//    order.text = @"成果订单";
//    order.imgName = @"成果订单";
//    order.action = ^{
//      
//        AchievementOrderVC *orderVC = [AchievementOrderVC new];
//        
//        [weakSelf.navigationController pushViewController:orderVC animated:YES];
//    };
//    
//    //我的资料
//    MineModel *information = [MineModel new];
//    
//    information.text = @"我的资料";
//    information.imgName = @"我的资料";
//    information.action = ^{
//        
//        MyInfomationVC *infoVC = [MyInfomationVC new];
//        
//        [weakSelf.navigationController pushViewController:infoVC animated:YES];
//    };
//    
//    //我的排名
//    MineModel *ranking = [MineModel new];
//    
//    ranking.text = @"我的排名";
//    ranking.imgName = @"我的排名";
//    ranking.action = ^{
//        
//        MyRankVC *rankVC = [MyRankVC new];
//        
//        [weakSelf.navigationController pushViewController:rankVC animated:YES];
//    };
//    
//    //帮助中心
//    MineModel *helpCenter = [MineModel new];
//    
//    helpCenter.text = @"帮助中心";
//    helpCenter.imgName = @"帮助中心";
//    helpCenter.action = ^{
//        
//        HTMLStrVC *htmlVC = [[HTMLStrVC alloc] init];
//        
//        htmlVC.type = HTMLTypeHelpCenter;
//        
//        [weakSelf.navigationController pushViewController:htmlVC animated:YES];
//    };
//    
//    self.group = [MineGroup new];
//    //排行只有专家才有
//    if ([[TLUser user].kind isEqualToString:kUserTypeExpert]) {
//
//        self.group.sections = @[@[jfBalance, travelList, order, information], @[ranking], @[helpCenter]];
//
//    } else {
//
//        self.group.sections = @[@[jfBalance, travelList, order, information], @[helpCenter]];
//    }
    
}

//销售精英
- (void)salesOfTheElite
{
    BaseWeakSelf;
    
    //行程列表
    MineModel *travelList = [MineModel new];
    
    travelList.text = @"我的行程";
    travelList.imgName = @"行程列表";
    travelList.action = ^{
        
        MyViewController *mytripListVC = [MyViewController new];
        
        [weakSelf.navigationController pushViewController:mytripListVC animated:YES];
        
//        TripListVC *tripListVC = [TripListVC new];
//        
//        [weakSelf.navigationController pushViewController:tripListVC animated:YES];
    };
    
    
    //成果订单
    MineModel *order = [MineModel new];
    
    order.text = @"成果查看";
    order.imgName = @"成果订单";
    order.action = ^{
        
        AchievementOrderVC *orderVC = [AchievementOrderVC new];
        
        [weakSelf.navigationController pushViewController:orderVC animated:YES];
    };
    
    
    //我的评论
    MineModel *comments = [MineModel new];
    
    comments.text = @"我的评论";
    comments.imgName = @"我的评论";
    comments.action = ^{
        
        MyCommentVC *myCommentVC = [MyCommentVC new];
        
        [weakSelf.navigationController pushViewController:myCommentVC animated:YES];

    };
    //我的排名
    MineModel *ranking = [MineModel new];
    
    ranking.text = @"我的排名";
    ranking.imgName = @"我的排名";
    ranking.action = ^{
        
        MyRankVC *rankVC = [MyRankVC new];
        
        [weakSelf.navigationController pushViewController:rankVC animated:YES];
    };
    //我的资料
    MineModel *information = [MineModel new];
    
    information.text = @"我的履历";
    information.imgName = @"我的资料";
    information.action = ^{
        
        MyInfomationVC *infoVC = [MyInfomationVC new];
        
        [weakSelf.navigationController pushViewController:infoVC animated:YES];
    };
    
    
    //成果订单
    MineModel *order2 = [MineModel new];
    
    order2.text = @"成果订单";
    order2.imgName = @"成果订单";
    order2.action = ^{
        
        BrandOrderVC *orderVC = [BrandOrderVC new];
        
        [weakSelf.navigationController pushViewController:orderVC animated:YES];
        
//        AchievementOrderVC *orderVC = [AchievementOrderVC new];
//
//        [weakSelf.navigationController pushViewController:orderVC animated:YES];
    };
    self.group = [MineGroup new];

    self.group.sections = @[@[travelList], @[order], @[comments,ranking,information],@[order2]];
}
//服务团队
- (void)initServiceTeam
{
    BaseWeakSelf;
    //行程列表
    MineModel *travelList = [MineModel new];
    
    travelList.text = @"我的行程";
    travelList.imgName = @"行程列表";
    travelList.action = ^{
        
        MyViewController *mytripListVC = [MyViewController new];
        
        [weakSelf.navigationController pushViewController:mytripListVC animated:YES];
    };
    
    //团队行程
    MineModel *travelListTeam = [MineModel new];
    
    travelListTeam.text = @"团队行程";
    travelListTeam.imgName = @"我的排名";
    travelListTeam.action = ^{
        
        TripListVC *tripListVC = [TripListVC new];
        
        [weakSelf.navigationController pushViewController:tripListVC animated:YES];
    };
    
    //网络图谱
    MineModel *netMap = [MineModel new];
    
    netMap.text = @"网络图谱";
    netMap.imgName = @"帮助中心";
    netMap.action = ^{
        
        TreeMaoVC *treeMap = [TreeMaoVC new];
        
        [weakSelf.navigationController pushViewController:treeMap animated:YES];
    };
    
    
    //我的评论
    MineModel *comments = [MineModel new];
    
    comments.text = @"我的评论";
    comments.imgName = @"我的评论";
    comments.action = ^{
        
        MyCommentVC *myCommentVC = [MyCommentVC new];
        
        [weakSelf.navigationController pushViewController:myCommentVC animated:YES];
        
    };
    
    
    //我的资料
    MineModel *information = [MineModel new];
    
    information.text = @"我的履历";
    information.imgName = @"我的资料";
    information.action = ^{
        
        MyInfomationVC *infoVC = [MyInfomationVC new];
        
        [weakSelf.navigationController pushViewController:infoVC animated:YES];
    };
    
    
    //成果订单
    MineModel *order2 = [MineModel new];
    
    order2.text = @"我的订单";
    order2.imgName = @"成果订单";
    order2.action = ^{
        
        BrandOrderVC *orderVC = [BrandOrderVC new];
        
        [weakSelf.navigationController pushViewController:orderVC animated:YES];
    };
    self.group = [MineGroup new];

    self.group.sections = @[@[travelList],@[travelListTeam],@[netMap,comments],@[information],@[order2]];
    
}

- (void)initTableView {
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 110 + kNavigationBarHeight)];
    
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.image = kImage(@"我的-背景");
    
    imageView.tag = 1500;
    
    [self.view addSubview:imageView];
    
    self.tableView = [[MineTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kTabBarHeight) style:UITableViewStyleGrouped];
    
    [self.view addSubview:self.tableView];
    
    //tableview的header
    self.headerView = [[MineHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 110 + kNavigationBarHeight)];
    
    self.headerView.delegate = self;
    
    self.tableView.tableHeaderView = self.headerView;
    
    [self.headerView.xiaobangbiL bk_addEventHandler:^(id sender) {
        [self withdrawal];
    } forControlEvents:UIControlEventTouchUpInside];
    
    [self.headerView.xiaobangJuanL bk_addEventHandler:^(id sender) {
        [self billsRunningWater];
    } forControlEvents:UIControlEventTouchUpInside];
    
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeInfo) name:kUserLoginNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeInfo) name:kUserInfoChange object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginOut) name:kUserLoginOutNotification object:nil];
}

#pragma mark - Events
- (void)changeInfo {
    //
    [self.headerView.userPhoto sd_setImageWithURL:[NSURL URLWithString:[[TLUser user].photo convertImageUrl]] placeholderImage:USER_PLACEHOLDER_SMALL];
    
    self.headerView.nameLbl.text = [TLUser user].realName;
    NSString *genderImg = [[TLUser user].gender isEqualToString:@"0"] ? @"女生": @"男士";
    self.headerView.genderIV.image =  kImage(genderImg);
    
    NSString *speciality = ![[TLUser user].speciality valid] ? @"": [NSString stringWithFormat:@" · %@", [TLUser user].speciality];
    
    self.headerView.infoLbl.text = [NSString stringWithFormat:@"%@%@", [[TLUser user] getUserType], speciality];
    
    [self.headerView.xiaobangJuanL setTitle:[NSString stringWithFormat:@"销帮卷:%@",[TLUser user].jfamount] forState:UIControlStateNormal];
    [self.headerView.xiaobangbiL setTitle:[NSString stringWithFormat:@"销帮币:%@",[TLUser user].rmbamount] forState:UIControlStateNormal];
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

- (void)requestLinkMobile {
    
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = USER_INFO;
    http.parameters[@"userId"] = [TLUser user].userId;
    [http postWithSuccess:^(id responseObject) {
        
        TLUser *user = [TLUser mj_objectWithKeyValues:responseObject[@"data"]];
        
        AdviserUser *adviserUser = user.adviserUser;
        
        if (![adviserUser.mobile valid]) {
            
            [TLAlert alertWithInfo:@"暂无团队顾问手机号"];
            return ;
        }
        //
        NSString *mobile = [NSString stringWithFormat:@"telprompt://%@", adviserUser.mobile];
        
        NSURL *url = [NSURL URLWithString:mobile];
        
        [[UIApplication sharedApplication] openURL:url];
        
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
            
//        case MineHeaderSeletedTypeSelectPhoto:
//        {
//            [self.imagePicker picker];
//
//        }break;
            
        default:
            break;
    }
}
//提现充值页面
- (void)withdrawal
{
    [self.navigationController pushViewController:[WithdrawalVC new] animated:YES];
}
//肖邦卷 账单流水
- (void)billsRunningWater
{
    [self.navigationController pushViewController:[IntregalFlowVC new] animated:YES];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

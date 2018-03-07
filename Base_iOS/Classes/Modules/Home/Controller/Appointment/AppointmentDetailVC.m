//
//  AppointmentDetailVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/10.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "AppointmentDetailVC.h"

//Macro
#import "APICodeMacro.h"
//Category
#import "UIControl+Block.h"
#import "NSDate+Extend.h"
#import "NSString+Date.h"
#import "NSString+Check.h"
//Extension
#import "TLProgressHUD.h"
//M
#import "CommentModel.h"
#import "TripInfoModel.h"
//V
#import "AppointmentDetailTableView.h"
#import "AppointmentDetailHeaderView.h"
#import "TLPlaceholderView.h"
//C
#import "AppointmentStartVC.h"
#import "TLUserLoginVC.h"
#import "NavigationController.h"

@interface AppointmentDetailVC ()
//
@property (nonatomic, strong) AppointmentDetailTableView *tableView;
//
@property (nonatomic, strong) AppointmentDetailHeaderView *headerView;
//评论列表
@property (nonatomic, strong) NSArray <CommentModel *>*commentList;
//
@property (nonatomic, strong) UIView *bottomView;
//行程列表
@property (nonatomic, strong) NSArray <TripInfoModel *>*trips;

@end

@implementation AppointmentDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //
    [self initTableView];
    //底部按钮
    [self initBottomView];
    //获取服务器当前时间
    [self getServiceCurrentTime];
    //
    [self addNotification];
}

#pragma mark - 断网操作
- (void)placeholderOperation {
    //获取服务器当前时间
    [self getServiceCurrentTime];
}

#pragma mark - Init
- (void)initTableView {
    
    self.tableView = [[AppointmentDetailTableView alloc] initWithFrame:CGRectZero
                                                                 style:UITableViewStylePlain];
    
    self.tableView.placeHolderView = [TLPlaceholderView placeholderViewWithImage:@"暂无订单" text:@"暂无评论"];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(0);
    }];
    //HeaderView
    self.headerView = [[AppointmentDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 115)];
    
    self.headerView.detailModel = self.appomintment;
    
    self.tableView.tableHeaderView = self.headerView;
}

- (void)initBottomView {
    
    BaseWeakSelf;
    
    CGFloat viewH = 50 + kBottomInsetHeight;
    //
    self.bottomView = [[UIView alloc] init];
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.bottom.equalTo(@0);
        make.width.equalTo(@(kScreenWidth));
        make.height.equalTo(@(viewH));
    }];
    
    //经纪人
    UIButton *agentBtn = [UIButton buttonWithTitle:@"经纪人"
                                       titleColor:kTextColor
                                  backgroundColor:kWhiteColor
                                        titleFont:16.0];
    
    [agentBtn bk_addEventHandler:^(id sender) {
        
        [weakSelf requestLinkMobile];
        
    } forControlEvents:UIControlEventTouchUpInside];
    
    [self.bottomView addSubview:agentBtn];
    [agentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.equalTo(@0);
        make.height.equalTo(@(50));
        make.width.equalTo(@(kWidth(kScreenWidth - 250)));
    }];
    //预约
    UIButton *appointmentBtn = [UIButton buttonWithTitle:@"预约"
                                      titleColor:kWhiteColor
                                 backgroundColor:kThemeColor
                                       titleFont:16.0];
    
    [appointmentBtn addTarget:self action:@selector(appointment) forControlEvents:UIControlEventTouchUpInside];
    
    [self.bottomView addSubview:appointmentBtn];
    [appointmentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.right.equalTo(@0);
        make.height.equalTo(@(50));
        make.width.equalTo(@(kWidth(250)));
    }];
    
}

- (void)addNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadHeaderView) name:@"HeaderViewDidLayout" object:nil];
}

/**
 刷新headerView
 */
- (void)reloadHeaderView {
    
    [TLProgressHUD dismiss];
}

#pragma mark - Events
- (void)appointment {
    
    BaseWeakSelf;
    
    if (![TLUser user].isLogin) {
        
        TLUserLoginVC *loginVC = [[TLUserLoginVC alloc] init];
        
        loginVC.loginSuccess = ^{
            
            [weakSelf appointment];
        };
        
        NavigationController *nav = [[NavigationController alloc] initWithRootViewController:loginVC];
        
        [self presentViewController:nav animated:YES completion:nil];
        
        return;
    }
    
    AppointmentStartVC *startVC = [AppointmentStartVC new];
    
    startVC.title = weakSelf.titleStr;
    startVC.code = weakSelf.appomintment.userId;
    
    [weakSelf.navigationController pushViewController:startVC animated:YES];
}

#pragma mark - Data
- (void)requestCommentList {
    
    BaseWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"805425";
    helper.limit = 10;
    helper.parameters[@"entityCode"] = self.appomintment.userId;
    helper.parameters[@"type"] = self.appomintment.kind;
    helper.parameters[@"status"] = @"AB";
//    helper.parameters[@"orderColumn"] = @"update_datetime";
//    helper.parameters[@"orderDir"] = @"desc";
    
    helper.tableView = self.tableView;
    
    [helper modelClass:[CommentModel class]];
    
    [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
        
        [TLProgressHUD dismiss];
        
        weakSelf.tableView.commentList = objs;
        weakSelf.tableView.detailModel = weakSelf.appomintment;
        
        [weakSelf.tableView reloadData_tl];

    } failure:^(NSError *error) {
        
        [TLProgressHUD dismiss];
    }];
    
    [self.tableView endRefreshingWithNoMoreData_tl];
    
}

/**
 计算总条数和评分
 */
- (void)requestCommentInfo {
    
    BaseWeakSelf;
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"805423";
    http.parameters[@"entityCode"] = self.appomintment.userId;
    
    [http postWithSuccess:^(id responseObject) {
                
        _appomintment.totalCount = [[NSString stringWithFormat:@"%@", responseObject[@"data"][@"totalCount"]] integerValue];
        _appomintment.average = [[NSString stringWithFormat:@"%@", responseObject[@"data"][@"average"]] doubleValue];
        
        //获取评论列表
        [weakSelf requestCommentList];
        
    } failure:^(NSError *error) {
        
        [TLProgressHUD dismiss];
        
    }];
}

- (void)requestTrip {
    
    BaseWeakSelf;
    //获取当前月份
    NSDate *date = [NSString dateFromString:self.appomintment.currentTime formatter:@"yyyy-MM-dd"];
    
    NSString *currentMonth = [NSString stringWithFormat:@"%ld-%ld", date.year,date.month];
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"805508";
    http.parameters[@"userId"] = self.appomintment.userId;
    http.parameters[@"startMonth"] = currentMonth;
    
    [http postWithSuccess:^(id responseObject) {
        
        weakSelf.trips = [TripInfoModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        weakSelf.tableView.trips = weakSelf.trips;
        
        //计算总条数和评分
        [self requestCommentInfo];
        
    } failure:^(NSError *error) {
        
        [TLProgressHUD dismiss];

    }];
    
}

- (void)requestLinkMobile {
    
    if (![self.appomintment.handler valid]) {
        
        [TLAlert alertWithInfo:[NSString stringWithFormat:@"%@暂无经纪人哦", [self.appomintment getUserType]]];
        return ;
    }
    
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = USER_INFO;
    http.parameters[@"userId"] = self.appomintment.handler;
    
    [http postWithSuccess:^(id responseObject) {
        
        NSDictionary *userInfo = responseObject[@"data"];
        
        if (![userInfo[@"mobile"] valid]) {
            
            [TLAlert alertWithInfo:@"经纪人暂无手机号哦"];
            return ;
        }
        //
        NSString *mobile = [NSString stringWithFormat:@"telprompt://%@", userInfo[@"mobile"]];
        
        NSURL *url = [NSURL URLWithString:mobile];
        
        [[UIApplication sharedApplication] openURL:url];
        
    } failure:^(NSError *error) {
        
        
    }];
}

- (void)getServiceCurrentTime {
    
    [TLProgressHUD show];
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"805126";
    
    [http postWithSuccess:^(id responseObject) {
        
        self.appomintment.currentTime = responseObject[@"data"];
        //获取行程
        [self requestTrip];
        
    } failure:^(NSError *error) {
        
        [TLProgressHUD dismiss];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  PlatfromProposalVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/7.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "PlatfromProposalVC.h"

//Category
#import "UIBarButtonItem+convience.h"
//M
#import "ProposalModel.h"
#import "ProposalInfoModel.h"
//V
#import "ProposalHeaderView.h"
#import "ProposalTableView.h"
//C
#import "WriteCommentVC.h"
#import "TLUserLoginVC.h"
#import "NavigationController.h"

@interface PlatfromProposalVC ()
//头部视图
@property (nonatomic, strong) ProposalHeaderView *headerView;
//
@property (nonatomic, strong) ProposalTableView *tableView;

@end

@implementation PlatfromProposalVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"平台建议";
    //撰写评论
    [self initItem];
    //
    [self initTableView];
    //获取建议列表
    [self requestProposalList];
    //
    [self.tableView beginRefreshing];
}

#pragma mark - Init
- (void)initItem {
    
    [UIBarButtonItem addRightItemWithTitle:@"撰写评论" titleColor:kWhiteColor frame:CGRectMake(0, 0, 70, 44) vc:self action:@selector(writeComment)];
}

- (void)initTableView {
    
    BaseWeakSelf;
    
    self.tableView = [[ProposalTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(0);
    }];
    //
    self.headerView = [[ProposalHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 180)];
    
    self.headerView.starView.starBlock = ^(NSInteger count) {
        
        [weakSelf startCommentWithCount:count];
    };
    
}

#pragma mark - Events
- (void)startCommentWithCount:(NSInteger)count {
    
    BaseWeakSelf;
    
    if (![TLUser user].isLogin) {
        
        TLUserLoginVC *loginVC = [[TLUserLoginVC alloc] init];
        
        loginVC.loginSuccess = ^(){
            
            [weakSelf startCommentWithCount:count];
        };
        NavigationController *nav = [[NavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:nav animated:YES completion:nil];
        
        return;
    }
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"805400";
    http.parameters[@"commenter"] = [TLUser user].userId;
    http.parameters[@"score"] = [NSString stringWithFormat:@"%ld", count];
    
    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithSucces:@"评分成功"];
        
        [self.tableView beginRefreshing];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)writeComment {
    
    BaseWeakSelf;
    
    if (![TLUser user].isLogin) {
        
        TLUserLoginVC *loginVC = [[TLUserLoginVC alloc] init];
        
        loginVC.loginSuccess = ^(){
            
            [weakSelf writeComment];
        };
        NavigationController *nav = [[NavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:nav animated:YES completion:nil];
        
        return;
    }
    
    WriteCommentVC *writeVC = [WriteCommentVC new];
    
    writeVC.commentSuccess = ^{
        
        [weakSelf.tableView beginRefreshing];
    };
    
    [self.navigationController pushViewController:writeVC animated:YES];
}

#pragma mark - Data
- (void)requestProposalList {
    
    BaseWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"805405";
    helper.limit = 10;
    helper.parameters[@"status"] = @"AB";
    
    helper.tableView = self.tableView;
    
    [helper modelClass:[ProposalModel class]];
    
    [self.tableView addRefreshAction:^{
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.tableView.proposals = objs;
            
            [weakSelf.tableView reloadData_tl];
            
            //统计建议平均分、建议条数、每种分值的条数
            [weakSelf requestProposalInfo];
            
        } failure:^(NSError *error) {
            
        }];
        
    }];
}

- (void)requestProposalInfo {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"805702";
    
    [http postWithSuccess:^(id responseObject) {
        
        ProposalInfoModel *model = [ProposalInfoModel mj_objectWithKeyValues:responseObject[@"data"]];
        self.headerView.info = model;
        
        self.tableView.tableHeaderView = self.headerView;

    } failure:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

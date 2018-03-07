//
//  MyRankVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/28.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "MyRankVC.h"
//M
#import "MyRankModel.h"
//V
#import "MyRankTableView.h"
#import "TLPlaceholderView.h"

@interface MyRankVC ()
//
@property (nonatomic, strong) MyRankTableView *tableView;

@end

@implementation MyRankVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的排行";
    //
    [self initTableView];
    //获取排行列表
    [self requestRankList];
    //
    [self.tableView beginRefreshing];
}

#pragma mark - 断网操作
- (void)placeholderOperation {
    
    [self.tableView beginRefreshing];
}

#pragma mark - Init

- (void)initTableView {
    
    self.tableView = [[MyRankTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight) style:UITableViewStylePlain];
    
    self.tableView.placeHolderView = [TLPlaceholderView placeholderViewWithImage:@"暂无订单" text:@"暂无排行"];

    [self.view addSubview:self.tableView];
    
}

#pragma mark - Data
- (void)requestRankList {
    
    BaseWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"805123";
    helper.parameters[@"refNo"] = [TLUser user].userId;
    helper.tableView = self.tableView;
    
    [helper modelClass:[MyRankModel class]];
    
    [self.tableView addRefreshAction:^{
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.tableView.ranks = objs;
            
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
    }];
    
    [self.tableView addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.tableView.ranks = objs;
            
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
    }];
    
    [self.tableView endRefreshingWithNoMoreData_tl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

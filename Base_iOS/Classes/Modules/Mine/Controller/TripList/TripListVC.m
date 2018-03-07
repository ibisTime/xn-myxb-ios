//
//  TripListVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/28.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "TripListVC.h"

//M
#import "TripListModel.h"
//V
#import "TripListTableView.h"
#import "TLPlaceholderView.h"

@interface TripListVC ()
//
@property (nonatomic, strong) TripListTableView *tableView;

@end

@implementation TripListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"行程列表";
    //
    [self initTableView];
    //获取行程列表
    [self requestTripList];
    //
    [self.tableView beginRefreshing];
    
}

#pragma mark - 断网操作
- (void)placeholderOperation {
    
    [self.tableView beginRefreshing];
}

#pragma mark - Init

- (void)initTableView {
    
    self.tableView = [[TripListTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight) style:UITableViewStylePlain];
    
    self.tableView.placeHolderView = [TLPlaceholderView placeholderViewWithImage:@"暂无订单" text:@"暂无行程"];

    [self.view addSubview:self.tableView];
    
}

#pragma mark - Data
- (void)requestTripList {
    
    BaseWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"805505";
    helper.parameters[@"userId"] = [TLUser user].userId;
    helper.tableView = self.tableView;
    [helper modelClass:[TripListModel class]];
    
    [self.tableView addRefreshAction:^{
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.tableView.trips = objs;
            
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
    }];
    
    [self.tableView addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.tableView.trips = objs;
            
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

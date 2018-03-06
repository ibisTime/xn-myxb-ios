//
//  ProposalListVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/3/3.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "ProposalListVC.h"
//M
#import "ProposalModel.h"
//V
#import "ProposalHeaderView.h"
#import "ProposalTableView.h"
@interface ProposalListVC ()
//
@property (nonatomic, strong) ProposalTableView *tableView;//

@end

@implementation ProposalListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"全部评论";
    //
    [self initTableView];
    //获取建议列表
    [self requestProposalList];
    //
    [self.tableView beginRefreshing];
}
#pragma mark - 断网操作
- (void)placeholderOperation {
    
    [self.tableView beginRefreshing];
}

- (void)initTableView {
    
    self.tableView = [[ProposalTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(0);
    }];
    
}

#pragma mark - Data
- (void)requestProposalList {
    
    BaseWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"805405";
    helper.parameters[@"status"] = @"AB";
    
    helper.tableView = self.tableView;
    
    [helper modelClass:[ProposalModel class]];
    
    [self.tableView addRefreshAction:^{
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            [weakSelf removePlaceholderView];

            weakSelf.tableView.proposals = objs;
            
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            [weakSelf addPlaceholderView];
            
        }];
        
    }];
    
    [self.tableView addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            [weakSelf removePlaceholderView];
            
            weakSelf.tableView.proposals = objs;
            
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            [weakSelf addPlaceholderView];

        }];
    }];
    
    [self.tableView endRefreshingWithNoMoreData_tl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

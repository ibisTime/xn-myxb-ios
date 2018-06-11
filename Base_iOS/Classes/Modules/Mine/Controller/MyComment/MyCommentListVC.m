//
//  MyCommentListVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/3/1.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "MyCommentListVC.h"
//M
#import "CommentModel.h"
//V
#import "MyCommentTableView.h"
#import "TLPlaceholderView.h"

@interface MyCommentListVC ()
//
@property (nonatomic, strong) MyCommentTableView *tableView;

@end

@implementation MyCommentListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    //
    [self initTableView];
    //获取评论列表
    [self requestCommentList];
    //
    [self.tableView beginRefreshing];
    
}

#pragma mark - 断网操作
- (void)placeholderOperation {
    
    [self.tableView beginRefreshing];
}

#pragma mark - Init

- (void)initTableView {
    
    self.tableView = [[MyCommentTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight) style:UITableViewStylePlain];
    
    self.tableView.placeHolderView = [TLPlaceholderView placeholderViewWithImage:@"暂无订单" text:@"暂无评论"];

    [self.view addSubview:self.tableView];
    
}

#pragma mark - Data
- (void)requestCommentList {
    
    BaseWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    if (self.isMySelf) {
        helper.code = @"805429";
        helper.parameters[@"userId"] = [TLUser user].userId;

    }
    else
    {
        helper.code = @"805425";
        helper.parameters[@"commenter"] = [TLUser user].userId;
        helper.parameters[@"status"] = @"AB";
        helper.parameters[@"orderColumn"] = @"comment_datetime";
        helper.parameters[@"orderDir"] = @"desc";
        helper.parameters[@"type"] = self.type;
    }
    
    
    
    helper.tableView = self.tableView;
    [helper modelClass:[CommentModel class]];
    
    [self.tableView addRefreshAction:^{
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.tableView.comments = objs;
            
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
    }];
    
    [self.tableView addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.tableView.comments = objs;
            
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

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

@interface MyCommentListVC ()
//
@property (nonatomic, strong) MyCommentTableView *tableView;
//暂无评论
@property (nonatomic, strong) UIView *placeHolderView;

@end

@implementation MyCommentListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //
    [self initPlaceHolderView];
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
- (void)initPlaceHolderView {
    
    self.placeHolderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight - 40)];
    
    UIImageView *couponIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 90, 80, 80)];
    
    couponIV.image = kImage(@"暂无订单");
    
    couponIV.centerX = kScreenWidth/2.0;
    
    [self.placeHolderView addSubview:couponIV];
    
    UILabel *textLbl = [UILabel labelWithBackgroundColor:kClearColor
                                               textColor:kTextColor
                                                    font:15.0];
    textLbl.text = @"暂无评论";
    textLbl.frame = CGRectMake(0, couponIV.yy + 20, kScreenWidth, 15);
    
    textLbl.textAlignment = NSTextAlignmentCenter;
    
    [self.placeHolderView addSubview:textLbl];
}

- (void)initTableView {
    
    self.tableView = [[MyCommentTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight) style:UITableViewStylePlain];
    
    self.tableView.placeHolderView = self.placeHolderView;
    
    [self.view addSubview:self.tableView];
    
}

#pragma mark - Data
- (void)requestCommentList {
    
    BaseWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"805425";
    helper.parameters[@"commenter"] = [TLUser user].userId;
    helper.parameters[@"status"] = @"AB";
    helper.parameters[@"orderColumn"] = @"comment_datetime";
    helper.parameters[@"orderDir"] = @"desc";
    helper.parameters[@"type"] = self.type;
    
    helper.tableView = self.tableView;
    [helper modelClass:[CommentModel class]];
    
    [self.tableView addRefreshAction:^{
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            [weakSelf removePlaceholderView];
            
            weakSelf.tableView.comments = objs;
            
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            [weakSelf addPlaceholderView];
        }];
    }];
    
    [self.tableView addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            [weakSelf removePlaceholderView];
            
            weakSelf.tableView.comments = objs;
            
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

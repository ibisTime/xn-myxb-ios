//
//  BrandCommentListVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/26.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BrandCommentListVC.h"

//Category
#import "UIControl+Block.h"
//Extension
#import "TLProgressHUD.h"
//M
#import "BrandModel.h"
#import "CommentModel.h"
//V
#import "BrandCommentTableView.h"
#import "TLPlaceholderView.h"
//C
#import "BrandBuyVC.h"

@interface BrandCommentListVC ()
//
@property (nonatomic, strong) BrandCommentTableView *tableView;
//
@property (nonatomic, strong) UIView *bottomView;
//
@property (nonatomic, strong) BrandModel *good;
//
@property (nonatomic, strong) NSArray <CommentModel *>*commentList;

@end

@implementation BrandCommentListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"评论";
    //
    [self initTableView];
    //获取评论列表
    [self requestCommentList];
}


#pragma mark - 断网操作
- (void)placeholderOperation {
    //获取评论列表
    [self requestCommentList];
}

#pragma mark - Init
- (void)initTableView {
    
    self.tableView = [[BrandCommentTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    self.tableView.placeHolderView = [TLPlaceholderView placeholderViewWithText:@"暂无评论" topMargin:140];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.right.mas_equalTo(0);
        make.bottom.equalTo(@(-(50 + kBottomInsetHeight)));
    }];
    
}

#pragma mark - Data

- (void)requestCommentList {
    
    BaseWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"805425";
    helper.limit = 20;
    helper.parameters[@"entityCode"] = self.code;
    helper.parameters[@"status"] = @"AB";
    helper.parameters[@"orderColumn"] = @"update_datetime";
    helper.parameters[@"orderDir"] = @"desc";
    
    helper.tableView = self.tableView;
    
    [helper modelClass:[CommentModel class]];
    
    [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
        
        [weakSelf removePlaceholderView];
        
        weakSelf.tableView.commentList = objs;
        
        [weakSelf.tableView reloadData_tl];
        
    } failure:^(NSError *error) {
        
        [weakSelf addPlaceholderView];
        
        [TLProgressHUD dismiss];
    }];
    
    [self.tableView endRefreshingWithNoMoreData_tl];
    
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

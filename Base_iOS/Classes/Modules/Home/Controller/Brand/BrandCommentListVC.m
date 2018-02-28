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
#import "CommentKeywordModel.h"
//V
#import "BrandCommentTableView.h"
#import "TLPlaceholderView.h"
#import "AutoresizeLabelFlow.h"
//C
#import "BrandBuyVC.h"

@interface BrandCommentListVC ()
//
@property (nonatomic, strong) BrandCommentTableView *tableView;
//评论标签
@property (nonatomic, strong) AutoresizeLabelFlow *headerView;
//
@property (nonatomic, strong) UIView *bottomView;
//
@property (nonatomic, strong) BrandModel *good;
//
@property (nonatomic, strong) NSArray <CommentModel *>*commentList;
//当前选择的关键字
@property (nonatomic, copy) NSString *currentKeyWord;
//关键字列表
@property (nonatomic, strong) NSMutableArray <AutoresizeLabelModel *>*keywords;

@end

@implementation BrandCommentListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"评论";
    //
    [self initTableView];
    //获取关键字列表
    [self requestKeywordList];
    //获取评论列表
    [self requestCommentList];
    
}

#pragma mark - 断网操作
- (void)placeholderOperation {
    
    [self.tableView beginRefreshing];
}

#pragma mark - Init
- (void)initTableView {
    
    self.currentKeyWord = @"全部";
    
    self.tableView = [[BrandCommentTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight) style:UITableViewStylePlain];
    
    self.tableView.placeHolderView = [TLPlaceholderView placeholderViewWithText:@"暂无评论" topMargin:140];
    
    [self.view addSubview:self.tableView];
    
}

- (AutoresizeLabelFlow *)headerView {
    
    if (!_headerView) {
        
        BaseWeakSelf;
        
        _headerView = [[AutoresizeLabelFlow alloc]initWithFrame:CGRectMake(0, 220, kScreenWidth, 100) selectedHandler:^(NSUInteger index, NSString *title) {
            
            weakSelf.currentKeyWord = title;
            
            [weakSelf.tableView beginRefreshing];
        }];
        
        _headerView.data = self.keywords.copy;
    }
    return _headerView;
}

#pragma mark - Data
- (void)requestKeywordList {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"805414";
    http.parameters[@"kind"] = self.kind;

    [http postWithSuccess:^(id responseObject) {
        
        AutoresizeLabelModel *model = [AutoresizeLabelModel new];
        
        model.title = @"全部";
        model.isSelected = YES;
        
        self.keywords = [NSMutableArray arrayWithObject:model];
        
        NSArray <CommentKeywordModel *>*keywords = [CommentKeywordModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        [keywords enumerateObjectsUsingBlock:^(CommentKeywordModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            AutoresizeLabelModel *model = [AutoresizeLabelModel new];
            
            model.title = [NSString stringWithFormat:@"%@(%ld)", obj.word, obj.count];
            model.isSelected = NO;
            
            [self.keywords addObject:model];
        }];
        
        self.tableView.tableHeaderView = self.headerView;
        
        [self.tableView beginRefreshing];

    } failure:^(NSError *error) {
        
    }];
}

- (void)requestCommentList {
    
    BaseWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"805428";
    helper.limit = 20;
    helper.parameters[@"entityCode"] = self.code;
    helper.parameters[@"status"] = @"AB";
    helper.parameters[@"orderColumn"] = @"comment_datetime";
    helper.parameters[@"orderDir"] = @"desc";
    helper.parameters[@"type"] = self.kind;
    helper.parameters[@"keyWord"] = self.currentKeyWord;
    
    helper.tableView = self.tableView;
    
    [helper modelClass:[CommentModel class]];
    
    [self.tableView addRefreshAction:^{
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            [weakSelf removePlaceholderView];
            
            weakSelf.tableView.commentList = objs;
            
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            [weakSelf addPlaceholderView];
            
            [TLProgressHUD dismiss];
        }];
        
    }];
    
    [self.tableView addLoadMoreAction:^{
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            [weakSelf removePlaceholderView];
            
            weakSelf.tableView.commentList = objs;
            
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            [weakSelf addPlaceholderView];
            
            [TLProgressHUD dismiss];
        }];
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

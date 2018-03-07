//
//  BrandDetailVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/22.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BrandDetailVC.h"
//Macro
#import "APICodeMacro.h"
//Category
#import "UIControl+Block.h"
#import "NSString+Check.h"
//Extension
#import "TLProgressHUD.h"
//M
#import "BrandModel.h"
#import "CommentModel.h"
//V
#import "BrandDetailTableView.h"
#import "BrandDetailHeaderView.h"
#import "TLPlaceholderView.h"
//C
#import "BrandBuyVC.h"

@interface BrandDetailVC ()
//
@property (nonatomic, strong) BrandDetailTableView *tableView;
//
@property (nonatomic, strong) BrandDetailHeaderView *headerView;
//
@property (nonatomic, strong) UIView *bottomView;
//
@property (nonatomic, strong) BrandModel *good;
//
@property (nonatomic, strong) NSArray <CommentModel *>*commentList;

@end

@implementation BrandDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //
    [self initTableView];

    //获取产品详情
    [self requestGoodDetail];
    //
    [self addNotification];
}

#pragma mark - 断网操作
- (void)placeholderOperation {
    //获取产品详情
    [self requestGoodDetail];

}

#pragma mark - Init
- (void)initTableView {
    
    self.tableView = [[BrandDetailTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    self.tableView.code = self.code;
    
    self.tableView.placeHolderView = [TLPlaceholderView placeholderViewWithImage:@"暂无订单" text:@"暂无评论"];

    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.right.mas_equalTo(0);
        make.bottom.equalTo(@(-(50 + kBottomInsetHeight)));
    }];

    //HeaderView
    self.headerView = [[BrandDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 300)];
    
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
    
    //顾问
    UIButton *chatBtn = [UIButton buttonWithTitle:@"顾问"
                                       titleColor:kTextColor
                                  backgroundColor:kWhiteColor
                                        titleFont:16.0];
    
    [chatBtn bk_addEventHandler:^(id sender) {
        //获取顾问手机号
        [weakSelf requestLinkMobile];
        
    } forControlEvents:UIControlEventTouchUpInside];
    
    [self.bottomView addSubview:chatBtn];
    [chatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.equalTo(@0);
        make.height.equalTo(@(50));
        make.width.equalTo(@(kWidth(kScreenWidth - 250)));
    }];
    //下单
    UIButton *buyBtn = [UIButton buttonWithTitle:@"下单"
                                      titleColor:kWhiteColor
                                 backgroundColor:kThemeColor
                                       titleFont:16.0];
    
    [buyBtn bk_addEventHandler:^(id sender) {
        
        BrandBuyVC *buyVC = [BrandBuyVC new];
        
        buyVC.code = weakSelf.code;
        
        [weakSelf.navigationController pushViewController:buyVC animated:YES];
        
    } forControlEvents:UIControlEventTouchUpInside];
    
    [self.bottomView addSubview:buyBtn];
    [buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
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
    
    self.tableView.tableHeaderView = self.headerView;
    
    [self.tableView reloadData_tl];
    //底部按钮
    [self initBottomView];
    
    [TLProgressHUD dismiss];
}

#pragma mark - Data
- (void)requestGoodDetail {
    
    [TLProgressHUD show];
    
    BaseWeakSelf;
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"805267";
    http.parameters[@"code"] = self.code;
    [http postWithSuccess:^(id responseObject) {
        
        weakSelf.good = [BrandModel mj_objectWithKeyValues:responseObject[@"data"]];
        
        //计算总条数和评分
        [self requestCommentInfo];
        
    } failure:^(NSError *error) {
        
        [TLProgressHUD dismiss];

    }];
}

- (void)requestCommentList {
    
    BaseWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"805425";
    helper.limit = 10;
    helper.parameters[@"entityCode"] = self.code;
    helper.parameters[@"status"] = @"AB";
    helper.parameters[@"orderColumn"] = @"update_datetime";
    helper.parameters[@"orderDir"] = @"desc";
    helper.parameters[@"type"] = @"P";

    helper.tableView = self.tableView;
    
    [helper modelClass:[CommentModel class]];
    
    [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
        
        weakSelf.tableView.detailModel = weakSelf.good;
        weakSelf.headerView.detailModel = weakSelf.good;
        weakSelf.tableView.commentList = objs;
        
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
    http.parameters[@"entityCode"] = self.code;
    
    [http postWithSuccess:^(id responseObject) {
        
        _good.totalCount = [[NSString stringWithFormat:@"%@", responseObject[@"data"][@"totalCount"]] integerValue];
        _good.average = [[NSString stringWithFormat:@"%@", responseObject[@"data"][@"average"]] doubleValue];
        
        //获取评论列表
        [weakSelf requestCommentList];
        
    } failure:^(NSError *error) {
        
        [TLProgressHUD dismiss];

    }];
}

- (void)requestLinkMobile {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"805267";
    http.parameters[@"code"] = self.code;
    [http postWithSuccess:^(id responseObject) {
        
        self.good = [BrandModel mj_objectWithKeyValues:responseObject[@"data"]];
        
        if (![self.good.mobile valid]) {
            
            [TLAlert alertWithInfo:@"暂无顾问手机号"];
            return ;
        }
        //
        NSString *mobile = [NSString stringWithFormat:@"telprompt://%@", self.good.mobile];
        
        NSURL *url = [NSURL URLWithString:mobile];
        
        [[UIApplication sharedApplication] openURL:url];
        
    } failure:^(NSError *error) {
        
        [TLProgressHUD dismiss];
        
    }];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

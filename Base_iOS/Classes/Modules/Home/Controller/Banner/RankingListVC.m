//
//  RankingListVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/3/2.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "RankingListVC.h"
//Category
#import "NSString+CGSize.h"
#import "NSString+Extension.h"
#import <UIImageView+WebCache.h>
//V
#import "RankingListTableView.h"
#import "RankingHeaderView.h"
#import "TLPlaceholderView.h"

//我的排行
#define kMyRankingHeight    (60+kBottomInsetHeight)
#define kAmountBtnHeight    30

@interface RankingListVC ()

@property (nonatomic, strong) RankingListTableView *tableView;
//headerView
@property (nonatomic, strong) RankingHeaderView *headerView;
//排行
@property (nonatomic, strong) UILabel *rowLbl;
//头像
@property (nonatomic, strong) UIImageView *iconIV;
//昵称
@property (nonatomic, strong) UILabel *nickNameLbl;
//金额
@property (nonatomic, strong) UIButton *amountBtn;
//排行榜列表
@property (nonatomic, strong) NSArray <RankingModel *> *rankingList;

@end

@implementation RankingListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kClearColor;
    
    //排行榜
    [self initRankingListView];
    //获取排行榜列表
    [self requestRankingList];
    //
    [self.tableView beginRefreshing];
}

#pragma mark - 断网操作
- (void)placeholderOperation {
    
    [self.tableView beginRefreshing];
}

#pragma mark - Init
- (RankingHeaderView *)headerView {
    
    if (!_headerView) {
        
        _headerView = [[RankingHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kHeaderViewHeight)];
        
        _headerView.backgroundColor = kWhiteColor;
        
        self.tableView.tableHeaderView = _headerView;
    }
    return _headerView;
}

- (void)initRankingListView {
    
    self.view.backgroundColor = kBackgroundColor;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kHeaderViewHeight)];
    
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.tag = 1500;
//    imageView.backgroundColor = kWhiteColor;
    
    [self.view addSubview:imageView];
    
    self.tableView = [[RankingListTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.backgroundColor = kClearColor;
    self.tableView.placeHolderView = [TLPlaceholderView placeholderViewWithImage:@"暂无订单" text:@"暂无排名"];

    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, kMyRankingHeight, 0));
    }];
    
}

- (void)setBanner:(BannerModel *)banner {
    
    _banner = banner;
    
    self.title = _banner.name;
}

#pragma mark - Data
- (void)requestRankingList {
    
    NSString *code = @"";
    switch ([self.banner.kind integerValue]) {
        case 4:
        {
            code = @"805301";
        }break;
        case 5:
        {
            code = @"805133";
        }break;
        case 6:
        {
            code = @"805132";
        }break;
            
        default:
            break;
    }
    
    BaseWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = code;
    helper.isList = YES;
    helper.showView = self.view;
    helper.tableView = self.tableView;
    
    [helper modelClass:[RankingModel class]];
    
    [self.tableView addRefreshAction:^{
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.rankingList = objs;
            
            weakSelf.tableView.rankingList = objs;
            
            if (objs.count > 3) {
                
                weakSelf.headerView.rankingList = objs;
            }
            
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

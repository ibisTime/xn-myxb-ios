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

#import "UIControl+Block.h"
#import "UIBarButtonItem+convience.h"

#import "AddTripVC.h"
#import "TripCalendarVC.h"

@interface TripListVC ()<RefreshDelegate>
//
@property (nonatomic, strong) TripListTableView *tableView;

@end

@implementation TripListVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView beginRefreshing];
}

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
    
    
    
    if (!self.isTeam) {
        [UIBarButtonItem addRightItemWithTitle:@"行程日历" titleColor:kWhiteColor frame:CGRectMake(0, 0, 70, 44) vc:self action:@selector(linkService)];
        UIButton *addbtn = [UIButton buttonWithTitle:@"新增行程" titleColor:kWhiteColor backgroundColor:kThemeColor titleFont:18.0];
        [addbtn bk_addEventHandler:^(id sender) {
            AddTripVC *addtrip = [[AddTripVC alloc]init];
            [self.navigationController pushViewController:addtrip animated:YES];
            
        } forControlEvents:UIControlEventTouchUpInside];
        addbtn.layer.cornerRadius = 5;
        [self.view addSubview:addbtn];
        [addbtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@20);
            make.right.equalTo(@-20);
            make.bottom.equalTo(self.view.mas_bottom).with.offset(-kBottomInsetHeight);
            make.height.mas_equalTo(50);
            
        }];
    }
    
   
}

#pragma mark - 断网操作
- (void)placeholderOperation {
    
    [self.tableView beginRefreshing];
}

#pragma mark - Init

- (void)initTableView {
    
    self.tableView = [[TripListTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight) style:UITableViewStylePlain];
    self.tableView.isTeam = self.isTeam;
    self.tableView.refreshDelegate = self;
    self.tableView.placeHolderView = [TLPlaceholderView placeholderViewWithImage:@"暂无订单" text:@"暂无行程"];

    [self.view addSubview:self.tableView];
    
}

#pragma mark - Data
- (void)requestTripList {
    
    BaseWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    if (self.isTeam) {
        helper.code = @"805523";

    }
    else
    {
        helper.code = @"805505";

    }
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
#pragma mark - RefreshDelegate
- (void)refreshTableView:(TLTableView*)refreshTableview didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    NSLog(@"----->%ld",indexPath.row);
    TripListModel *model =[self.tableView.trips objectAtIndex:indexPath.row];
    AddTripVC *addtrip = [[AddTripVC alloc]init];
    addtrip.tripModel = model;
    [self.navigationController pushViewController:addtrip animated:YES];
}
#pragma mark - 行程管理
- (void)linkService
{
    [self.navigationController pushViewController:[TripCalendarVC new] animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  SystemNoticeVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/7.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "SystemNoticeVC.h"

//Manager
#import "AppConfig.h"
//M
#import "NoticeModel.h"
//V
#import "NoticeCell.h"
#import "TLPlaceholderView.h"

@interface SystemNoticeVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray <NoticeModel *> *notices;

@property (nonatomic,strong) TLTableView *tableView;

@end

@implementation SystemNoticeVC

static NSString *identifier = @"NoticeCellId";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"系统公告";

    [self initTableView];
    //获取消息列表
    [self requrstNoticeList];
    //刷新公告
    [self.tableView beginRefreshing];

}

#pragma mark - 断网操作
- (void)placeholderOperation {
    
    //刷新公告
    [self.tableView beginRefreshing];
}

#pragma mark - Init

- (void)initTableView {
    
    self.tableView = [TLTableView tableViewWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight)
                                            delegate:self
                                          dataSource:self];
    
    self.tableView.placeHolderView = [TLPlaceholderView placeholderViewWithImage:@"暂无订单" text:@"暂无公告"];

    [self.tableView registerClass:[NoticeCell class] forCellReuseIdentifier:identifier];
    
    [self.view addSubview:self.tableView];
}

#pragma mark - Data

- (void)requrstNoticeList {
    
    BaseWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"804040";
    helper.tableView = self.tableView;
    helper.parameters[@"token"] = [TLUser user].token;
    helper.parameters[@"channelType"] = @"4";
    
    helper.parameters[@"pushType"] = @"41";
    
    if ([TLUser user].isLogin) {
        
        helper.parameters[@"toKind"] = [TLUser user].kind;
    }
    //    1 立即发 2 定时发
    //    pageDataHelper.parameters[@"smsType"] = @"1";
    helper.parameters[@"start"] = @"1";
    helper.parameters[@"limit"] = @"20";
    helper.parameters[@"status"] = @"1";
    helper.parameters[@"fromSystemCode"] = [AppConfig config].systemCode;
    
    
    //0 未读 1 已读 2未读被删 3 已读被删
    //    pageDataHelper.parameters[@"status"] = @"0";
    //    pageDataHelper.parameters[@"dateStart"] = @""; //开始时间
    [helper modelClass:[NoticeModel class]];
    
    [self.tableView addRefreshAction:^{
        
        [helper refresh:^(NSMutableArray <NoticeModel *>*objs, BOOL stillHave) {
            
            weakSelf.notices = objs;
            
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }];
    
    [self.tableView addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray <NoticeModel *>*objs, BOOL stillHave) {
            
            weakSelf.notices = objs;
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }];
    
    [self.tableView endRefreshingWithNoMoreData_tl];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.notices.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    cell.notice = self.notices[indexPath.section];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return self.notices[indexPath.section].cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [UIView new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

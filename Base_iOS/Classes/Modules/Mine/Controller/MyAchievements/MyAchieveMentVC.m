//
//  MyAchieveMentVC.m
//  Base_iOS
//
//  Created by zhangfuyu on 2018/6/11.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "MyAchieveMentVC.h"
#import "UIBarButtonItem+convience.h"
#import "AchievementOrderVC.h"
#import "IntregalTaskHeaderView.h"

@interface MyAchieveMentVC ()
@property (nonatomic, strong) IntregalTaskHeaderView *headerView;
@property (nonatomic, strong) TLTableView *tableView;

@end

@implementation MyAchieveMentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [UIBarButtonItem addRightItemWithTitle:@"成果明细" titleColor:kWhiteColor frame:CGRectMake(0, 0, 70, 44) vc:self action:@selector(linkService)];
    
    [self initHeaderView];
    
    [self initTableView];

}
- (void)linkService
{
    AchievementOrderVC *orderVC = [AchievementOrderVC new];
    
    [self.navigationController pushViewController:orderVC animated:YES];
}
- (void)initTableView {
    
    self.tableView = [TLTableView tableViewWithFrame:CGRectMake(0, self.headerView.yy + 10, kScreenWidth, kScreenHeight - 64 - self.headerView.yy - 10) delegate:self dataSource:self];
    
    self.tableView.placeHolderView = [TLPlaceholderView placeholderViewWithImage:@"暂无订单" text:@"暂无记录"];
    
    [self.view addSubview:self.tableView];
}
#pragma mark - Init
- (void)initHeaderView {
    
    self.headerView = [[IntregalTaskHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 90)];
    self.headerView.jfLabel.text = @"¥0.00";
    self.headerView.arrowBtn.hidden = YES;
    [self.view addSubview:self.headerView];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

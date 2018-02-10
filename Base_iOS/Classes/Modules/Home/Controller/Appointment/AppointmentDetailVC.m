//
//  AppointmentDetailVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/10.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "AppointmentDetailVC.h"

//Macro
//Framework
//Category
//Extension
//M
#import "AppointmentDetailModel.h"
//V
#import "AppointmentDetailTableView.h"
#import "AppointmentDetailHeaderView.h"
//C

@interface AppointmentDetailVC ()
//
@property (nonatomic, strong) AppointmentDetailTableView *tableView;
//
@property (nonatomic, strong) AppointmentDetailHeaderView *headerView;

@end

@implementation AppointmentDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //
    [self initTableView];
}

#pragma mark - Init
- (void)initTableView {
    
    self.tableView = [[AppointmentDetailTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(0);
    }];
    
    //
    AppointmentDetailModel *detailModel = [AppointmentDetailModel new];
    
    detailModel.photo = @"";
    detailModel.nickName = @"CzyGod";
    detailModel.gender = 1;
    detailModel.job = @"美导";
    detailModel.expertise = @"打游戏";
    detailModel.style = @[@"幽默", @"和谐", @"牛掰"];
    detailModel.score = 3;
    detailModel.introduce = @"我们有什么优势呢？我们有什么优势呢？我们有什么优势呢？我们有什么优势呢？我们有什么优势呢？我们有什么优势呢？我们有什么优势呢？";
    
    self.tableView.detailModel = detailModel;
    
    [self.tableView reloadData];
    
    //HeaderView
    self.headerView = [[AppointmentDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 115)];
    
    self.headerView.detailModel = detailModel;
    
    self.tableView.tableHeaderView = self.headerView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

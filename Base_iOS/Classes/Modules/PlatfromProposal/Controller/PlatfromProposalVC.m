//
//  PlatfromProposalVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/7.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "PlatfromProposalVC.h"

//Macro
//Framework
//Category
//Extension
//M
#import "ProposalModel.h"
//V
#import "ProposalHeaderView.h"
#import "ProposalTableView.h"
//C
@interface PlatfromProposalVC ()
//头部视图
@property (nonatomic, strong) ProposalHeaderView *headerView;
//
@property (nonatomic, strong) ProposalTableView *tableView;

@end

@implementation PlatfromProposalVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"平台建议";
    //
    [self initTableView];
}

#pragma mark - Init

- (void)initTableView {
    
    self.tableView = [[ProposalTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(0);
    }];
    //
    self.headerView = [[ProposalHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 180)];
    
    self.tableView.tableHeaderView = self.headerView;
    //
    NSMutableArray *arr = [NSMutableArray array];
    
    for (int i = 0; i < 4; i++) {
        
        ProposalModel *proposal = [ProposalModel new];
        
        proposal.photo = @"";
        proposal.nickName = @"CzyGod";
        proposal.score = @"3";
        proposal.createTime = @"2018-02-29";
        proposal.comment = @"我们有什么优势呢？我们有什么优势呢？我们有什么优势呢？我们有什么优势呢？我们有什么优势呢？我们有什么优势呢？我们有什么优势呢？";
        [arr addObject:proposal];
        
    }
    
    self.tableView.proposals = arr;
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

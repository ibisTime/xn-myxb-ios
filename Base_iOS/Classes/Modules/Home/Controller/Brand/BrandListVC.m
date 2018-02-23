//
//  BrandListVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/22.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BrandListVC.h"
//Macro
//Framework
//Category
//Extension
//M
#import "BrandModel.h"
//V
#import "BrandListTableView.h"
//C
#import "BrandDetailVC.h"

@interface BrandListVC ()<RefreshDelegate>

@property (nonatomic, strong) BrandListTableView *tableView;

@end

@implementation BrandListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    [self initTableView];
}

- (void)initTableView {
    
    self.tableView = [[BrandListTableView alloc] initWithFrame:CGRectZero
                                                         style:UITableViewStylePlain];
    
    self.tableView.refreshDelegate = self;
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(0);
    }];
    
    //
    NSMutableArray *arr = [NSMutableArray array];
    
    for (int i = 0; i < 4; i++) {
        
        BrandModel *brand = [BrandModel new];
        
        [arr addObject:brand];
    }
    self.tableView.brands = arr;
    
    [self.tableView reloadData];
}

#pragma mark - RefreshDelegate
- (void)refreshTableView:(TLTableView *)refreshTableview didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BrandDetailVC *detailVC = [BrandDetailVC new];
    
    detailVC.title = @"产品详情";
    
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

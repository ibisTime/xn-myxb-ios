//
//  SchoolOfBusinessVC.m
//  Base_iOS
//
//  Created by zhangfuyu on 2018/5/29.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "SchoolOfBusinessVC.h"
#import "ProposalTableView.h"

@interface SchoolOfBusinessVC ()
@property (nonatomic, strong) ProposalTableView *tableView;

@end

@implementation SchoolOfBusinessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"商学院";
    [self initTableView];

    self.tableView.proposals = @[];
    
    [self.tableView reloadData_tl];

}
- (void)initTableView {
    
    self.tableView = [[ProposalTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    self.tableView.placeHolderView = [TLPlaceholderView placeholderViewWithImage:@"暂无订单" text:@"敬请期待"];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(0);
    }];
    //
    
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

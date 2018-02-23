//
//  AppointmentListVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/9.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "AppointmentListVC.h"
//Macro
//Framework
//Category
#import "UIBarButtonItem+convience.h"
//Extension
//M
#import "AppointmentListModel.h"
//V
#import "AppointmentListTableView.h"
//C
#import "AppointmentDetailVC.h"

@interface AppointmentListVC ()<RefreshDelegate>
//
@property (nonatomic, strong) AppointmentListTableView *tableView;

@end

@implementation AppointmentListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //搜索
    [self setSearchItem];
    //
    [self initTableView];
    
}

#pragma mark - Init
- (void)setSearchItem {
    
    [UIBarButtonItem addRightItemWithImageName:@"搜索"
                                         frame:CGRectMake(0, 0, 40, 40)
                                            vc:self
                                        action:@selector(clickSearch)];
}

- (void)initTableView {
    
    self.tableView = [[AppointmentListTableView alloc] initWithFrame:CGRectZero
                                                               style:UITableViewStylePlain];
    
    self.tableView.refreshDelegate = self;
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(0);
    }];
    
    //
    NSMutableArray *arr = [NSMutableArray array];
    
    for (int i = 0; i < 4; i++) {
        
        AppointmentListModel *appointment = [AppointmentListModel new];
        
        appointment.photo = @"";
        appointment.nickName = @"CzyGod";
        appointment.gender = 1;
        appointment.job = @"美导";
        appointment.expertise = @"打游戏";
        appointment.style = @[@"幽默", @"和谐", @"牛掰"];
        appointment.score = 3;
        appointment.introduce = @"我们有什么优势呢？我们有什么优势呢？我们有什么优势呢？我们有什么优势呢？我们有什么优势呢？我们有什么优势呢？我们有什么优势呢？";
        appointment.status = @"0";
        
        [arr addObject:appointment];
        
    }
    
    self.tableView.appointmentList = arr;
    
    [self.tableView reloadData];
}

#pragma mark - Events
- (void)clickSearch {
    
    
}

#pragma mark - RefreshDelegate
- (void)refreshTableView:(TLTableView *)refreshTableview didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AppointmentDetailVC *detailVC = [AppointmentDetailVC new];
    
    detailVC.title = self.titleStr;
    
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

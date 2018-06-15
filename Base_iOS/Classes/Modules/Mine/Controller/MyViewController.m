//
//  MyViewController.m
//  Base_iOS
//
//  Created by zhangfuyu on 2018/6/5.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "MyViewController.h"
#import "SelectScrollView.h"
#import "TripListVC.h"
#import "UIBarButtonItem+convience.h"
#import "AppointmentOrderListVC.h"
#import "YeeBadgeViewHeader.h"
#import "SortBar.h"
@interface MyViewController ()
@property (nonatomic, strong) SelectScrollView *selectScrollView;

@property (nonatomic, strong) NSArray *titles;

@property (nonatomic , strong) NSMutableArray *controArry;

@end

@implementation MyViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self reloadAllSubViews];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的行程";
    
    self.controArry = [NSMutableArray arrayWithCapacity:0];
    
    [self initSubview];
    
    [self addSubViewController];
    
    [UIBarButtonItem addRightItemWithTitle:@"行程管理" titleColor:kWhiteColor frame:CGRectMake(0, 0, 70, 44) vc:self action:@selector(linkService)];
    
    for (SortBar *barView in self.selectScrollView.subviews) {
        
        for (UIButton *btn in barView.subviews) {
            if (btn.tag == 100) {
                if ([TLUser user].fwToBookCount !=0) {
                    btn.titleLabel.redDotNumber = [TLUser user].fwInputCount + [TLUser user].fwToClassCount + [TLUser user].fwToBookCount + [TLUser user].fwClassEndCount + [TLUser user].jxsToApproveCount;
                    [btn.titleLabel ShowBadgeView];
                }
            }
            if (btn.tag == 101) {
                if ([TLUser user].fwToBookCount !=0) {
                    btn.titleLabel.redDotNumber =[TLUser user].fwToBookCount;
                    [btn.titleLabel ShowBadgeView];
                }
            }
            if (btn.tag == 102) {
                if ([TLUser user].fwInputCount !=0) {
                    btn.titleLabel.redDotNumber =[TLUser user].fwInputCount;
                    [btn.titleLabel ShowBadgeView];
                }
            }
            if (btn.tag == 103) {
                if ([TLUser user].jxsToApproveCount !=0) {
                    btn.titleLabel.redDotNumber =[TLUser user].jxsToApproveCount;
                    [btn.titleLabel ShowBadgeView];
                }
            }
            
//            if (btn.tag == 104) {
//                if ([TLUser user].toReceiceCount !=0) {
//                    btn.titleLabel.redDotNumber =[TLUser user].jxsToApproveCount;
//                    [btn.titleLabel ShowBadgeView];
//                }
//            }
            
        }
        
    }
    
    
}
- (void)initSubview
{
    self.titles = @[@"全部", @"待接单", @"待录入", @"待审核", @"已完成"];
    
    self.selectScrollView = [[SelectScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight) itemTitles:self.titles];
    
    //    self.selectScrollView.currentIndex = self.currentIndex;
    
    [self.view addSubview:self.selectScrollView];
}
- (void)addSubViewController {
    
    for (NSInteger i = 0; i < self.titles.count; i++) {
        
        AppointmentOrderListVC *childVC = [[AppointmentOrderListVC alloc] init];
        
        childVC.status = [NSString stringWithFormat:@"%ld",i];
        childVC.kind = [TLUser user].kind;
        NSArray *listarry;
        switch (i) {
            case 0:
                {
                    listarry = @[@"1",@"2",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11"];
                }
                break;
            case 1:
            {
                listarry = @[@"1"];
            }
                break;
            case 2:
            {
                listarry = @[@"5"];
            }
                break;
            case 3:
            {
                listarry = @[@"6",@"7",@"9"];

            }
                break;
            case 4:
            {
                listarry = @[@"10",@"11"];
            }
                break;
                
            default:
                break;
        }
        
        childVC.tatusList = listarry;
        childVC.view.frame = CGRectMake(kScreenWidth*i, 1, kScreenWidth, kSuperViewHeight - 40);
        [self addChildViewController:childVC];
        [self.controArry addObject:childVC];
        
        [_selectScrollView.scrollView addSubview:childVC.view];
        
    }
}
- (void)reloadAllSubViews
{
    for (AppointmentOrderListVC *listview in self.controArry) {
        [listview reloadTableview];
    }
}
- (void)linkService
{
    [self.navigationController pushViewController:[TripListVC new] animated:YES];
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

//
//  BrandOrderVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/25.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BrandOrderVC.h"

//V
#import "SelectScrollView.h"
#import "SortBar.h"
//C
#import "BrandOrderListVC.h"

#import "YeeBadgeViewHeader.h"


@interface BrandOrderVC ()

@property (nonatomic, strong) SelectScrollView *selectScrollView;

@property (nonatomic, strong) NSArray *titles;

@end

@implementation BrandOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的产品订单";
    //
    [self initSelectScrollView];
    //
    [self addSubViewController];
    
    for (SortBar *barView in self.selectScrollView.subviews) {
        
        for (UIButton *btn in barView.subviews) {
            if (btn.tag == 101) {
                if ([TLUser user].toPayCount !=0) {
                    btn.titleLabel.redDotNumber =[TLUser user].toPayCount;
                    [btn.titleLabel ShowBadgeView];
                }
            }
            if (btn.tag == 103) {
                if ([TLUser user].toReceiceCount !=0) {
                    btn.titleLabel.redDotNumber =[TLUser user].toReceiceCount;
                    [btn.titleLabel ShowBadgeView];
                }
            }
        }
        
    }
}

#pragma mark - Init
- (void)initSelectScrollView {
    
    self.titles = @[@"全部",@"代付款", @"待发货",@"待收货", @"待评价", @"已完成"];
    
    self.selectScrollView = [[SelectScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight) itemTitles:self.titles];
    
    //    self.selectScrollView.currentIndex = self.currentIndex;
    
    [self.view addSubview:self.selectScrollView];
}

- (void)addSubViewController {
    
    for (NSInteger i = 0; i < self.titles.count; i++) {
        
        BrandOrderListVC *childVC = [[BrandOrderListVC alloc] init];
        
        switch (i) {
            case 0:
                {
                    childVC.status = BrandOrderStatusAllOrder;

                }
                break;
            case 1:
            {
                childVC.status = BrandOrderStatusWillTpye1;

            }
                break;
            case 2:
            {
                childVC.status = BrandOrderStatusWillTpye2;

            }
                break;
            case 3:
            {
                childVC.status = BrandOrderStatusWillTpye3;

            }
                break;
            case 4:
            {
                childVC.status = BrandOrderStatusWillTpye4;

            }
                break;
            case 5:
            {
                childVC.status = BrandOrderStatusWillTpye5;

            }
                
            default:
                break;
        }
        
        childVC.view.frame = CGRectMake(kScreenWidth*i, 1, kScreenWidth, kSuperViewHeight - 40);
        
        [self addChildViewController:childVC];
        
        [_selectScrollView.scrollView addSubview:childVC.view];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

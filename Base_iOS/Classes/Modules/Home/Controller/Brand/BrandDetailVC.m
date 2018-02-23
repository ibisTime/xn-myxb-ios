//
//  BrandDetailVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/22.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BrandDetailVC.h"
//Macro
//Framework
//Category
#import "UIControl+Block.h"
//Extension
//M
#import "BrandModel.h"
//V
#import "BrandDetailTableView.h"
#import "BrandDetailHeaderView.h"
//C
#import "BrandBuyVC.h"

@interface BrandDetailVC ()
//
@property (nonatomic, strong) BrandDetailTableView *tableView;
//
@property (nonatomic, strong) BrandDetailHeaderView *headerView;
//
@property (nonatomic, strong) UIView *bottomView;

@end

@implementation BrandDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //
    [self initTableView];
    //底部按钮
    [self initBottomView];
}

#pragma mark - Init
- (void)initTableView {
    
    self.tableView = [[BrandDetailTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.right.mas_equalTo(0);
        make.bottom.equalTo(@(-(50 + kBottomInsetHeight)));
    }];
    
    //
    BrandModel *detailModel = [BrandModel new];
    
    detailModel.photo = @"";
    detailModel.nickName = @"CzyGod";
    detailModel.score = 3;
    detailModel.content = @"18年经典菜肴, 原料选用优质鸡中翅, 红心有机咸鸭蛋, 经大厨秘制配方匠心制作18年经典菜肴";
    detailModel.time = @"2018-2-22";
    detailModel.introduce = @"18年经典菜肴, 原料选用优质鸡中翅, 红心有机咸鸭蛋, 经大厨秘制配方匠心制作18年经典菜肴, 原料选用优质鸡中翅, 红心有机咸鸭蛋, 经大厨秘制配方匠心制作18年经典菜肴, 原料选用优质鸡中翅, 红心有机咸鸭蛋, 经大厨秘制配方匠心制作18年经典菜肴, 原料选用优质鸡中翅, 红心有机咸鸭蛋, 经大厨秘制配方匠心制作";
    
    self.tableView.detailModel = detailModel;
    
    [self.tableView reloadData];
    
    //HeaderView
    self.headerView = [[BrandDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 300)];
    
    self.headerView.detailModel = detailModel;
    
    self.tableView.tableHeaderView = self.headerView;
}

- (void)initBottomView {
    
    BaseWeakSelf;
    
    CGFloat viewH = 50 + kBottomInsetHeight;
    //
    self.bottomView = [[UIView alloc] init];
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.bottom.equalTo(@0);
        make.width.equalTo(@(kScreenWidth));
        make.height.equalTo(@(viewH));
    }];
    
    //顾问
    UIButton *chatBtn = [UIButton buttonWithTitle:@"顾问"
                                       titleColor:kTextColor
                                  backgroundColor:kWhiteColor
                                        titleFont:16.0];
    
    [chatBtn bk_addEventHandler:^(id sender) {
        
        
    } forControlEvents:UIControlEventTouchUpInside];
    
    [self.bottomView addSubview:chatBtn];
    [chatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.equalTo(@0);
        make.height.equalTo(@(50));
        make.width.equalTo(@(kWidth(kScreenWidth - 250)));
    }];
    //下单
    UIButton *buyBtn = [UIButton buttonWithTitle:@"下单"
                                      titleColor:kWhiteColor
                                 backgroundColor:kThemeColor
                                       titleFont:16.0];
    
    [buyBtn bk_addEventHandler:^(id sender) {
        
        BrandBuyVC *buyVC = [BrandBuyVC new];
        
        [weakSelf.navigationController pushViewController:buyVC animated:YES];
        
    } forControlEvents:UIControlEventTouchUpInside];
    
    [self.bottomView addSubview:buyBtn];
    [buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.right.equalTo(@0);
        make.height.equalTo(@(50));
        make.width.equalTo(@(kWidth(250)));
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

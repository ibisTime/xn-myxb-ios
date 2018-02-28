//
//  MyRankTableView.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/28.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "MyRankTableView.h"
//V
#import "MyRankCell.h"

@interface MyRankTableView()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation MyRankTableView
//
static NSString *myRankCellID = @"MyRankCell";

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    if (self = [super initWithFrame:frame style:style]) {
        
        self.dataSource = self;
        self.delegate = self;
        //评论
        [self registerClass:[MyRankCell class] forCellReuseIdentifier:myRankCellID];
    }
    
    return self;
}

#pragma mark - UITableViewDataSource;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.ranks.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyRankCell *cell = [tableView dequeueReusableCellWithIdentifier:myRankCellID forIndexPath:indexPath];
    
    cell.rank = self.ranks[indexPath.section];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    MyRankModel *rank = self.ranks[section];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 40)];
    
    headerView.backgroundColor = kBackgroundColor;
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 30)];
    v.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:v];
    
    UILabel *lbl1 = [UILabel labelWithFrame:CGRectZero
                               textAligment:NSTextAlignmentLeft
                            backgroundColor:[UIColor whiteColor]
                                       font:Font(11)
                                  textColor:kTextColor2];
    [headerView addSubview:lbl1];
    [lbl1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView.mas_left).offset(15);
        make.top.equalTo(headerView.mas_top).offset(10);
        make.bottom.equalTo(headerView.mas_bottom);
    }];
    lbl1.text = [NSString stringWithFormat:@"%@", rank.periods];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [UIView new];
}

@end

//
//  RankingListTableView.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/1/29.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "RankingListTableView.h"

#import "RankingListCell.h"

@interface RankingListTableView()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation RankingListTableView

static NSString *identifierCell = @"RankingListCell";

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    if (self = [super initWithFrame:frame style:style]) {
        
        self.dataSource = self;
        self.delegate = self;
        
        [self registerClass:[RankingListCell class] forCellReuseIdentifier:identifierCell];
    }
    
    return self;
}

#pragma mark - UITableViewDataSource;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.rankingList.count > 3) {
        
        return self.rankingList.count - 3;
    }
    return self.rankingList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RankingListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (self.rankingList.count > 3) {
        
        cell.ranking = self.rankingList[indexPath.row + 3];

    } else {
        
        cell.ranking = self.rankingList[indexPath.row];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [UIView new];
}

#pragma mark - UIScrollViewDelgate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offsetY = scrollView.contentOffset.y;
    
    CGFloat scale = 0;
    
    if (scrollView.contentOffset.y < 0) {
        // 高度拉伸
        CGFloat imgH = kHeaderViewHeight - offsetY;
        CGFloat imgW = kScreenWidth;
        
        UIView *imgView = [self.superview viewWithTag:1500];
        
        imgView.frame = CGRectMake(offsetY * scale, 0, imgW, imgH);
        
    }
    
    NSLog(@"%lf",offsetY);
}

@end

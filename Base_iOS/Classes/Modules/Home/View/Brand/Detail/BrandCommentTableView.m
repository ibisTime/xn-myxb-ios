//
//  BrandCommentTableView.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/26.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BrandCommentTableView.h"
//Category
#import "UIButton+EnLargeEdge.h"
#import "UIControl+Block.h"
//V
#import "BrandCommentCell.h"

@interface BrandCommentTableView()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation BrandCommentTableView

//
static NSString *commentCellID = @"BrandCommentCell";

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    if (self = [super initWithFrame:frame style:style]) {
        
        self.dataSource = self;
        self.delegate = self;
        //评论
        [self registerClass:[BrandCommentCell class] forCellReuseIdentifier:commentCellID];
    }
    
    return self;
}

#pragma mark - UITableViewDataSource;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.commentList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BrandCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:commentCellID forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.comment = self.commentList[indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CommentModel *comment = self.commentList[indexPath.row];
    
    return comment.commentHeight;
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

@end

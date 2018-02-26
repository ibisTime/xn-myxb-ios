//
//  BrandDetailTableView.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/22.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BrandDetailTableView.h"
//
#import "UIButton+EnLargeEdge.h"
#import "UIControl+Block.h"
//V
#import "BrandCommentCell.h"
#import "UIView+Responder.h"
//C
#import "BrandCommentListVC.h"

@interface BrandDetailTableView()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation BrandDetailTableView

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
    
    return 52;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    BaseWeakSelf;
    
    UIView *headerSectionView = [[UIView alloc] init];
    
    if (!_detailModel) {
        
        return headerSectionView;
    }
    
    //topLine
    UIView *topLine = [[UIView alloc] init];
    
    topLine.backgroundColor = kBackgroundColor;
    
    [headerSectionView addSubview:topLine];
    
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.top.equalTo(@0);
        make.height.equalTo(@10);
        
    }];
    
    UIView *whiteView = [[UIView alloc] init];
    
    whiteView.backgroundColor = kWhiteColor;
    
    [headerSectionView addSubview:whiteView];
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@0);
        make.top.equalTo(@10);
        make.width.equalTo(@(kScreenWidth));
        make.height.equalTo(@42);
    }];

    //评分
    UIView *starView = [[UIView alloc] init];
    
    [whiteView addSubview:starView];
    [starView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@(15));
        make.centerY.equalTo(@0);
        make.width.equalTo(@105);
    }];
    //星星
    for (int i = 0; i < 5; i++) {
        
        CGFloat x = i*22.5;
        CGFloat w = 15;
        
        UIImageView *iv = [[UIImageView alloc] init];
        
        iv.image = i < _detailModel.average ? kImage(@"big_star_select"): kImage(@"big_star_unselect");
        
        [starView addSubview:iv];
        [iv mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(@(x));
            make.width.height.equalTo(@(w));
            make.centerY.equalTo(@0);
        }];
    }
    //text
    UILabel *textLbl = [UILabel labelWithBackgroundColor:kClearColor
                                               textColor:[UIColor colorWithHexString:@"#ffbe00"]
                                                    font:14.0];
    
    textLbl.text = [NSString stringWithFormat:@"%.1lf 星", _detailModel.average];
    
    [whiteView addSubview:textLbl];
    [textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(starView.mas_centerY);
        make.left.equalTo(starView.mas_right).offset(10);
    }];
    //箭头
    UIImageView *arrowIV = [[UIImageView alloc] initWithImage:kImage(@"更多-灰色")];
    
    [whiteView addSubview:arrowIV];
    [arrowIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(@(-15));
        make.centerY.equalTo(@0);
    }];
    //评论
    UIButton *commentBtn = [UIButton buttonWithTitle:@""
                                          titleColor:kTextColor
                                     backgroundColor:kClearColor
                                           titleFont:12.0];
    
    [commentBtn setTitle:[NSString stringWithFormat:@"%ld条评论",_detailModel.totalCount] forState:UIControlStateNormal];
    
    [commentBtn setEnlargeEdge:10];
    [commentBtn bk_addEventHandler:^(id sender) {
        
        BrandCommentListVC *commentListVC = [BrandCommentListVC new];
        
        commentListVC.code = self.code;
        
        [weakSelf.viewController.navigationController pushViewController:commentListVC animated:YES];
        
    } forControlEvents:UIControlEventTouchUpInside];
    
    [whiteView addSubview:commentBtn];
    [commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(arrowIV.mas_left).offset(-13);
        make.centerY.equalTo(@0);
    }];
    
    //bottomLine
    UIView *bottomLine = [[UIView alloc] init];
    
    bottomLine.backgroundColor = kLineColor;
    
    [whiteView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.equalTo(@0);
        make.height.equalTo(@0.5);
        
    }];
    
    return headerSectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [UIView new];
}

@end

//
//  AppointmentDetailTableView.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/10.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "AppointmentDetailTableView.h"

//Category
#import "UIButton+EnLargeEdge.h"
#import "UIControl+Block.h"
#import "UIView+Responder.h"
//V
#import "BrandCommentCell.h"
#import "AppointmentTripCell.h"
#import "AppointmentCalendarCell.h"
#import "DetailWebView.h"
//C
#import "BrandCommentListVC.h"

@interface AppointmentDetailTableView()<UITableViewDelegate, UITableViewDataSource>
//图文详情
@property (nonatomic, strong) UITableViewHeaderFooterView *footerView;
@property (nonatomic, strong) DetailWebView *detailWebView;

@end

@implementation AppointmentDetailTableView
//
static NSString *commentCellID = @"BrandCommentCell";
//
static NSString *tripCellID = @"AppointmentTripCell";
//
static NSString *calendarCellID = @"AppointmentCalendarCell";

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    if (self = [super initWithFrame:frame style:style]) {
        
        self.dataSource = self;
        self.delegate = self;
        
        //评论
        [self registerClass:[BrandCommentCell class] forCellReuseIdentifier:commentCellID];
        //行程
        [self registerClass:[AppointmentTripCell class] forCellReuseIdentifier:tripCellID];
        //日历
        [self registerClass:[AppointmentCalendarCell class] forCellReuseIdentifier:calendarCellID];
        
    }
    
    return self;
}

#pragma mark - UITableViewDataSource;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        if (!self.detailModel.isFold) {
            
            return 1;
        }
        return 2;
    }
    
    return self.commentList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == 0) {
                
                AppointmentTripCell *cell = [tableView dequeueReusableCellWithIdentifier:tripCellID forIndexPath:indexPath];
                
                return cell;
            }
            AppointmentCalendarCell *cell = [tableView dequeueReusableCellWithIdentifier:calendarCellID forIndexPath:indexPath];
            
            cell.appointment = self.detailModel;
            cell.trips = self.trips;
            
            return cell;
        }break;
            
        default:
            break;
    }
    
    BrandCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:commentCellID forIndexPath:indexPath];
        
    cell.comment = self.commentList[indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AppointmentTripCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    if (indexPath.section == 0) {
        
        if (indexPath.row != 0) {
            
            return ;
        }
        
        if (!self.detailModel.isFold) {
            
            //打开折叠
            self.detailModel.isFold = YES;
            //右箭头旋转
            [UIView animateWithDuration:0.2 animations:^{
                
                cell.arrowIV.transform = CGAffineTransformMakeRotation(M_PI);
            }];
            
            //Rows
            NSMutableArray *indexPaths = [NSMutableArray new];
            
            NSIndexPath *insertIndexPath = [NSIndexPath indexPathForRow:1 inSection:indexPath.section];
            [indexPaths addObject:insertIndexPath];
            
            [tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        } else {
            
            //关闭折叠
            self.detailModel.isFold = NO;
            
            //右箭头还原
            [UIView animateWithDuration:0.2 animations:^{
                
                cell.arrowIV.transform = CGAffineTransformIdentity;
                
            }];
            
            //Rows
            NSMutableArray *indexPaths = [NSMutableArray new];
            
            NSIndexPath *insertIndexPath = [NSIndexPath indexPathForRow:1 inSection:indexPath.section];
            [indexPaths addObject:insertIndexPath];
            
            [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            return 42;
        }
        return 300;
    }
    
    return self.commentList[indexPath.row].commentHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 10;
    }
    return 52;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return [UIView new];
    }
    
    BaseWeakSelf;
    
    UIView *headerSectionView = [[UIView alloc] init];
    
    if (!_detailModel) {
        
        return headerSectionView;
    }
    
    //topLine
    UIView *topLine = [[UIView alloc] init];
    
    topLine.backgroundColor = kClearColor;
    
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
        
        commentListVC.code = _detailModel.userId;
        commentListVC.kind = _detailModel.kind;
        
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
    
    if (section == 0) {

        return self.footerView ? self.footerView.height: 92;
    }
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    if (section == 1) {
        
        return [UIView new];
    }
    
    BaseWeakSelf;
    
    static NSString * footerId = @"OrderFooterViewId";

    self.footerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:footerId];
    
    self.footerView.contentView.backgroundColor = kBackgroundColor;
    
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 42)];
    
    whiteView.backgroundColor = kWhiteColor;
    
    [self.footerView addSubview:whiteView];
    //line
    UIView *line = [[UIView alloc] init];
    
    line.backgroundColor = kThemeColor;
    
    [whiteView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@15);
        make.centerY.equalTo(@0);
        make.width.equalTo(@3);
        make.height.equalTo(@13.5);
    }];
    //text
    UILabel *textLbl = [UILabel labelWithBackgroundColor:kClearColor
                        
                                               textColor:kTextColor
                                                    font:14.0];
    
    textLbl.text = @"图文详情";
    [whiteView addSubview:textLbl];
    [textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(line.mas_centerY);
        make.left.equalTo(line.mas_right).offset(10);
    }];
    
    //bottomLine
    UIView *bottomLine = [[UIView alloc] init];
    
    bottomLine.backgroundColor = kLineColor;
    
    [whiteView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.equalTo(@0);
        make.height.equalTo(@0.5);
        
    }];
    
    //图文详情
    self.detailWebView = [[DetailWebView alloc] initWithFrame:CGRectMake(0, whiteView.yy, kScreenWidth, 40)];
    
    self.detailWebView.webViewBlock = ^(CGFloat height) {
        
        [weakSelf setSubViewLayoutWithHeight:height];
    };
    
    [self.detailWebView loadWebWithString:self.detailModel.introduce];
    
    [self.footerView addSubview:self.detailWebView];
    
    return self.footerView;
}

/**
 调整视图高度
 */
- (void)setSubViewLayoutWithHeight:(CGFloat)height {
    
    //
    [self layoutIfNeeded];
    
    self.detailWebView.webView.scrollView.height = height;
    self.detailWebView.height = height;
    
    self.footerView.height = self.detailWebView.yy;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HeaderViewDidLayout" object:nil];
}

@end

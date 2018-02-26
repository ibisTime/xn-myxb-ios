//
//  AppointmentDetailTableView.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/10.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "AppointmentDetailTableView.h"
//V
#import "AppointmentCommentCell.h"
#import "AppointmentTripCell.h"
#import "AppointmentCalendarCell.h"

@interface AppointmentDetailTableView()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation AppointmentDetailTableView
//
static NSString *commentCellID = @"AppointmentCommentCell";
//
static NSString *tripCellID = @"AppointmentTripCell";
//
static NSString *calendarCellID = @"AppointmentCalendarCell";

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    if (self = [super initWithFrame:frame style:style]) {
        
        self.dataSource = self;
        self.delegate = self;
        //评论
        [self registerClass:[AppointmentCommentCell class] forCellReuseIdentifier:commentCellID];
        //行程
        [self registerClass:[AppointmentTripCell class] forCellReuseIdentifier:tripCellID];
        //日历
        [self registerClass:[AppointmentCalendarCell class] forCellReuseIdentifier:calendarCellID];
        
    }
    
    return self;
}

#pragma mark - UITableViewDataSource;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        if (!self.detailModel.isFold) {
            
            return 1;
        }
        return 2;
        
    } else if (section == 1) {
        
        return 1;
    }
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == 0) {
                
                AppointmentTripCell *cell = [tableView dequeueReusableCellWithIdentifier:tripCellID forIndexPath:indexPath];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                return cell;
            }
            AppointmentCalendarCell *cell = [tableView dequeueReusableCellWithIdentifier:calendarCellID forIndexPath:indexPath];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }break;
            
        case 2:
        {
            AppointmentCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:commentCellID forIndexPath:indexPath];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
            
        }break;
            
        default:
            break;
    }
    
    AppointmentCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:commentCellID forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
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
        
    } else if (indexPath.section) {
        
        return self.detailModel.contentHeight;
    }
    return self.detailModel.commentHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
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

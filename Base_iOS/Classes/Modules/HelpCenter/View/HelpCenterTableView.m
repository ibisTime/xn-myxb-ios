//
//  HelpCenterTableView.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/8.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "HelpCenterTableView.h"

//Marco
#import "TLUIHeader.h"
#import "AppColorMacro.h"
//V
#import "HelpCenterCell.h"
#import "HelpCenterAnswerCell.h"

@interface HelpCenterTableView()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation HelpCenterTableView
//一级Cell
static NSString *identifierCell = @"HelpCenterCell";
//二级Cell
static NSString *identifierCell2 = @"HelpCenterAnswerCell";

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    if (self = [super initWithFrame:frame style:style]) {
        
        self.dataSource = self;
        self.delegate = self;
        //一级cell
        [self registerClass:[HelpCenterCell class] forCellReuseIdentifier:identifierCell];
        //二级cell
        [self registerClass:[HelpCenterAnswerCell class] forCellReuseIdentifier:identifierCell2];

    }
    
    return self;
}

#pragma mark - UITableViewDataSource;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.questions.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    QuestionModel *question = self.questions[section];
    
    if (!question.isFold) {
        
        return 1;
    }
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //如果是level==0，就用HelpCenterCell
    NSArray *imgArr = @[@"帮助1", @"帮助2", @"帮助3", @"帮助4"];
    QuestionModel *question = self.questions[indexPath.section];
    
    if (indexPath.row == 0) {
        
        HelpCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.iconIV.image = kImage(imgArr[indexPath.section]);
        cell.question = question;
        
        return cell;
    }
    
    HelpCenterAnswerCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell2 forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.question = question;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    HelpCenterCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    QuestionModel *question = self.questions[indexPath.section];
    
    if (indexPath.row != 0) {
        
        return ;
    }
    
    if (!question.isFold) {
        //打开折叠
        question.isFold = YES;
        //右箭头旋转
        [UIView animateWithDuration:0.2 animations:^{
            
            cell.arrowIV.transform = CGAffineTransformMakeRotation(M_PI);
            
        }];
        cell.line.hidden = YES;

        //Rows
        NSMutableArray *indexPaths = [NSMutableArray new];
        
        NSIndexPath *insertIndexPath = [NSIndexPath indexPathForRow:1 inSection:indexPath.section];
        [indexPaths addObject:insertIndexPath];
        
        [tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        
    }else {
        //关闭折叠
        question.isFold = NO;
        
        //右箭头还原
        [UIView animateWithDuration:0.2 animations:^{
            
            cell.arrowIV.transform = CGAffineTransformIdentity;
            
        }];
        cell.line.hidden = NO;

        //Rows
        NSMutableArray *indexPaths = [NSMutableArray new];
        
        NSIndexPath *insertIndexPath = [NSIndexPath indexPathForRow:1 inSection:indexPath.section];
        [indexPaths addObject:insertIndexPath];
        
        [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return self.questions[indexPath.section].cellHeight;
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

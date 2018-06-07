//
//  WithdrawalTable.m
//  Base_iOS
//
//  Created by zhangfuyu on 2018/6/5.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "WithdrawalTable.h"
#import "IntregalRecordCell.h"

@interface WithdrawalTable ()<UITableViewDelegate,UITableViewDataSource>
@end

@implementation WithdrawalTable
static NSString *identifierCell = @"IntregalRecordCell";

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    if (self = [super initWithFrame:frame style:style]) {
        
        self.dataSource = self;
        self.delegate = self;
        
        self.backgroundColor = kClearColor;
        
        [self registerClass:[IntregalRecordCell class] forCellReuseIdentifier:identifierCell];
        
        if (@available(iOS 11.0, *)) {
            
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    
    return self;
}
#pragma mark - UITableViewDataSource;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;//self.mineGroup.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
//    self.mineGroup.items = self.mineGroup.sections[section];
    
    return self.modelArry.count;//self.mineGroup.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    IntregalRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell];
    if (!cell) {
        cell = [[IntregalRecordCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierCell];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.task = [self.modelArry objectAtIndex:indexPath.row];
//    self.mineGroup.items = self.mineGroup.sections[indexPath.section];
//
//    cell.mineModel = self.mineGroup.items[indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    self.mineGroup.items = self.mineGroup.sections[indexPath.section];
    
//    if (self.mineGroup.items[indexPath.row].action) {
//
//        self.mineGroup.items[indexPath.row].action();
//    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}

@end

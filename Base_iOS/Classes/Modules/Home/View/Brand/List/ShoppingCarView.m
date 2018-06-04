//
//  ShoppingCarView.m
//  Base_iOS
//
//  Created by zhangfuyu on 2018/6/3.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "ShoppingCarView.h"
#import "ShoppCarCell.h"
#import "TLNetworking.h"
#import "TLUser.h"
@interface ShoppingCarView()<UITableViewDelegate, UITableViewDataSource,ShoppCarCellDelegate>

@end
@implementation ShoppingCarView
static NSString *identifierCell = @"ShoppCarCell";

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
        
        [self registerClass:[ShoppCarCell class] forCellReuseIdentifier:identifierCell];
    }
    
    return self;
}
- (void)chouseAll
{
    [self reloadData];
}
#pragma mark - UITableViewDataSource;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.brands.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ShoppCarCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell forIndexPath:indexPath];
    cell.indexpath = indexPath;
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.brandModel = self.brands[indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.refreshDelegate && [self.refreshDelegate respondsToSelector:@selector(refreshTableView:didSelectRowAtIndexPath:)]) {
        
        [self.refreshDelegate refreshTableView:self didSelectRowAtIndexPath:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 140;
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

#pragma  mark - ShoppCarCellDelegate
- (void)chouseThisCellWith:(NSIndexPath *)indexPth
{
    NSMutableArray *chooseArry = [NSMutableArray arrayWithArray:self.brands];
    ShopCarModel *brandModel = chooseArry[indexPth.row];
    brandModel.isChouse = !brandModel.isChouse;
    [chooseArry replaceObjectAtIndex:indexPth.row withObject:brandModel];
    
    self.brands = chooseArry;
    [self reloadRowsAtIndexPaths:@[indexPth] withRowAnimation:UITableViewRowAnimationNone];
    
    if (self.chooseBlock) {
        self.chooseBlock(chooseArry);
    }
    
    
}
- (void)isAddWithThisGoods:(BOOL)isadd withIndexpath:(NSIndexPath *)indexpath
{
    ShopCarModel *brandModel = self.brands[indexpath.row];
    
    if (!isadd) {
        if ([brandModel.quantity integerValue] == 1) {
            return;
        }
    }
    
    TLNetworking *http = [TLNetworking new];
    
    http.showView = self;
    
    http.code = @"805290";
    
    http.parameters[@"productCode"] = brandModel.productCode;
    http.parameters[@"userId"] = [TLUser user].userId;
    
    if (isadd) {
        http.parameters[@"quantity"] = @([brandModel.quantity integerValue] + 1);

    }
    else
    {
        http.parameters[@"quantity"] = @([brandModel.quantity integerValue] - 1);

    }
    
    
    [http postWithSuccess:^(id responseObject) {
        NSInteger quantity ;

        if (isadd) {
            quantity = [brandModel.quantity integerValue] + 1;

        }
        else
        {
            quantity = [brandModel.quantity integerValue] - 1;
        }
        
        brandModel.quantity = [NSNumber numberWithInteger:quantity];
        NSMutableArray *chooseArry = [NSMutableArray arrayWithArray:self.brands];
        [chooseArry replaceObjectAtIndex:indexpath.row withObject:brandModel];
        self.brands = chooseArry;

        [self reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationNone];
        if (self.chooseBlock) {
            self.chooseBlock(chooseArry);
        }

        
    } failure:^(NSError *error) {
        
    }];
}
- (void)deleteThisGoods:(NSIndexPath *)indexPath
{
    
    
}

@end

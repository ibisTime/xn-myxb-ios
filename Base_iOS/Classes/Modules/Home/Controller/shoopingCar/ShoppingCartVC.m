//
//  ShoppingCartVC.m
//  Base_iOS
//
//  Created by zhangfuyu on 2018/6/3.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "ShoppingCartVC.h"
#import "ShoppingCarView.h"
#import "ShopCarModel.h"
#import "CarFootView.h"
#import "ConfirmOrderVC.h"

@interface ShoppingCartVC ()

@property (nonatomic , strong)ShoppingCarView *tableview;
@property (nonatomic , strong)NSMutableArray <ShopCarModel *>*shoopArry;
@property (nonatomic , strong)CarFootView *boummView;
@end

@implementation ShoppingCartVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"购物车";
    [self initTableView];
    [self requestBrandGoods];
    [self.tableview beginRefreshing];

}
#pragma mark - Init

- (void)initTableView {
    
    BaseWeakSelf;

    
    self.boummView = [[CarFootView alloc]initWithFrame:CGRectZero];
    self.boummView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.boummView];
    
    //全选
    self.boummView.ischoose = ^(BOOL isChoose) {
      
        for (ShopCarModel *model in weakSelf.shoopArry) {
            model.isChouse = isChoose;
        }
        
        weakSelf.tableview.brands = weakSelf.shoopArry;
        [weakSelf.tableview reloadData];
        [weakSelf allPrice];
    };
    
    //结算
    self.boummView.confirmorder = ^{
        NSMutableArray *chouseGoArry = [NSMutableArray arrayWithCapacity:0];
        for (ShopCarModel *model in weakSelf.shoopArry) {
            if (model.isChouse) {
                [chouseGoArry addObject:model];
            }
        }
        ConfirmOrderVC *ordervc = [[ConfirmOrderVC alloc]init];
        ordervc.brands = chouseGoArry;
        [weakSelf.navigationController pushViewController:ordervc animated:YES];
    };
    
    
    [self.boummView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-kBottomInsetHeight);
        make.height.equalTo(@40);
    }];
    
    
    self.shoopArry = [NSMutableArray array];
    
    self.tableview = [[ShoppingCarView alloc] initWithFrame:CGRectZero
                                                         style:UITableViewStylePlain];
    
//    self.tableview.refreshDelegate = self;
    
    self.tableview.placeHolderView = [TLPlaceholderView placeholderViewWithImage:@"暂无订单" text:@"暂无订单"];
    self.tableview.chooseBlock = ^(NSMutableArray *arry) {
        weakSelf.shoopArry = [NSMutableArray arrayWithArray:arry];
        [weakSelf allPrice];
    };
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.boummView.mas_top);
    }];
    
}
- (void)allPrice
{
    float priceA = 0.00;
    
    for (ShopCarModel *model in self.shoopArry) {
        
        if (model.isChouse) {
            priceA +=  [[model.product[@"price"]convertToRealMoney] floatValue] *[model.quantity integerValue];

        }
        
    }
    NSString *priceText = [NSString stringWithFormat:@"总计:%.2f",priceA];
    self.boummView.priceA = priceText;
}
#pragma mark - Data
- (void)requestBrandGoods {
    
    BaseWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"805297";
    
    helper.parameters[@"userId"] = [TLUser user].userId;
    helper.isList = YES;
    helper.isCurrency = NO;
    
    helper.tableView = self.tableview;
    
    [helper modelClass:[ShopCarModel class]];
    
    [self.tableview addRefreshAction:^{
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.shoopArry = objs;
            weakSelf.tableview.brands = objs;
            [weakSelf.tableview reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
        
    }];
    
//    [self.tableview addLoadMoreAction:^{
//        
//        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
//            
//            weakSelf.shoopArry = objs;
//            weakSelf.tableview.brands = objs;
//            [weakSelf.tableview reloadData_tl];
//            
//        } failure:^(NSError *error) {
//            
//        }];
//        
//    }];
    
    [self.tableview endRefreshingWithNoMoreData_tl];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

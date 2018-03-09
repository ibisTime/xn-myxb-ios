//
//  IntegralMallVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/22.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "IntegralMallVC.h"
//M
#import "CurrencyModel.h"
//V
#import "IntegralCollectionView.h"
//C
#import "IntegralGoodDetailVC.h"
#import "IntegralOrderVC.h"
#import "IntregalFlowVC.h"
#import "IntegralTaskListVC.h"
#import "HTMLStrVC.h"

@interface IntegralMallVC ()<RefreshCollectionViewDelegate>
//
@property (nonatomic, strong) IntegralCollectionView *collectionView;
//商品列表
@property (nonatomic,strong) NSMutableArray <IntegralModel *>*goods;

@end

@implementation IntegralMallVC

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    //刷新商品
    [self.collectionView beginRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"积分商城";
    
    //商品
    [self initCollectionView];
    //获取商品列表
    [self requestGoodList];
    
}

#pragma mark - 断网操作
- (void)placeholderOperation {
    
    //刷新商品
    [self.collectionView beginRefreshing];
}

#pragma mark - Init

- (void)initCollectionView {
    
    BaseWeakSelf;
    
    //布局对象
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    //
    CGFloat itemWidth = (kScreenWidth - 30)/2.0;
    flowLayout.itemSize = CGSizeMake(itemWidth, itemWidth + 90);
    flowLayout.minimumLineSpacing = 10;
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.collectionView = [[IntegralCollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight) collectionViewLayout:flowLayout];
    
    self.collectionView.refreshDelegate = self;

    [self.view addSubview:self.collectionView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (self.collectionView.headerView) {
            
            self.collectionView.headerView.block = ^(IntegralType integralType) {
                
                [weakSelf integralEventsWithType:integralType];
            };
        }
    });
    

}

#pragma mark - Events
- (void)integralEventsWithType:(IntegralType)integralType {
    
    BaseWeakSelf;
    
    switch (integralType) {
        case IntegralTypeGetIntegral:
        {
            
            HTMLStrVC *htmlVC = [HTMLStrVC new];
            
            htmlVC.type = HTMLTypeIntregalRule;
            
            [self.navigationController pushViewController:htmlVC animated:YES];
        }break;
            
        case IntegralTypeIntegralOrder:
        {
            IntegralOrderVC *orderVC = [IntegralOrderVC new];
            
            [self.navigationController pushViewController:orderVC animated:YES];
        }break;
            
        case IntegralTypeIntegralRecord:
        {
            IntregalFlowVC *flowVC = [IntregalFlowVC new];
            
            flowVC.accountNumber = [TLUser user].jfAccountNumber;
            
            [self.navigationController pushViewController:flowVC animated:YES];
        }break;
            
        default:
            break;
    }
}

#pragma mark - Data
- (void)requestGoodList {
    
    BaseWeakSelf;
    //status： 1 未上架 2 已上架
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    helper.code = @"805285";
    
    helper.parameters[@"status"] = @"2";
    helper.parameters[@"faceKind"] = [TLUser user].kind;
    
    helper.parameters[@"orderColumn"] = @"order_no";
    helper.parameters[@"orderDir"] = @"asc";
    
    [helper modelClass:[IntegralModel class]];
    
    helper.collectionView = self.collectionView;
    
    [self.collectionView addRefreshAction:^{
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.goods = objs;
            
            weakSelf.collectionView.integralGoods = weakSelf.goods;
            //
            [weakSelf.collectionView reloadData_tl];
            //积分
            [weakSelf requestUserInfo];
            
        } failure:^(NSError *error) {
            
        }];
    }];
    
    [self.collectionView addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.goods = objs;

            weakSelf.collectionView.integralGoods = weakSelf.goods;
            
            [weakSelf.collectionView reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
    }];
    
    [self.collectionView endRefreshingWithNoMoreData_tl];
}

- (void)requestUserInfo {
    
    BaseWeakSelf;

    //刷新rmb和积分
    TLNetworking *http = [TLNetworking new];
    http.code = @"805353";
    http.parameters[@"currency"] = kJF;
    http.parameters[@"userId"] = [TLUser user].userId;
    
    [http postWithSuccess:^(id responseObject) {
        
        NSArray <CurrencyModel *> *arr = [CurrencyModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        [arr enumerateObjectsUsingBlock:^(CurrencyModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([obj.currency isEqualToString:kJF]) {
                
                weakSelf.collectionView.headerView.jfNum = [obj.amount convertToRealMoney];
                [weakSelf.collectionView reloadData_tl];
                
                [TLUser user].jfAccountNumber = obj.accountNumber;
            }
        }];
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - RefreshCollectionViewDelegate
- (void)refreshCollectionView:(BaseCollectionView *)refreshCollectionview didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    IntegralModel *good = self.goods[indexPath.row];
    
    IntegralGoodDetailVC *detailVC = [IntegralGoodDetailVC new];
    
    detailVC.code = good.code;
    
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)refreshCollectionViewButtonClick:(BaseCollectionView *)refreshCollectionView WithButton:(UIButton *)sender SelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    IntegralModel *good = self.goods[indexPath.row];

    IntegralGoodDetailVC *detailVC = [IntegralGoodDetailVC new];
    
    detailVC.code = good.code;

    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

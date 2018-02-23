//
//  IntegralMallVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/22.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "IntegralMallVC.h"
//Macro
//Framework
//Category
//Extension
//M
//V
#import "IntegralCollectionView.h"
//C
#import "IntegralGoodDetailVC.h"
#import "IntegralOrderVC.h"

@interface IntegralMallVC ()<RefreshCollectionViewDelegate>
//
@property (nonatomic, strong) IntegralCollectionView *collectionView;
//商品列表
@property (nonatomic,strong) NSMutableArray <IntegralModel *>*goods;

@end

@implementation IntegralMallVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"积分商城";
    
    //添加下拉刷新
    [self addDownRefresh];
    //商品
    [self initCollectionView];
    //获取商品列表
    [self requestGoodList];
}

#pragma mark - 断网操作
- (void)placeholderOperation {
    
    //获取商品列表
    [self requestGoodList];
}

#pragma mark - Init
- (void)addDownRefresh {
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(clickRefresh)];
    
    self.collectionView.mj_header = header;
}

- (void)initCollectionView {
    
    BaseWeakSelf;
    
    //布局对象
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    //
    CGFloat itemWidth = (kScreenWidth - 30)/2.0;
    flowLayout.itemSize = CGSizeMake(itemWidth, itemWidth + 60);
    flowLayout.minimumLineSpacing = 10;
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 0, 10);
    
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.collectionView = [[IntegralCollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight) collectionViewLayout:flowLayout];
    
    self.collectionView.refreshDelegate = self;
    
    [self.view addSubview:self.collectionView];
    
    [self.collectionView.headerView changeInfo];

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
    
    switch (integralType) {
        case IntegralTypeGetIntegral:
        {
                
        }break;
            
        case IntegralTypeIntegralOrder:
        {
            IntegralOrderVC *orderVC = [IntegralOrderVC new];
            
            [self.navigationController pushViewController:orderVC animated:YES];
        }break;
            
        case IntegralTypeIntegralRecord:
        {
            
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
//    helper.parameters[@"orderColumn"] = @"update_datetime";
//    helper.parameters[@"orderDir"] = @"asc";
    
    [helper modelClass:[IntegralModel class]];
    
    [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
        
        weakSelf.goods = objs;
        
        weakSelf.collectionView.integralGoods = objs;
        
        [weakSelf.collectionView reloadData];
        
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

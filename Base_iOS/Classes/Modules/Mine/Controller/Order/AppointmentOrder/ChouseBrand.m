//
//  ChouseBrand.m
//  Base_iOS
//
//  Created by zhangfuyu on 2018/6/6.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "ChouseBrand.h"
#import "HomeCollectionView.h"
#import "BrandModel.h"

@interface ChouseBrand ()
@property (nonatomic, strong) HomeCollectionView *collectionView;
//品牌列表
@property (nonatomic,strong) NSMutableArray <BrandModel *>*brands;

@end

@implementation ChouseBrand

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"选择品牌";
    //品牌列表
    [self initCollectionView];
    
    [self requestBrandList];
    
    [self.collectionView beginRefreshing];

}
#pragma mark - Init

- (void)initCollectionView {
    
    BaseWeakSelf;
    
    //布局对象
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    //
    CGFloat itemWidth = (kScreenWidth - 30)/2.0;
    flowLayout.itemSize = CGSizeMake(itemWidth, itemWidth + 58);
    flowLayout.minimumLineSpacing = 10;
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;

    
    self.collectionView = [[HomeCollectionView alloc] initNoheaderWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight) collectionViewLayout:flowLayout];
    
    self.collectionView.homeBlock = ^(NSIndexPath *indexPath) {
        
        BrandModel *good = weakSelf.brands[indexPath.row];

        if (weakSelf.brand) {
            weakSelf.brand(good);

        }
        [weakSelf.navigationController popViewControllerAnimated:YES];
        
    };
    
    [self.view addSubview:self.collectionView];
    
    
}
- (void)requestBrandList {
    
    BaseWeakSelf;
    //location： 0 普通列表 1 推荐列表
    //status:TO_Shelf("1", "未上架"), Shelf_YES("2", "已上架"), Shelf_NO("3", "已下架");
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"805256";
    helper.showView = self.view;
    helper.parameters[@"location"] = @"1";
    helper.parameters[@"status"] = @"2";
    helper.parameters[@"orderColumn"] = @"order_no";
    helper.parameters[@"orderDir"] = @"asc";
    
    helper.collectionView = self.collectionView;
    
    [helper modelClass:[BrandModel class]];
    
    [self.collectionView addRefreshAction:^{
        
        //店铺数据
        [helper refresh:^(NSMutableArray <BrandModel *>*objs, BOOL stillHave) {
            
            weakSelf.brands = objs;
            
            weakSelf.collectionView.brands = objs;
            
            [weakSelf.collectionView reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
    }];
    
    [self.collectionView addLoadMoreAction:^{
        //店铺数据
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.brands = objs;
            
            weakSelf.collectionView.brands = objs;
            
            [weakSelf.collectionView reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
    }];
    
    [self.collectionView endRefreshingWithNoMoreData_tl];
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

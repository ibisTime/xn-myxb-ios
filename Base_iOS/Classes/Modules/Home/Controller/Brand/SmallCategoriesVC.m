//
//  SmallCategoriesVC.m
//  Base_iOS
//
//  Created by zhangfuyu on 2018/6/14.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "SmallCategoriesVC.h"
#import "BrandModel.h"
#import "SelectScrollView.h"
#import "BrandListVC.h"
@interface SmallCategoriesVC ()
@property (nonatomic,strong) NSMutableArray <BrandModel *>*brands;
@property (nonatomic, strong) SelectScrollView *selectScrollView;

@end

@implementation SmallCategoriesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self requeseList];
    
}
- (void)requeseList
{
    BaseWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"805256";
    
    helper.parameters[@"location"] = @"1";
    helper.parameters[@"status"] = @"2";
    helper.parameters[@"orderColumn"] = @"order_no";
    helper.parameters[@"orderDir"] = @"asc";
    helper.parameters[@"categoryCode"] = self.code;

    
    [helper modelClass:[BrandModel class]];
    
    
        //店铺数据
    [helper refresh:^(NSMutableArray <BrandModel *>*objs, BOOL stillHave) {
        
        weakSelf.brands = objs;
        
        [self initSelectScrollView];
        [self addSubViewController];
        
        
    } failure:^(NSError *error) {
        
    }];
    
}

#pragma mark - Init
- (void)initSelectScrollView {
    
    NSMutableArray *titles = [NSMutableArray array];
    
    [self.brands enumerateObjectsUsingBlock:^(BrandModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [titles addObject:obj.name];
        
        
        
    }];
    
    self.selectScrollView = [[SelectScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight)
                                                         itemTitles:titles];
    
    [self.view addSubview:self.selectScrollView];
}
- (void)addSubViewController {
    

    for (NSInteger i = 0; i < self.brands.count; i++) {
    
        BrandModel *model = self.brands[i];

        BrandListVC *childVC = [[BrandListVC alloc] init];

        childVC.descriptionStr = model.desc;

        childVC.brandCode = model.code;

        childVC.view.frame = CGRectMake(kScreenWidth*i, 1, kScreenWidth, kSuperViewHeight - 40 - 40);

        [self addChildViewController:childVC];

        [_selectScrollView.scrollView addSubview:childVC.view];
    
    }
    
    
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

//
//  HomeVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/5.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "HomeVC.h"

//Manager
#import "AppConfig.h"
//Extension
#import "MJRefresh.h"
//M
#import "BannerModel.h"
#import "NoticeModel.h"
#import "BrandModel.h"
//V
#import "TLBannerView.h"
#import "LoopScrollView.h"
#import "CategoryItem.h"
#import "HomeCollectionView.h"
//C
#import "WebVC.h"
#import "SystemNoticeVC.h"
#import "AppointmentListVC.h"
#import "BrandVC.h"
#import "BrandListVC.h"
#import "GoodNewsVC.h"
#import "RankingListVC.h"

@interface HomeVC ()<UIScrollViewDelegate>
//
@property (nonatomic, strong) HomeCollectionView *collectionView;
//品牌列表
@property (nonatomic,strong) NSMutableArray <BrandModel *>*brands;
//
@property (nonatomic,strong) NSMutableArray <BannerModel *>*bannerRoom;
//系统消息
@property (nonatomic,strong) NSMutableArray <NoticeModel *>*notices;

@end

@implementation HomeVC

#pragma mark - Life Cycle
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    //系统消息
    [self requestNoticeList];
    //获取商品列表
    [self requestBrandList];
    //获取banner列表
    [self requestBannerList];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"首页";
    
    //添加下拉刷新
    [self addDownRefresh];
    //品牌列表
    [self initCollectionView];
}

#pragma mark - 断网操作
- (void)placeholderOperation {
    
    //系统消息
    [self requestNoticeList];
    //获取商品列表
    [self requestBrandList];
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
    CGFloat itemWidth = (kScreenWidth - 10)/2.0;
    flowLayout.itemSize = CGSizeMake(itemWidth, itemWidth + 68);
    flowLayout.minimumLineSpacing = 10;
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 0, 0, 0);
    
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.collectionView = [[HomeCollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight - kTabBarHeight) collectionViewLayout:flowLayout];
    
    self.collectionView.homeBlock = ^(NSIndexPath *indexPath) {
        
        BrandModel *good = weakSelf.brands[indexPath.row];
        
        BrandListVC *listVC = [BrandListVC new];
        
        listVC.title = good.name;
        listVC.brandCode = good.code;
        
        [weakSelf.navigationController pushViewController:listVC animated:YES];
    };
    
    [self.view addSubview:self.collectionView];
    
    [self.collectionView reloadData];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (self.collectionView.headerView) {
            
            self.collectionView.headerView.headerBlock = ^(HomeEventsType type, NSInteger index) {
                
                [weakSelf headerViewEventsWithType:type index:index];
            };
        }
    });
    
}

#pragma mark - Events
- (void)clickRefresh {
    
    //获取商品列表
    [self requestBrandList];
}

#pragma mark - Data
- (void)requestNoticeList {
    
    BaseWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"804040";
    if ([TLUser user].token) {
        
        helper.parameters[@"token"] = [TLUser user].token;
    }
    helper.parameters[@"channelType"] = @"4";
    
    helper.parameters[@"pushType"] = @"41";
    helper.parameters[@"toKind"] = @"C";    //C端
    //    1 立即发 2 定时发
    //    pageDataHelper.parameters[@"smsType"] = @"1";
    helper.parameters[@"start"] = @"1";
    helper.parameters[@"limit"] = @"20";
    helper.parameters[@"status"] = @"1";
    helper.parameters[@"fromSystemCode"] = [AppConfig config].systemCode;
    
    [helper modelClass:[NoticeModel class]];
    
    //消息数据
    [helper refresh:^(NSMutableArray <NoticeModel *>*objs, BOOL stillHave) {
        
        [weakSelf removePlaceholderView];
        
        weakSelf.collectionView.headerView.notices = objs;
        
    } failure:^(NSError *error) {
        
        [weakSelf addPlaceholderView];

    }];
    
}

- (void)requestBrandList {
    
    BaseWeakSelf;
    //location： 0 普通列表 1 推荐列表
    //status:TO_Shelf("1", "未上架"), Shelf_YES("2", "已上架"), Shelf_NO("3", "已下架");
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"805256";
    
    helper.parameters[@"location"] = @"1";
    helper.parameters[@"status"] = @"2";
    helper.parameters[@"orderColumn"] = @"order_no";
    helper.parameters[@"orderDir"] = @"asc";
    
    [helper modelClass:[BrandModel class]];
    
    //店铺数据
    [helper refresh:^(NSMutableArray <BrandModel *>*objs, BOOL stillHave) {
        
        weakSelf.brands = objs;
        
        weakSelf.collectionView.brands = objs;
        
        [weakSelf.collectionView reloadData];
        
    } failure:^(NSError *error) {
    
    }];
    
}

- (void)requestBannerList {
    
    BaseWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"805806";
    helper.isList = YES;
    helper.parameters[@"location"] = @"index_banner";
    helper.parameters[@"type"] = @"2";
    
    [helper modelClass:[BannerModel class]];
    
    //店铺数据
    [helper refresh:^(NSMutableArray <BannerModel *>*objs, BOOL stillHave) {
        
        weakSelf.bannerRoom = objs;
        weakSelf.collectionView.headerView.banners = objs;
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - HeaderEvents
- (void)headerViewEventsWithType:(HomeEventsType)type index:(NSInteger)index {
    
    switch (type) {
        case HomeEventsTypeBanner:
        {
            BannerModel *banner = self.bannerRoom[index];
            
            switch ([banner.kind integerValue]) {
                case 1:
                {
                    if (!(banner.url && banner.url.length > 0)) {
                        return ;
                    }
                    
                    WebVC *webVC = [WebVC new];
                    webVC.url = banner.url;
                    [self.navigationController pushViewController:webVC animated:YES];
                    
                }break;
                    
                case 2:
                case 3:
                {
                    GoodNewsVC *newsVC = [GoodNewsVC new];
                    
                    newsVC.type = banner.kind;
                    
                    [self.navigationController pushViewController:newsVC animated:YES];
                }break;
                    
                case 4:
                case 5:
                case 6:
                {
                    RankingListVC *rankVC = [RankingListVC new];
                    
                    rankVC.type = banner.kind;
                    
                    [self.navigationController pushViewController:rankVC animated:YES];
                }break;
                    
                default:
                    break;
            }

            
            
        }break;
            
        case HomeEventsTypeNotice:
        {
            SystemNoticeVC *noticeVC = [SystemNoticeVC new];
            
            [self.navigationController pushViewController:noticeVC animated:YES];
            
        }break;
            
        case HomeEventsTypeCategory:
        {
            NSString *title = @"";
            NSString *type = @"";
            
            switch (index) {
                case 0:
                {
                    title = @"品牌下单";
                }break;
                    
                case 1:
                {
                    title = @"美导预约";
                    type = kUserTypeBeautyGuide;
                }break;
                    
                case 2:
                {
                    title = @"讲师预约";
                    type = kUserTypeLecturer;
                }break;
                    
                case 3:
                {
                    title = @"专家预约";
                    type = kUserTypeExpert;
                }break;
                    
                default:
                    break;
            }
            
            if (index > 0) {
                
                AppointmentListVC *appointmentListVC = [AppointmentListVC new];
                
                appointmentListVC.title = title;
                appointmentListVC.userType = type;
                
                [self.navigationController pushViewController:appointmentListVC animated:YES];
                
                return ;
            }
            
            BrandVC *brandVC = [BrandVC new];
            
            brandVC.title = title;
            
            [self.navigationController pushViewController:brandVC animated:YES];

        }break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

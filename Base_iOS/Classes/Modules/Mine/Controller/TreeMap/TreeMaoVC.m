//
//  TreeMaoVC.m
//  Base_iOS
//
//  Created by zhangfuyu on 2018/6/6.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "TreeMaoVC.h"

#import "TreeMacModel.h"

#import "TreeTableView.h"
#import "TLUser.h"


@interface TreeMaoVC ()

@property (nonatomic , strong)NSMutableArray *treeMapArry;

//@property (nonatomic , strong)TLTableView *tableview;
@end

@implementation TreeMaoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"网络图谱";
    self.treeMapArry = [NSMutableArray arrayWithCapacity:0];
    
    
    
    [self requestTreeMap];
}
- (void)requestTreeMap
{
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"805146";
    http.parameters[@"userId"] = [TLUser user].userId;
   
    
    [http postWithSuccess:^(id responseObject) {
        
        NSLog(@"----->%@",responseObject);
        
        if ([[TLUser user].kind isEqualToString:kUserTypePartner] || [[TLUser user].kind isEqualToString:kUserTypeBeautyGuide])
        {
            NSDictionary *data = responseObject[@"data"];
           
            if ([[TLUser user].kind isEqualToString:kUserTypeBeautyGuide]) {
                NSMutableArray *mgJxsListArry = [TreeMacModel mj_objectArrayWithKeyValuesArray:data[@"mgJxsList"]];
                [self FwtTeamWithArry:mgJxsListArry];
            }
            
            NSMutableArray *jingxiaoshang = [TreeMacModel mj_objectArrayWithKeyValuesArray:data[@"lineList"]];
            [self groupingHHRWithArry:jingxiaoshang];
            
        }
        else
        {
            NSArray *dataArru = responseObject[@"data"];
            NSMutableArray *modelArry = [TreeMacModel mj_objectArrayWithKeyValuesArray:dataArru];
            
            [self groupingWithArry:modelArry];
        }
        
        
    } failure:^(NSError *error) {
        
    }];
}
- (void)groupingWithArry:(NSMutableArray *)arry
{
    
    
//    [[NSUserDefaults standardUserDefaults] setObject:userInfo forKey:USER_INFO_DICT_KEY];
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_info_dict_key"];
    
    TreeMacModel *titleModel = [[TreeMacModel alloc]init];
    titleModel.realName = @"有效推荐码";
    titleModel.ShowLinview = YES;
    titleModel.parentId = -1;
    titleModel.nodeId = 1;
    titleModel.depth = 0;
    titleModel.expand = YES;
    titleModel.peopleNumberl = [[NSString stringWithFormat:@"%@",dic[@"maxNumber"]] integerValue];
    [self.treeMapArry addObject:titleModel];
    
    
    for (NSInteger index = 0; index < arry.count; index ++) {
        TreeMacModel *model = [arry objectAtIndex:index];
        model.parentId = titleModel.nodeId;
        model.nodeId = titleModel.nodeId * 100 + index;
        model.depth = titleModel.depth + 1;
        model.expand = YES;
        [self.treeMapArry addObject:model];
        
        NSMutableArray *twoArry = [TreeMacModel mj_objectArrayWithKeyValuesArray:model.jxsList];
        
        
        for (NSInteger indexTwo = 0; indexTwo < twoArry.count; indexTwo ++) {
            TreeMacModel *submodel = [twoArry objectAtIndex:indexTwo];
            submodel.parentId = model.nodeId;
            submodel.nodeId = model.nodeId * 1000 + indexTwo;
            submodel.depth = model.depth + 1;
            submodel.expand = YES;

            [self.treeMapArry addObject:submodel];
        }
        
    }
    [self initTableView];
}

- (void)groupingHHRWithArry:(NSMutableArray *)arry
{
    
    
    for (NSInteger oneIndex = 0; oneIndex < arry.count; oneIndex ++) {
        
        TreeMacModel *firtModel = [arry objectAtIndex:oneIndex];
        firtModel.realName = @"1级服务团队";
        firtModel.ShowLinview = YES;
        firtModel.parentId = -1;
        firtModel.nodeId = 1;
        firtModel.depth = 0;
        firtModel.expand = YES;
        [self.treeMapArry addObject:firtModel];
        
        NSArray *modelArry = [TreeMacModel mj_objectArrayWithKeyValuesArray:firtModel.fwsList];
        
        for (NSInteger oneIndexFirst = 0; oneIndexFirst < modelArry.count; oneIndexFirst ++) {
            TreeMacModel *oneIndexModel = [modelArry objectAtIndex:oneIndexFirst];
            oneIndexModel.parentId = firtModel.nodeId;
            oneIndexModel.nodeId = firtModel.nodeId * 10 + oneIndexFirst;
            oneIndexModel.depth = firtModel.depth + 1;
            oneIndexModel.expand = NO;
            [self.treeMapArry addObject:oneIndexModel];
            
            NSArray *oneIndexModelArry = [TreeMacModel mj_objectArrayWithKeyValuesArray:oneIndexModel.fwsList];
            
            if (oneIndexModelArry.count != 0) {
                TreeMacModel *oneIndexModelSecond = [[TreeMacModel alloc]init];
                oneIndexModelSecond.realName = @"2级服务团队";
                oneIndexModelSecond.ShowLinview = YES;
                oneIndexModelSecond.parentId = oneIndexModel.nodeId;
                oneIndexModelSecond.nodeId = oneIndexModel.nodeId * 10;
                oneIndexModelSecond.depth = oneIndexModel.depth + 1;;
                oneIndexModelSecond.expand = NO;
                [self.treeMapArry addObject:oneIndexModelSecond];
                
                for (NSInteger oneIndexModelIndex = 0; oneIndexModelIndex < oneIndexModelArry.count; oneIndexModelIndex ++) {
                    TreeMacModel *oneIndexModelIndexModel = [oneIndexModelArry objectAtIndex:oneIndexModelIndex];
                    oneIndexModelIndexModel.parentId = oneIndexModelSecond.nodeId;
                    oneIndexModelIndexModel.nodeId = oneIndexModelSecond.nodeId * 10 +oneIndexModelIndex;
                    oneIndexModelIndexModel.depth = oneIndexModelSecond.depth + 1;
                    oneIndexModelIndexModel.expand = NO;
                    [self.treeMapArry addObject:oneIndexModelIndexModel];
                    
                    //经销商
                    NSArray *oneIndexModelIndexModelMGJxsList = [TreeMacModel mj_objectArrayWithKeyValuesArray:oneIndexModelIndexModel.mgJxsList];
                    
                    if (oneIndexModelIndexModelMGJxsList.count != 0) {
                        TreeMacModel *MGJxsListModel = [[TreeMacModel alloc]init];
                        MGJxsListModel.realName = @"经销商";
                        MGJxsListModel.ShowLinview= YES;
                        MGJxsListModel.parentId = oneIndexModelIndexModel.nodeId;
                        MGJxsListModel.nodeId = oneIndexModelIndexModel.nodeId *10;
                        MGJxsListModel.depth = oneIndexModelIndexModel.depth + 1;
                        MGJxsListModel.expand = NO;
                        [self.treeMapArry addObject:MGJxsListModel];
                        
                        for (NSInteger mgJxsListIndex = 0; mgJxsListIndex < oneIndexModelIndexModelMGJxsList.count; mgJxsListIndex ++) {
                            TreeMacModel *MGJxsListSubModel = [oneIndexModelIndexModelMGJxsList objectAtIndex:mgJxsListIndex];
                            MGJxsListSubModel.parentId = MGJxsListModel.nodeId;
                            MGJxsListSubModel.nodeId = MGJxsListModel.nodeId * 10 + mgJxsListIndex;
                            MGJxsListSubModel.depth = MGJxsListModel.depth + 1;
                            MGJxsListSubModel.expand = NO;
                            [self.treeMapArry addObject:MGJxsListSubModel];


                        }

                    }
                    
                    
                    
                    
                }
            }
            
            
           NSArray *oneMgJxsListArry = [TreeMacModel mj_objectArrayWithKeyValuesArray:oneIndexModel.mgJxsList];
            if (oneMgJxsListArry.count != 0) {
                TreeMacModel *mgjxListModel= [[TreeMacModel alloc]init];
                mgjxListModel.realName = @"经销商";
                mgjxListModel.ShowLinview = YES;
                mgjxListModel.parentId = oneIndexModel.nodeId;
                mgjxListModel.nodeId = oneIndexModel.nodeId * 10 + 1;
                mgjxListModel.depth = oneIndexModel.depth + 1;;
                mgjxListModel.expand = NO;
                [self.treeMapArry addObject:mgjxListModel];
                
                
                for (NSInteger mgJxsListIndex = 0; mgJxsListIndex < oneMgJxsListArry.count; mgJxsListIndex ++) {
                    TreeMacModel *MGJxsListSubModel = [oneMgJxsListArry objectAtIndex:mgJxsListIndex];
                    MGJxsListSubModel.parentId = mgjxListModel.nodeId;
                    MGJxsListSubModel.nodeId = mgjxListModel.nodeId * 10 + mgJxsListIndex;
                    MGJxsListSubModel.depth = mgjxListModel.depth + 1;
                    MGJxsListSubModel.expand = NO;
                    [self.treeMapArry addObject:MGJxsListSubModel];
                    
                    
                }
            }
            
        }
    }
        
    [self initTableView];
    
}
- (void)FwtTeamWithArry:(NSMutableArray *)arry
{
    if ([[TLUser user].kind isEqualToString:kUserTypeBeautyGuide]) {
        
        if (arry.count == 0) {
            return;
        }
        
        TreeMacModel *mgjxListModel= [[TreeMacModel alloc]init];
        mgjxListModel.realName = @"经销商";
        mgjxListModel.ShowLinview = YES;
        mgjxListModel.parentId = -1;
        mgjxListModel.nodeId = 100;
        mgjxListModel.depth = 0;
        mgjxListModel.expand = YES;
        [self.treeMapArry addObject:mgjxListModel];
        
        for (NSInteger mgJxsListIndex = 0; mgJxsListIndex < arry.count; mgJxsListIndex ++) {
            TreeMacModel *MGJxsListSubModel = [arry objectAtIndex:mgJxsListIndex];
            MGJxsListSubModel.parentId = mgjxListModel.nodeId;
            MGJxsListSubModel.nodeId = mgjxListModel.nodeId * 10 + mgJxsListIndex;
            MGJxsListSubModel.depth = mgjxListModel.depth + 1;
            MGJxsListSubModel.expand = NO;
            [self.treeMapArry addObject:MGJxsListSubModel];
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initTableView {
    
    
    TreeTableView *tableview = [[TreeTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight - kBottomInsetHeight) withData:self.treeMapArry];
//    tableview.treeTableCellDelegate = self;
    [self.view addSubview:tableview];
    
    if ([[TLUser user].kind isEqualToString:kUserTypePartner]) {
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
        headerView.backgroundColor = [UIColor whiteColor];
        
        UIButton *imageBtn = [UIButton buttonWithImageName:@"白金"];
        [headerView addSubview:imageBtn];
        [imageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(@0);
            make.left.equalTo(@0);
            make.width.equalTo(@50);
        }];
        
        UILabel *vipTypeLabel = [UILabel labelWithBackgroundColor:kClearColor textColor:kBlackColor font:16];
        vipTypeLabel.text = @"白金";
        [headerView addSubview:vipTypeLabel];
        
        [vipTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imageBtn.mas_right);
            make.top.bottom.equalTo(@0);
        }];
        
        UIView *linvew = [[UIView alloc]init];
        linvew.backgroundColor = kSilverGreyColor;
        [headerView addSubview:linvew];
        
        [linvew mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(@0);
            make.height.equalTo(@.5);
        }];

        tableview.tableHeaderView = headerView;
        
        
    }
    
//    self.tableview = [TLTableView tableViewWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight - kBottomInsetHeight)
//                                                    delegate:self
//                                                  dataSource:self];
//
//    [self.view addSubview:self.tableview];
    
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

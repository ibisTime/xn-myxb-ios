//
//  ZHAddressChooseVC.m
//  ZHCustomer
//
//  Created by  蔡卓越 on 2016/12/29.
//  Copyright © 2016年  caizhuoyue. All rights reserved.
//

#import "ZHAddressChooseVC.h"
#import "ZHAddressCell.h"
#import "ZHAddAddressVC.h"

#import "TLPlaceholderView.h"

@interface ZHAddressChooseVC ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic,strong) TLTableView *addressTableView;

@property (nonatomic,strong) NSMutableArray <ZHReceivingAddress *>*addressRoom;

@property (nonatomic, strong) UIButton *addBtn;

@end

@implementation ZHAddressChooseVC

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    if (!self.addressRoom) {
        
        [self.addressTableView beginRefreshing];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"收货地址";
    TLTableView *addressTableView = [TLTableView tableViewWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight - kTabBarHeight) delegate:self dataSource:self];
    [self.view addSubview:addressTableView];
    self.addressTableView = addressTableView;
    addressTableView.placeHolderView = [TLPlaceholderView placeholderViewWithText:@"暂无收货地址"];
    
    [addressTableView addRefreshAction:^{
        
        TLNetworking *http = [TLNetworking new];
        http.code = @"805165";
        http.parameters[@"userId"] = [TLUser user].userId;
        http.parameters[@"token"] = [TLUser user].token;
        //    http.parameters[@"isDefault"] = @"0"; //是否为默认收货地址
        [http postWithSuccess:^(id responseObject) {
            
            [self.addressTableView endRefreshHeader];
            
            NSArray *adderssRoom = responseObject[@"data"];
            
            self.addressRoom = [ZHReceivingAddress tl_objectArrayWithDictionaryArray:adderssRoom];
            
            if (self.addressRoom.count == 0) {
                
                [self initAddBtn];
                
            }
            
            if (self.selectedAddrCode) {
                [self.addressRoom enumerateObjectsUsingBlock:^(ZHReceivingAddress * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj.code isEqualToString:self.selectedAddrCode]) {
                        
                        obj.isSelected = YES;
                    }
                    
                }];
            }
            
            
            [self.addressTableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            [self.addressTableView endRefreshHeader];
            
        }];
        
    }];
    
}

- (void)initAddBtn {

    //增加
    UIButton *addBtn = [UIButton buttonWithTitle:@"添加新地址" titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:18.0 cornerRadius:5];
    

    [self.view addSubview:addBtn];
    [addBtn addTarget:self action:@selector(addAddress) forControlEvents:UIControlEventTouchUpInside];
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.left.right.equalTo(self.view);
        make.height.mas_equalTo(@49);
        
    }];
    
    self.addBtn = addBtn;
}

- (void)addAddress {
    
    BaseWeakSelf;
    
    ZHAddAddressVC *address = [[ZHAddAddressVC alloc] init];
    address.addAddress = ^(ZHReceivingAddress *address){
        
        if (self.isDisplay) {//个人主页进入的界面
            
            [weakSelf.addressTableView beginRefreshing];
            
        } else {
            
            address.isSelected = NO;
            //            [self.addressRoom addObject:address];
            [weakSelf.addressTableView beginRefreshing];
            
            
        }
        
    };
    [self.navigationController pushViewController:address animated:YES];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.addressRoom.count;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *zhAddressCellId = @"ZHAddressCellId";
    ZHAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:zhAddressCellId];
    if (!cell) {
        
        cell = [[ZHAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:zhAddressCellId];
        cell.isDisplay = self.isDisplay;
        
        __weak typeof(self) weakSelf = self;
        //        cell.deleteAddr = ^(UITableViewCell *cell){
        //
        //            NSInteger idx = [tableView indexPathForCell:cell].section;
        //            [TLAlert alertWithTitle:nil msg:@"确认删除该收货地址" confirmMsg:@"删除" cancleMsg:@"取消" cancle:^(UIAlertAction *action) {
        //
        //            } confirm:^(UIAlertAction *action) {
        //
        //                TLNetworking *http = [TLNetworking new];
        //                http.showView = self.view;
        //                http.code = @"805161";
        //                http.parameters[@"code"] = weakSelf.addressRoom[idx].code;
        //                http.parameters[@"token"] = [TLUser user].token;
        //                [http postWithSuccess:^(id responseObject) {
        //
        //                    [TLAlert alertWithSucces:@"删除成功"];
        //
        //                    [weakSelf.addressRoom removeObjectAtIndex:idx];
        //                    [weakSelf.addressTableView reloadData_tl];
        //
        //                } failure:^(NSError *error) {
        //
        //                }];
        //
        //
        //            }];
        //
        //        };
        
        cell.editAddr = ^(UITableViewCell *cell){
            
            
            NSInteger idx = [tableView indexPathForCell:cell].section;
            ZHAddAddressVC *editAddVC = [[ZHAddAddressVC alloc] init];
            
            editAddVC.addressType = AddressTypeEdit;
            
            editAddVC.address = weakSelf.addressRoom[idx];
            
            editAddVC.editSuccess = ^(ZHReceivingAddress *addr){
                
                [weakSelf.addressTableView beginRefreshing];
            };
            [weakSelf.navigationController pushViewController:editAddVC animated:YES];
        };
    }
    cell.address = self.addressRoom[indexPath.section];
    return cell;
    
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.isDisplay) {
        
        return;
    }
    
    ZHReceivingAddress *selectedAddr = self.addressRoom[indexPath.section];
    
    if (selectedAddr.isSelected == YES) {
        
        
    } else {
        
        [self.addressRoom enumerateObjectsUsingBlock:^(ZHReceivingAddress *addr, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if (![addr isEqual:selectedAddr]) {
                addr.isSelected = NO;
            }
            
        }];
        selectedAddr.isSelected = YES;
        if (self.chooseAddress) {
            
            self.chooseAddress(selectedAddr);
            
        }
        
    }
    
    
//    [self.navigationController popViewControllerAnimated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (self.addressRoom.count > 0) {
        
        ZHReceivingAddress *address = self.addressRoom[0];

        return address.cellHeight;

    }
    return 120;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section == self.addressRoom.count - 1) {
        
        return 0.1;
    }
    return 10;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.1;
    
}


@end

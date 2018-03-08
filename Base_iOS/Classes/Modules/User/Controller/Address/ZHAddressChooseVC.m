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
    
    self.title = @"地址选择";
    
    [self initAddBtn];
    
    [self initTableView];
    
}

- (void)initAddBtn {
    
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, kSuperViewHeight - 60 - kBottomInsetHeight, kScreenWidth, 60)];
    
    whiteView.backgroundColor = kWhiteColor;
    
    [self.view addSubview:whiteView];
    //增加
    UIButton *addBtn = [UIButton buttonWithTitle:@"添加新地址" titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:18.0 cornerRadius:5];
    [addBtn addTarget:self action:@selector(addAddress) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:addBtn];
    
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.equalTo(@44);
        make.left.equalTo(@15);
        make.centerY.equalTo(@0);
        make.right.equalTo(@(-15));
    }];
    
    self.addBtn = addBtn;
}

- (void)initTableView {
    
    TLTableView *addressTableView = [TLTableView tableViewWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight - 60 - kBottomInsetHeight)
                                                           delegate:self
                                                         dataSource:self];
    
    addressTableView.placeHolderView = [TLPlaceholderView placeholderViewWithText:@"暂无收货地址"];
    
    [self.view addSubview:addressTableView];
    self.addressTableView = addressTableView;
    
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

- (void)addAddress {
    
    BaseWeakSelf;
    
    ZHAddAddressVC *address = [[ZHAddAddressVC alloc] init];
    
    address.addressType = AddressTypeAdd;
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
        cell.deleteAddr = ^(UITableViewCell *cell){
            
            NSInteger idx = [tableView indexPathForCell:cell].section;
            [TLAlert alertWithTitle:nil msg:@"确认删除该收货地址" confirmMsg:@"删除" cancleMsg:@"取消" cancle:^(UIAlertAction *action) {
                
            } confirm:^(UIAlertAction *action) {
                
                TLNetworking *http = [TLNetworking new];
                http.showView = self.view;
                http.code = @"805161";
                http.parameters[@"code"] = weakSelf.addressRoom[idx].code;
                http.parameters[@"token"] = [TLUser user].token;
                [http postWithSuccess:^(id responseObject) {
                    
                    [TLAlert alertWithSucces:@"删除成功"];
                    
                    [weakSelf.addressRoom removeObjectAtIndex:idx];
                    [weakSelf.addressTableView reloadData_tl];
                    
                } failure:^(NSError *error) {
                    
                }];
                
            }];
            
        };
        
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
        
        //设置为默认
        
        cell.defaultAddr = ^(UITableViewCell *cell) {
            
            NSInteger index = [tableView indexPathForCell:cell].section;
            
            TLNetworking *http = [TLNetworking new];
            http.showView = weakSelf.view;
            http.code = @"805163";
            http.parameters[@"code"] = weakSelf.addressRoom[index].code;
            http.parameters[@"token"] = [TLUser user].token;
            [http postWithSuccess:^(id responseObject) {
                
                [TLAlert alertWithSucces:@"设置成功"];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ADDRESS_CHANGE_NOTIFICATION" object:weakSelf userInfo:@{
                                                                                                                                 @"sender" : weakSelf
                                                                                                                                 }];
                //改变数据
                [weakSelf.addressRoom enumerateObjectsUsingBlock:^(ZHReceivingAddress * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    obj.isDefault = idx == index ? @"1": @"0";
                }];
                
                [weakSelf.addressTableView reloadData_tl];
                
            } failure:^(NSError *error) {
                
            }];
        };
    }
    
    cell.address = self.addressRoom[indexPath.section];
    
    cell.backgroundColor = kWhiteColor;
    
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
    
        }
    
    if (self.chooseAddress) {
        
        self.chooseAddress(selectedAddr);
        
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.addressRoom.count > 0) {
        
        ZHReceivingAddress *address = self.addressRoom[indexPath.section];
        
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


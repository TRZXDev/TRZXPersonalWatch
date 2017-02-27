//
//  TRZXPersonalWatchController.m
//  TRZXPersonalWatch
//
//  Created by 张江威 on 2017/2/27.
//  Copyright © 2017年 张江威. All rights reserved.
//

#import "TRZXPersonalWatchController.h"
#import "TRZXPersonalWatchModel.h"
#import "ZaixianerjiyedeCell.h"
#import "NoLabelView.h"
#import "InvestSeeCell.h"
#import "TRZXDIYRefresh.h"
#import "MJExtension.h"
#import "TRZXNetwork.h"
#import "UIImageView+WebCache.h"
#import "TRZXPWatchViewMode.h"



#define backColor [UIColor colorWithRed:240.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1]

@interface TRZXPersonalWatchController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) TRZXPWatchViewMode * personalWatchModel;

@property (nonatomic, strong) UIImageView * bgdImage;

@end

@implementation TRZXPersonalWatchController

- (void)viewDidLoad {
    [super viewDidLoad];
    _MID = @"ed48b2ecda7f485e9c3353ecfb53f3f5";
    _panduanStr = @"观看课程";
//    [self.view addSubview:self.bgdImage];
//    _bgdImage.hidden = YES;
    self.title = _panduanStr;
    [self.view addSubview:self.tableView];
//    [self refresh];
}

- (void)refresh{
    
    self.personalWatchModel.willLoadMore = NO;
    [self.tableView.mj_footer resetNoMoreData];
    [self createData];}

- (void)refreshMore{
    if (!self.personalWatchModel.canLoadMore) {
        [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
        return;
    }
    self.personalWatchModel.willLoadMore = YES;
    [self createData];
}

- (TRZXPWatchViewMode *)personalWatchModel {
    
    if (!_personalWatchModel) {
        _personalWatchModel = [TRZXPWatchViewMode new];
        _personalWatchModel.MID = self.MID;
        _personalWatchModel.panduanStr = self.panduanStr;
    }
    return _personalWatchModel;
}
// 发起请求
- (void)createData {
    [self.personalWatchModel.requestSignal_list subscribeNext:^(id x) {
        // 请求完成后，更新UI
        [self.tableView.mj_header endRefreshing];
        
        [self.tableView reloadData];
        
    } error:^(NSError *error) {
        // 如果请求失败，则根据error做出相应提示
        [self.tableView.mj_header endRefreshing];
        
    }];
}

-(UIImageView *)bgdImage{
    if (!_bgdImage) {
        
        _bgdImage = [[UIImageView alloc]init];
        _bgdImage.image = [UIImage imageNamed:@"列表无内容.png"];
        _bgdImage.frame = CGRectMake(0, (self.view.frame.size.height-self.view.frame.size.width)/2, self.view.frame.size.width, self.view.frame.size.width);
        
        
    }
    return _bgdImage;
}
-(UITableView *)tableView{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, (self.view.frame.size.height)) style:UITableViewStyleGrouped];
        _tableView.separatorStyle = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = backColor;
        // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
        _tableView.mj_header = [TRZXGifHeader headerWithRefreshingBlock:^{
            // 刷新数据
            [self refresh];
        }];
        [_tableView.mj_header beginRefreshing];
        
        // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadLastData方法）
        _tableView.mj_footer = [TRZXGifFooter footerWithRefreshingBlock:^{
            [self refreshMore];
            
        }];
        _tableView.mj_footer.automaticallyHidden = YES;
        
        
    }
    return _tableView;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.personalWatchModel.data.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TRZXPersonalWatchModel *mode = self.personalWatchModel.data[indexPath.row];
    if ([_panduanStr isEqualToString:@"观看课程"]) {
        return 134;
    }else{
        if (mode.projectId) {
            return 112;
        }else{
            return 102;
        }
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TRZXPersonalWatchModel *mode = self.personalWatchModel.data[indexPath.row];
    if ([_panduanStr isEqualToString:@"观看课程"]) {
        ZaixianerjiyedeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZaixianerjiyedeCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ZaixianerjiyedeCell" owner:self options:nil] lastObject];
        }
        self.tableView.showsVerticalScrollIndicator =
        NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        cell.titleLabel.text = mode.name;
        [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:mode.userPic] placeholderImage:[UIImage imageNamed:@"展位图"]];
        NSString * companyPosition = [NSString stringWithFormat:@"  %@,%@  ",mode.company,mode.title];
        cell.kanguoLab.text = [NSString stringWithFormat:@"%@人看过",mode.clickRate];
        
        if(mode.title==nil){
            companyPosition = mode.user;
        }
        cell.backgroundColor = backColor;
        cell.nameLabel.text = mode.user;
        cell.positionLabel.text = companyPosition;
        
        
        return cell;
        
    }else {
        
        InvestSeeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InvestSeeCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"InvestSeeCell" owner:nil options:nil]lastObject];
        }
        _tableView.showsVerticalScrollIndicator =
        NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        cell.backgroundColor = backColor;
        cell.headImageView.layer.cornerRadius = 6;
        cell.headImageView.layer.masksToBounds = YES;
        cell.bgView.layer.cornerRadius = 6;
        cell.bgView.layer.masksToBounds = YES;
        cell.titleLabel.text = mode.name;
        cell.tradeLabel.text = mode.tradeInfo;
        [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:mode.logo] placeholderImage:[UIImage imageNamed:@"展位图"]];
        cell.detailLabel.text = mode.briefIntroduction;
        cell.detailLabel.hidden = YES;
        return cell;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //行被选中后，自动变回反选状态的方法
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    TRZXPersonalWatchModel *mode = self.personalWatchModel.data[indexPath.row];
    if ([_panduanStr isEqualToString:@"观看课程"]) {

    }else{

    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end



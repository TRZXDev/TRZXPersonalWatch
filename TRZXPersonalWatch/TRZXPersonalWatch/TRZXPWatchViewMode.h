//
//  TRZXPWatchViewMode.h
//  TRZXPersonalWatch
//
//  Created by 张江威 on 2017/2/27.
//  Copyright © 2017年 张江威. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TRZXPersonalWatchModel.h"
#import "ReactiveCocoa.h"
#import "TRZXNetwork.h"

@interface TRZXPWatchViewMode : NSObject

@property (strong, nonatomic)NSString *MID;
@property (strong, nonatomic) NSString * panduanStr;
@property (strong, nonatomic) NSString *fenleiStr;

@property (readwrite, nonatomic, strong) NSNumber *pageNo, *pageSize, *totalPage;
@property (assign, nonatomic) BOOL canLoadMore, willLoadMore, isLoading;
@property (strong, nonatomic) RACSignal *requestSignal_list; ///< 网络请求信号量
@property (readwrite, nonatomic, strong) NSMutableArray *data; // 交易中心列表


-(NSDictionary *)toTipsParams;
- (void)configWithObj:(TRZXPersonalWatchModel *)model;


@end

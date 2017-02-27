//
//  TRZXPWatchViewMode.m
//  TRZXPersonalWatch
//
//  Created by 张江威 on 2017/2/27.
//  Copyright © 2017年 张江威. All rights reserved.
//

#import "TRZXPWatchViewMode.h"
#import "MJExtension.h"


@implementation TRZXPWatchViewMode


+(NSDictionary *)objectClassInArray{
    return @{@"data":[TRZXPersonalWatchModel class]};
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _canLoadMore = NO;
        _isLoading = _willLoadMore = NO;
        _pageNo = [NSNumber numberWithInteger:1];
        _pageSize = [NSNumber numberWithInteger:15];
    }
    return self;
}
-(NSDictionary *)toTipsParams{
    
    if ([_panduanStr isEqualToString:@"观看课程"]) {
        _fenleiStr = @"recodeCourse";
    }
    if ([_panduanStr isEqualToString:@"观看路演"]) {
        _fenleiStr = @"recodeRoadShow";
    }
    NSDictionary *params = @{@"requestType":@"User_Record_Api",
                             @"apiType":_fenleiStr,
                             @"beVisitId":_MID,
                             @"pageNo" : _willLoadMore? [NSNumber numberWithInteger:_pageNo.integerValue +1]: [NSNumber numberWithInteger:1],
                             @"pageSize" : _pageSize
                             };
    
    return params;
}

// 采用懒加载的方式来配置网络请求
- (RACSignal *)requestSignal_list {
    
    if (!_requestSignal_list) {
        
        _requestSignal_list = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            
            [TRZXNetwork requestWithUrl:nil params:self.toTipsParams method:GET cachePolicy:NetworkingReloadIgnoringLocalCacheData callbackBlock:^(id response, NSError *error) {
                
                if (response) {
                    self.data = [TRZXPersonalWatchModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
                    [subscriber sendNext:self.data];
                    [subscriber sendCompleted];
                    
                }else{
                    [subscriber sendError:error];
                }
            }];
            
            // 在信号量作废时，取消网络请求
            return [RACDisposable disposableWithBlock:^{
                
                [TRZXNetwork cancelRequestWithURL:@""];
            }];
        }];
    }
    return _requestSignal_list;
}



@end

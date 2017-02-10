//
//  SelectCargoListModel.h
//  Material
//
//  Created by wayne on 17/2/10.
//  Copyright © 2017年 brilliantech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SelectCargoListModel : NSObject
@property (nonatomic,strong) NSString *modelListName;
@property (nonatomic,strong) NSString *modelListState;
@property (nonatomic,strong) NSString *modelListWhouse;
@property (nonatomic,strong) NSString *modelListRemark;

- (instancetype)initWithObject:(NSDictionary *)dictionary;
@end

//
//  SelectCargoListModel.m
//  Material
//
//  Created by wayne on 17/2/10.
//  Copyright © 2017年 brilliantech. All rights reserved.
//

#import "SelectCargoListModel.h"

@implementation SelectCargoListModel

- (instancetype)init {
    self = [super init];
    
    return self;
}

- (instancetype)initWithObject:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.modelListName = dictionary[@"id"] ? dictionary[@"id"] : @"";
        self.modelListState = [dictionary valueForKey:@"state"] ? [dictionary valueForKey:@"state"]: @"";
        self.modelListWhouse = dictionary[@"whouse_id"] ? dictionary[@"whouse_id"] : @"";
        self.modelListRemark =
        dictionary[@"remark"] ? dictionary[@"remark"] : @"";

    }
    return self;
}
@end

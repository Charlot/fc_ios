//
//  SelectCargoItemModel.m
//  Material
//
//  Created by wayne on 17/2/10.
//  Copyright © 2017年 brilliantech. All rights reserved.
//

#import "SelectCargoItemModel.h"

@implementation SelectCargoItemModel
- (instancetype)init {
    self = [super init];
    
    return self;
}

- (instancetype)initWithObject:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.modelItemName = dictionary[@"id"] ? dictionary[@"id"] : @"";
        self.modelItemQuantity = [dictionary valueForKey:@"quantity"] ? [dictionary valueForKey:@"quantity"]: @"";
        self.modelItemBoxQuantity = [dictionary valueForKey:@"box_quantity"] ? [dictionary valueForKey:@"box_quantity"]: @"";

        
    }
    return self;
}
@end

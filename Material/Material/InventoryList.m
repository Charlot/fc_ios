//
//  InventoryList.m
//  Material
//
//  Created by ryan on 11/25/15.
//  Copyright © 2015 brilliantech. All rights reserved.
//

#import "InventoryList.h"

@implementation InventoryList
- (instancetype)init {
  self = [super init];

  return self;
}

- (instancetype)initWithObject:(NSDictionary *)dictionary {
  self = [super init];
  if (self) {
    self.ID = dictionary[@"id"] ? dictionary[@"id"] : @"";
    self.count = dictionary[@"count"] ? dictionary[@"count"] : @"";
    self.position = dictionary[@"position_id"] ? dictionary[@"position_id"] : @"";
       self.positionNr = dictionary[@"position_nr"] ? dictionary[@"position_nr"] : @"";
    self.inventory_list_id = dictionary[@"inventory_list_id"]
                                 ? dictionary[@"inventory_list_id"]
                                 : @"";
  }
  return self;
}

@end

//
//  InventoryListItem.m
//  Material
//
//  Created by ryan on 11/28/15.
//  Copyright © 2015 brilliantech. All rights reserved.
//

#import "InventoryListItem.h"
#define ZGNotNull(obj)                                                         \
  (obj && (![obj isEqual:[NSNull null]]) && (![obj isEqual:@"<null>"]))

@implementation InventoryListItem
- (instancetype)init {
  self = [super init];
  return self;
}

- (instancetype)initWithObject:(NSDictionary *)dictionary {
  self = [super init];
  if (self) {
    self.ID = dictionary[@"id"] ? dictionary[@"id"] : @"";
    self.part_id = dictionary[@"part_id"] ? dictionary[@"part_id"] : @"";
    self.part_nr = dictionary[@"part_nr"] ? dictionary[@"part_nr"] : @"";
    self.package_id =
        dictionary[@"package_id"] ? dictionary[@"package_id"] : @"";
    self.qty = dictionary[@"qty"] ? dictionary[@"qty"] : @"";
    //    self.fifo = dictionary[@"fifo"] ? dictionary[@"fifo"] : @"";
    self.fifo = ZGNotNull(dictionary[@"fifo"]) ? dictionary[@"fifo"] : @"";

    self.position_id = dictionary[@"position_id"] ? dictionary[@"position_id"] : @"";
      self.position_nr = dictionary[@"position_nr"] ? dictionary[@"position_nr"] : @"";

    self.inventory_list_id = dictionary[@"inventory_list_id"]
                                 ? dictionary[@"inventory_list_id"]
                                 : @"";
    self.whouse_id = dictionary[@"whouse_id"] ? dictionary[@"whouse_id"] : @"";
      
      self.whouse_nr = dictionary[@"whouse_nr"] ? dictionary[@"whouse_nr"] : @"";
  }
  return self;
}

@end

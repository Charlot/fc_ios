//
//  MovementList.m
//  Material
//
//  Created by ryan on 11/23/15.
//  Copyright © 2015 brilliantech. All rights reserved.
//

#import "MovementList.h"

@implementation MovementList
- (instancetype)init {
  self = [super init];

  return self;
}

- (instancetype)initWithObject:(NSDictionary *)dictionary {
  self = [super init];
  if (self) {
    self.ID = dictionary[@"id"] ? dictionary[@"id"] : @"";
    self.count = dictionary[@"count"] ? dictionary[@"count"] : @"";
    self.state = dictionary[@"state"] ? dictionary[@"state"] : @"";
    self.created_at =
        dictionary[@"created_at"] ? dictionary[@"created_at"] : @"";
      
      self.listid=dictionary[@"id"]?dictionary[@"id"]:@"";
      self.fifo=dictionary[@"fifo"]?dictionary[@"fifo"]:@"";
      self.packageId=dictionary[@"packageId"]?dictionary[@"packageId"]:@"";
      self.qty=dictionary[@"qty"]?[NSString stringWithFormat:@"%@",dictionary[@"qty"]]:@"";
      self.partNr=dictionary[@"partNr"]?dictionary[@"partNr"]:@"";
      self.position=dictionary[@"toPosition"]?dictionary[@"toPosition"]:@"";
  }
  return self;
}

-(instancetype)copyMe:(MovementList *)MovementList
{

    self.moveSourceId=MovementList.moveSourceId;
    self.partNr=[MovementList.partNr copy];
    self.fifo=[MovementList.fifo copy];
    self.packageId=[MovementList.packageId copy];
    self.qty=[MovementList.qty copy];
    self.position=[MovementList.position copy];
    return self;
}
@end

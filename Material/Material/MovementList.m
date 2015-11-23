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
  }
  return self;
}

@end

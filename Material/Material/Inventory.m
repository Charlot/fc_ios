//
//  Inventory.m
//  Material
//
//  Created by exmooncake on 15-6-13.
//  Copyright (c) 2015年 brilliantech. All rights reserved.
//

#import "Inventory.h"

@implementation Inventory

-(instancetype)init{
    self=[super init];
    return self;
}

-(instancetype)initWithObject:(NSDictionary *)dictionary
{
    self=[super init];
    if(self){
        self.ID=dictionary[@"id"]?dictionary[@"id"]:@"";
        self.name=dictionary[@"name"]?dictionary[@"name"]:@"";
        self.state=dictionary[@"state"]?dictionary[@"state"]:@"";
        self.whouse_id=dictionary[@"whouse_id"]?dictionary[@"whouse_id"]:@"";
        self.user_id=dictionary[@"user_id"]?dictionary[@"user_id"]:@"";
        self.created_at=dictionary[@"created_at"]?dictionary[@"created_at"]:@"";
        self.updated_at=dictionary[@"updated_at"]?dictionary[@"updated_at"]:@"";
    }
    return self;
}


@end

//
//  Location.m
//  Material
//
//  Created by Charlot on 16/3/2.
//  Copyright © 2016年 brilliantech. All rights reserved.
//

#import "Location.h"

@implementation Location
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
        self.nr=dictionary[@"nr"]?dictionary[@"nr"]:@"";
        self.tenant_id=dictionary[@"tenant_id"]?dictionary[@"tenant_id"]:@"";
        self.created_at=dictionary[@"created_at"]?dictionary[@"created_at"]:@"";
        self.updated_at=dictionary[@"updated_at"]?dictionary[@"updated_at"]:@"";
    }
    return self;
}


-(instancetype)initWithObject:(NSDictionary *)dictionary AndDestination:(Location*) destination
{
    self=[super init];
    if(self){
        self.ID=dictionary[@"id"]?dictionary[@"id"]:@"";
        self.name=dictionary[@"name"]?dictionary[@"name"]:@"";
        self.nr=dictionary[@"nr"]?dictionary[@"nr"]:@"";
        self.tenant_id=dictionary[@"tenant_id"]?dictionary[@"tenant_id"]:@"";
        self.created_at=dictionary[@"created_at"]?dictionary[@"created_at"]:@"";
        self.updated_at=dictionary[@"updated_at"]?dictionary[@"updated_at"]:@"";
        self.defaultDestination=destination;
    }
    return self;
}

@end

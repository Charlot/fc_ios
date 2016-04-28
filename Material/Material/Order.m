//
//  Order.m
//  Material
//
//  Created by Charlot on 16/4/13.
//  Copyright © 2016年 brilliantech. All rights reserved.
//

#import "Order.h"

@implementation Order

-(instancetype)init{
    self=[super init];
    return self;
}

-(instancetype)initWithObject:(NSDictionary *)dictionary
{
    self=[super init];
    if(self){
        self.ID=dictionary[@"id"]?dictionary[@"id"]:@"";
        self.userNr=dictionary[@"user_nr"]?dictionary[@"user_nr"]:@"";
        self.userId=dictionary[@"user_id"]?dictionary[@"user_id"]:@"";
        
        self.remark=dictionary[@"remark"]?dictionary[@"remark"]:@"";
        
        self.createdAt=dictionary[@"created_at"]?dictionary[@"created_at"]:@"";
    }
    return self;
}

@end

//
//  Whouse.m
//  Material
//
//  Created by Charlot on 16/4/11.
//  Copyright © 2016年 brilliantech. All rights reserved.
//

#import "Whouse.h"

@implementation Whouse
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
    }
    return self;
}
@end

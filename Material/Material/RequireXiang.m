//
//  RequireXiang.m
//  Material
//
//  Created by wayne on 14-7-21.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "RequireXiang.h"

@implementation RequireXiang
-(instancetype)initWithObject:(id)object
{
    self=[super init];
    if(self){
        self.department=[object objectForKey:@"department"];
        self.position=[object objectForKey:@"position"];
        self.partNumber=[object objectForKey:@"partNumber"];
        self.quantity=[object objectForKey:@"quantity"];
    }
    return self;
}
@end

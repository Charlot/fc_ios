//
//  XiangDetailModel.m
//  Material
//
//  Created by wayne on 16/4/19.
//  Copyright © 2016年 brilliantech. All rights reserved.
//

#import "XiangDetailModel.h"

@implementation XiangDetailModel

- (instancetype)init
{
    self = [super init];
    
    return self;
}

- (instancetype)initWithObject:(NSDictionary *)object{
    self=[super init];
    if(self){
        self.key=object[@"container_id"]?object[@"container_id"]:@"";
        self.partNr=object[@"part_id_display"]?object[@"part_id_display"]:@"";
        self.quantity=object[@"quantity"]?object[@"quantity"]:@"";
    }
    return self;
}


-(void)addXiangDetaiList:(XiangDetailModel *)xiangdetailist
{
    [self.xiangdetailist addObject:xiangdetailist];
}

@end

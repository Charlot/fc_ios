//
//  XiangDetail.m
//  Material
//
//  Created by wayne on 16/4/20.
//  Copyright © 2016年 brilliantech. All rights reserved.
//

#import "XiangDetail.h"

@implementation XiangDetail
-(instancetype)initExample
{
    self=[super init];
    if(self){
//        self.key=[NSString stringWithFormat:@"CZ%d",arc4random() %50];
    }
    return self;
}
-(instancetype)initWith:(NSString *)ID partNr:(NSString *)partNr key:(NSString *)key  quantity:(NSString *)quantity
{
    self=[super init];
    if(self){
        self.partNr=partNr?partNr:@"";
        self.key=key?key:@"";
        self.quantity=quantity?quantity:@"";
    }
    return self;
}

//-(instancetype)initWithObject:(NSDictionary *)object
//{
//    self=[super init];
//    if(self){
//        self.ID=object[@"id"]?object[@"id"]:@"";
//        self.key=object[@"container_id"]?object[@"container_id"]:@"";
//        self.partNr=object[@"part_id_display"]?object[@"part_id_display"]:@"";
//        self.quantity=object[@"quantity"]?object[@"quantity"]:@"";
//    }
//    return self;
//}


-(instancetype)initWithObject:(NSDictionary *)object
{
    self=[super init];
    if(self){
        self.ID=object[@"id"]?object[@"id"]:@"";
        self.key=object[@"container_id"]?object[@"container_id"]:@"";
        self.partNr=object[@"part_id_display"]?object[@"part_id_display"]:@"";
        self.quantity=object[@"quantity"]?[NSString stringWithFormat:@"%@",object[@"quantity"]]:@"";
        
        self.quantity_display=object[@"quantity_display"]?object[@"quantity_display"]:@"";
        
        self.position=object[@"position_nr"]?object[@"position_nr"]:@"";
        self.date=object[@"fifo_time_display"]?object[@"fifo_time_display"]:@"";
        self.checked=[object[@"state"] integerValue]==3?YES:NO;
        self.user_id=object[@"user_id"]?object[@"user_id"]:@"";
        self.state_display=object[@"state_display"]?object[@"state_display"]:@"";
        self.possible_department=object[@"possible_department"]?[NSArray arrayWithArray:object[@"possible_department"]]:[NSArray array];
        self.state=object[@"state"]?[object[@"state"] intValue]:0 ;
    }
    return self;
}
-(instancetype)copyMe:(XiangDetail *)xiangDetail
{
    self.ID=[xiangDetail.ID copy];
    self.key=[xiangDetail.key copy];
    
    self.partNr=[xiangDetail.partNr copy];
    self.quantity=[xiangDetail.quantity copy];
    return self;
}

-(void)addXiangDetail:(XiangDetail *)xiangDetail
{
    [self.xiangDetailArry addObject:xiangDetail];
}
@end

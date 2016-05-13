//
//  Xiang.m
//  Material
//
//  Created by wayne on 14-6-6.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "Xiang.h"

@implementation Xiang
-(instancetype)initExample
{
    self=[super init];
    if(self){
        self.number=[NSString stringWithFormat:@"leoni%d",arc4random() %100];
        self.count=[NSString stringWithFormat:@"%d",arc4random() %1000];
        self.key=[NSString stringWithFormat:@"CZ%d",arc4random() %50];
        self.position=@"03 21 09";
        self.remark=@"1";
        self.date=@"05.13";
    }
    return self;
}

-(instancetype)initWith:(NSString *)ID partNumber:(NSString *)partNumber key:(NSString *)key count:(NSString *)count position:(NSString *)position remark:(NSString *)remark date:(NSString *)date
{
    self=[super init];
    if(self){
        self.number=partNumber?partNumber:@"";
        self.count=count?count:@"";
        self.key=key?key:@"";
        self.position=position?position:@"";
        self.remark=remark?remark:@"";
        self.date=date?date:@"";
    }
    return self;
}

//-(instancetype)initWithForRuKuList:(NSString *)ID listID:(NSString *)listID created_at:(NSString *)created_at count:(NSString *) count state:(NSString *)state
//{
//    self = [super init];
//    if(self){
//        self.listid=listID?listID:@"";
//        self.listcreat_at=created_at?created_at:@"";
//        self.listcount=count?count:@"";
//        self.liststate=state?state:@"";
//        
//    }
//    return self;
//}

-(instancetype)initWithObject:(NSDictionary *)object
{
    self=[super init];
    if(self){
        self.ID=object[@"id"]?object[@"id"]:@"";
        self.container_id=object[@"container_id"]?object[@"container_id"]:@"";
        self.number=object[@"part_id_display"]?object[@"part_id_display"]:@"";
        self.count=object[@"quantity"]?[NSString stringWithFormat:@"%@",object[@"quantity"]]:@"";
        self.quantity_display=object[@"quantity_display"]?object[@"quantity_display"]:@"";
        self.key=object[@"container_id"]?object[@"container_id"]:@"";
        self.position=object[@"position_nr"]?object[@"position_nr"]:@"";
        self.remark=object[@"remark"]?object[@"remark"]:@"";
        self.date=object[@"fifo_time_display"]?object[@"fifo_time_display"]:@"";
        self.checked=[object[@"state"] integerValue]==3?YES:NO;
        self.user_id=object[@"user_id"]?object[@"user_id"]:@"";
        self.state_display=object[@"state_display"]?object[@"state_display"]:@"";
        self.possible_department=object[@"possible_department"]?[NSArray arrayWithArray:object[@"possible_department"]]:[NSArray array];
        self.state=object[@"state"]?[object[@"state"] intValue]:0 ;
////////here are ruku used
        self.listid=object[@"id"]?object[@"id"]:@"";
        self.fifo=object[@"fifo"]?object[@"fifo"]:@"";
        self.packageId=object[@"packageId"]?object[@"packageId"]:@"";
        self.qty=object[@"qty"]?object[@"qty"]:@"";
        self.partNr=object[@"partNr"]?object[@"partNr"]:@"";
    }
    return self;
}
-(instancetype)copyMe:(Xiang *)xiang
{
    self.ID=[xiang.ID copy];
    self.container_id=[xiang.container_id copy];
    self.number=[xiang.number copy];
    self.count=[xiang.count copy];
    self.key=[xiang.key copy];
    self.position=[xiang.position copy];
    self.remark=[xiang.remark copy];
    self.date=[xiang.date copy];
    self.checked=xiang.checked?YES:NO;
    self.state=xiang.state;
    self.state_display=[xiang.state_display copy];
    self.possible_department=[NSArray arrayWithArray:xiang.possible_department];
    self.listid=[xiang.listid copy];
    
    self.moveSourceId=xiang.moveSourceId;
    self.partNr=[xiang.partNr copy];
    self.fifo=[xiang.fifo copy];
    self.packageId=[xiang.packageId copy];
    self.qty=[xiang.qty copy];
    
    return self;
}
@end

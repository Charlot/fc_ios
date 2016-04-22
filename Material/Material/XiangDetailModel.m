//
//  XiangDetailModel.m
//  Material
//
//  Created by wayne on 16/4/19.
//  Copyright © 2016年 brilliantech. All rights reserved.
//

#import "XiangDetailModel.h"

@interface XiangDetailModel()

@end
@implementation XiangDetailModel

-(instancetype)initExample{
    self=[super init];
    if(self){
        
    }
    return self;
}


-(instancetype)initWith:(NSString *)ID key:(NSString *)key partNr:(NSString *)partNr quantity:(NSString *)quantity{
    self=[super init];
    
    if(self){
        self.Key=key?key:@"";
        self.PartNr=partNr?partNr:@"";
        self.Quantity=quantity?quantity:@"";
    }
    return self;
}

-(instancetype)initWithObject:(NSDictionary *)object {

    self=[super init];
    if (self){
        self.ID=[object valueForKey:@"id"]?[object valueForKey:@"id"]:@"";
        self.Key=[object valueForKey:@"container_id"]?[object valueForKey:@"container_id"]:@"";
        self.PartNr=[object valueForKey:@"part_id_display"]?[object valueForKey:@"part_id_display"]:@"";
        self.Quantity=[NSString stringWithFormat:@"%@",[object valueForKey:@"quantity"]]?[NSString stringWithFormat:@"%@",[object valueForKey:@"quantity"]]:@"";
    }
    return self;
}


-(instancetype)copyMe:(XiangDetailModel *)xiangDetail {

    self.ID=[xiangDetail.ID copy];
    self.Key=[xiangDetail.Key copy];
    self.PartNr=[xiangDetail.PartNr copy];
    self.Quantity=[xiangDetail.Quantity copy];
    return self;
}


//+(instancetype)sharedXiangDetailStore:(UITableView *)view
//{
//    static XiangDetailModel *xiangList=nil;
////    static dispatch_once_t onceToken;
////    dispatch_once(&onceToken, ^{
////        xiangList=[[XiangStore alloc] initPrivate:view];
////    });
//    return xiangList;
//}
//
//-(instancetype)initPrivate:(UITableView *)view
//{
//    self=[super init];
//    if(self){
//        self.xiangDetailArray=[[NSMutableArray alloc] init];
//        //        [[[AFNetOperate alloc] init] getXiangs:self.xiangArray view:view];
//    }
//    return self;
//}
//-(NSInteger)xiangDetailCount
//{
//    return [self.xiangDetailArray count];
//}
//-(NSArray *)xiangDetailList
//{
//    return [self.xiangDetailArray copy];
//}
//-(void)removeXiang:(NSInteger)index
//{
//    [self.xiangArray removeObjectAtIndex:index];
//}
@end
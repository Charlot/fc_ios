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
+(instancetype)sharedXiangDetailStore:(UITableView *)view
{
    static XiangDetailModel *xiangList=nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        xiangList=[[XiangStore alloc] initPrivate:view];
//    });
    return xiangList;
}
-(instancetype)initPrivate:(UITableView *)view
{
    self=[super init];
    if(self){
        self.xiangDetailArray=[[NSMutableArray alloc] init];
        //        [[[AFNetOperate alloc] init] getXiangs:self.xiangArray view:view];
    }
    return self;
}
-(NSInteger)xiangDetailCount
{
    return [self.xiangDetailArray count];
}
-(NSArray *)xiangDetailList
{
    return [self.xiangDetailArray copy];
}
//-(void)removeXiang:(NSInteger)index
//{
//    [self.xiangArray removeObjectAtIndex:index];
//}
@end
//
//  TuoStore.m
//  Material
//
//  Created by wayne on 14-6-6.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "TuoStore.h"
#import "Tuo.h"
@interface TuoStore()
@property (nonatomic,strong) NSMutableArray *listArray;
@end
@implementation TuoStore
+(instancetype)sharedTuoStore
{
    static TuoStore *list=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        list=[[TuoStore alloc] initPrivate];
    });
    return list;
}
-(instancetype)initPrivate
{
    self=[super init];
    if(self){
        self.listArray=[[NSMutableArray alloc] init];
        for(int i=0;i<3;i++){
            Tuo *tuo=[[Tuo alloc] initExample];
            [self.listArray addObject:tuo];
        }
    }
    return self;
}
-(int)tuoCount
{
    return [self.listArray count];
}
-(NSArray *)tuoList
{
    return [self.listArray copy];
}
-(void)addTuo:(Tuo *)tuo
{
    [self.listArray addObject:tuo];
}
-(void)removeTuo:(NSInteger)index
{
    [self.listArray removeObjectAtIndex:index];
}
@end

//
//  XiangDetailModel.h
//  Material
//
//  Created by wayne on 16/4/19.
//  Copyright © 2016年 brilliantech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XiangDetailModel : NSObject

@property(nonatomic,strong)NSString *ID;
@property(nonatomic,strong)NSString *Key;
@property(nonatomic,strong)NSString *Quantity;
@property(nonatomic,strong)NSString *PartNr;

-(instancetype)initExample;

-(instancetype)initWith:(NSString *)ID key:(NSString *)key partNr:(NSString *)partNr quantity:(NSString *)quantity;

-(instancetype)initWithObject:(NSDictionary *)object;

-(instancetype)copyMe:(XiangDetailModel *)xiangDetail;








//@property(nonatomic,strong)NSMutableArray *xiangDetailArray;
//+(instancetype)sharedXiangDetailStore:(UITableView *)view;
////-(Xiang *)addXiang:(NSString *)key partNumber:(NSString *)partNumber quatity:(NSString *)quatity;
//-(NSInteger)xiangDetailCount;
//-(NSArray *)xiangDetailList;
////-(void)removeXiang:(NSInteger)index;

@end

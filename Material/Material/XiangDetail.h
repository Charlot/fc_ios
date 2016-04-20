//
//  XiangDetail.h
//  Material
//
//  Created by wayne on 16/4/20.
//  Copyright © 2016年 brilliantech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XiangDetail : NSObject
@property(nonatomic,strong)NSString *ID;
@property(nonatomic,strong)NSString *key;
@property(nonatomic,strong)NSString *partNr;
@property(nonatomic,strong)NSString *quantity;
@property(nonatomic,strong) NSMutableArray *xiangDetailArry;

@property(nonatomic,strong)NSString *position;
@property(nonatomic,strong)NSString *date;

@property(nonatomic,strong)NSString *user_id;
@property(nonatomic,strong)NSString *state_display;
@property(nonatomic,strong)NSArray *possible_department;
@property(nonatomic,strong)NSString *quantity_display;

@property(nonatomic)int state;
@property(nonatomic)BOOL checked;

-(void)addXiangDetail:(XiangDetail *)xiangDetail;
-(instancetype)initWith:(NSString *)ID partNr:(NSString *)partNr key:(NSString *)key quantity:(NSString *)quantity;
-(instancetype)initWithObject:(NSDictionary *)object;
-(instancetype)copyMe:(XiangDetail *)xiangDetail;
@end

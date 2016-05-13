//
//  Xiang.h
//  Material
//
//  Created by wayne on 14-6-6.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Xiang : NSObject
@property(nonatomic,strong)NSString *ID;
@property(nonatomic,strong)NSString *container_id;
@property(nonatomic,strong)NSString *number;
@property(nonatomic,strong)NSString *key;
@property(nonatomic,strong)NSString *count;
@property(nonatomic,strong)NSString *quantity_display;
@property(nonatomic,strong)NSString *position;
@property(nonatomic,strong)NSString *remark;
@property(nonatomic,strong)NSString *date;
@property(nonatomic,strong)NSString *user_id;
@property(nonatomic,strong)NSString *state_display;
@property(nonatomic,strong)NSArray *possible_department;


@property(nonatomic,strong)NSString *listid;
@property(nonatomic,strong)NSString *listcreat_at;
@property(nonatomic,strong)NSString *listcount;
@property(nonatomic,strong)NSString *liststate;
@property(nonatomic,strong)NSString *partNr;
@property(nonatomic,strong)NSString *fifo;
@property(nonatomic,strong)NSString *packageId;
@property(nonatomic,strong)NSString *qty;



@property(nonatomic) int state ;
@property(nonatomic)BOOL checked;

@property(nonatomic)int moveSourceId;

-(instancetype)initExample;
-(instancetype)initWith:(NSString *)ID partNumber:(NSString *)partNumber key:(NSString *)key count:(NSString *)count position:(NSString *)position remark:(NSString *)remark date:(NSString *)date;

//-(instancetype)initWithForRuKuList:(NSString *)ID listID:(NSString *)listID created_at:(NSString *)created_at count:(NSString *) count state:(NSString *)state;

-(instancetype)initWithObject:(NSDictionary *)object;
-(instancetype)copyMe:(Xiang *)xiang;
@end


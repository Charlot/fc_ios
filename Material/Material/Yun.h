//
//  Yun.h
//  Material
//
//  Created by wayne on 14-6-8.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Yun : NSObject
@property(nonatomic,strong)NSString *ID;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *date;
@property(nonatomic,strong)NSString *remark;
@property(nonatomic,strong)NSMutableArray *tuoArray;
-(instancetype)initExample;
-(instancetype)initWith:(NSString *)ID name:(NSString *)name remark:(NSString *)remark;
@end

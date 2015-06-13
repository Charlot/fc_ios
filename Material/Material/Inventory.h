//
//  Inventory.h
//  Material
//
//  Created by exmooncake on 15-6-13.
//  Copyright (c) 2015年 brilliantech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Inventory : NSObject
@property(nonatomic,strong)NSString *ID;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *state;
@property(nonatomic,strong)NSString *whouse_id;
@property(nonatomic,strong)NSString *user_id;
@property(nonatomic,strong)NSString *created_at;
@property(nonatomic,strong)NSString *updated_at;
-(instancetype)initWithObject:(NSDictionary *)dictionary;

@end

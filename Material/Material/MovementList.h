//
//  MovementList.h
//  Material
//
//  Created by ryan on 11/23/15.
//  Copyright © 2015 brilliantech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MovementList : NSObject
@property(nonatomic, strong) NSString *ID;
@property(nonatomic, strong) NSString *count;
@property(nonatomic, strong) NSString *created_at;
@property(nonatomic, strong) NSString *state;

@property(nonatomic,strong)NSString *listid;
@property(nonatomic,strong)NSString *position;
@property(nonatomic,strong)NSString *listcount;
@property(nonatomic,strong)NSString *liststate;
@property(nonatomic,strong)NSString *partNr;
@property(nonatomic,strong)NSString *fifo;
@property(nonatomic,strong)NSString *packageId;
@property(nonatomic,strong)NSString *qty;

@property(nonatomic)int moveSourceId;
- (instancetype)initWithObject:(NSDictionary *)dictionary;
-(instancetype)copyMe:(MovementList *)xiang;
@end

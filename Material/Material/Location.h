//
//  Location.h
//  Material
//
//  Created by Charlot on 16/3/2.
//  Copyright © 2016年 brilliantech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Location : NSObject
@property(nonatomic,strong)NSString *ID;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *nr;
@property(nonatomic,strong)NSString *tenant_id;
@property(nonatomic,strong)NSString *created_at;
@property(nonatomic,strong)NSString *updated_at;

@property(nonatomic,strong)Location *defaultDestination;



-(instancetype)initWithObject:(NSDictionary *)dictionary;

-(instancetype)initWithObject:(NSDictionary *)dictionary AndDestination:(Location *) destination;
@end

//
//  UserPreference.h
//  Material
//
//  Created by wayne on 14-12-12.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Location.h"

@interface UserPreference : NSObject
@property(nonatomic,strong)NSString *location_id;
@property(nonatomic,strong)NSString *location_name;

@property(nonatomic,strong)NSString *role_id;
@property(nonatomic,strong)NSString *operation_mode;

@property(nonatomic,strong)Location *location;

+(instancetype)sharedUserPreference;
+(instancetype)generateUserPreference:(id)object;
@end

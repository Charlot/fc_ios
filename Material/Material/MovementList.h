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
- (instancetype)initWithObject:(NSDictionary *)dictionary;

@end

//
//  InventoryList.h
//  Material
//
//  Created by ryan on 11/25/15.
//  Copyright © 2015 brilliantech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InventoryList : NSObject
@property(nonatomic, strong) NSString *ID;
@property(nonatomic, strong) NSString *position;
@property(nonatomic,strong) NSString *positionNr;
@property(nonatomic, strong) NSString *count;
@property(nonatomic, strong) NSString *inventory_list_id;
- (instancetype)initWithObject:(NSDictionary *)dictionary;
@end

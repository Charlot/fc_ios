//
//  InventoryListItem.h
//  Material
//
//  Created by ryan on 11/28/15.
//  Copyright © 2015 brilliantech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InventoryListItem : NSObject
@property(nonatomic, strong) NSString *ID;
@property(nonatomic, strong) NSString *part_id;
@property(nonatomic, strong) NSString *package_id;
@property(nonatomic, strong) NSString *qty;
@property(nonatomic, strong) NSString *fifo;
@property(nonatomic, strong) NSString *position;
@property(nonatomic, strong) NSString *inventory_list_id;
- (instancetype)initWithObject:(NSDictionary *)dictionary;

@end

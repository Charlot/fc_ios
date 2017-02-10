//
//  SelectCargoItemModel.h
//  Material
//
//  Created by wayne on 17/2/10.
//  Copyright © 2017年 brilliantech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SelectCargoItemModel : NSObject
@property (nonatomic,strong) NSString *modelItemName;
@property (nonatomic,strong) NSString *modelItemQuantity;
@property (nonatomic,strong) NSString *modelItemBoxQuantity;

- (instancetype)initWithObject:(NSDictionary *)dictionary;
@end

//
//  SelectedCargoItemInfoModel.m
//  Material
//
//  Created by wayne on 17/2/10.
//  Copyright © 2017年 brilliantech. All rights reserved.
//

#import "SelectedCargoItemInfoModel.h"

@implementation SelectedCargoItemInfoModel
- (instancetype)init {
    self = [super init];
    
    return self;
}

- (instancetype)initWithObject:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.modelItemInfoPart_id = dictionary[@"part_id"] ? dictionary[@"part_id"] : @"";
        self.modelItemInfoPackage_id = dictionary[@"package_id"] ? dictionary[@"package_id"] : @"";
        self.modelItemInfoPosition = dictionary[@"position"] ? dictionary[@"position"] : @"";
        
    }
    return self;
}
@end

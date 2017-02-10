//
//  SelectedCargoItemInfoModel.h
//  Material
//
//  Created by wayne on 17/2/10.
//  Copyright © 2017年 brilliantech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SelectedCargoItemInfoModel : NSObject
@property (nonatomic,strong) NSString *modelItemInfoPackage_id;
@property (nonatomic,strong) NSString *modelItemInfoPart_id;
@property (nonatomic,strong) NSString *modelItemInfoPosition;

- (instancetype)initWithObject:(NSDictionary *)dictionary;
@end

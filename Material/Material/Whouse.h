//
//  Whouse.h
//  Material
//
//  Created by Charlot on 16/4/11.
//  Copyright © 2016年 brilliantech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Whouse : NSObject

@property(nonatomic,strong)NSString *ID;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *nr;



-(instancetype)initWithObject:(NSDictionary *)dictionary;

@end

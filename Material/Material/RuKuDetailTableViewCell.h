//
//  RuKuDetailTableViewCell.h
//  Material
//
//  Created by wayne on 16/5/17.
//  Copyright © 2016年 brilliantech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RuKuDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *packageID;
@property (weak, nonatomic) IBOutlet UILabel *partNr;
@property (weak, nonatomic) IBOutlet UILabel *qty;
@property (weak, nonatomic) IBOutlet UILabel *fifo;

@end

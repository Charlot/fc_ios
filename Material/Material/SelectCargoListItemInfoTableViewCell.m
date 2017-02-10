//
//  SelectCargoListItemInfoTableViewCell.m
//  Material
//
//  Created by wayne on 17/2/10.
//  Copyright © 2017年 brilliantech. All rights reserved.
//

#import "SelectCargoListItemInfoTableViewCell.h"

@implementation SelectCargoListItemInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.SelectItemInfoNameLabel.adjustsFontSizeToFitWidth = YES;
    self.SelectItemInfoPositionLabel.adjustsFontSizeToFitWidth = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

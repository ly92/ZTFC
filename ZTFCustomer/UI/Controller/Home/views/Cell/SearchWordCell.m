//
//  SearchWordCell.m
//  colourlife
//
//  Created by 李勇 on 16/3/23.
//  Copyright © 2016年 liuyadi. All rights reserved.
//

#import "SearchWordCell.h"

@interface SearchWordCell ()

@end

@implementation SearchWordCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)dataDidChange{
    if (self.isCommunity) {
        Community *community = (Community *)self.data;
        if (community) {
            self.searchWordLbl.text = community.name;
        }
    }else{
    
        SearchCardModel *topSearch = (SearchCardModel *)self.data;
        if (topSearch) {
            self.searchWordLbl.text = topSearch.key;
            
        }
    }
}

@end

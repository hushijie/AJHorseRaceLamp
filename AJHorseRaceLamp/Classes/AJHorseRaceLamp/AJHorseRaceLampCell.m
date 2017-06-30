//
//  AJHorseRaceLampCell.m
//  AJHorseRaceLamp
//
//  Created by JasonHu on 2017/6/30.
//  Copyright © 2017年 AJ. All rights reserved.
//

#import "AJHorseRaceLampCell.h"

@interface AJHorseRaceLampCell ()

@property (nonatomic ,weak)UILabel * titleLabel;

@end

@implementation AJHorseRaceLampCell

#pragma mark -

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        /*
         创建子视图
         */
        
        //标题label
        UILabel * titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        titleLabel.font=[UIFont systemFontOfSize:14];
        titleLabel.textAlignment=NSTextAlignmentLeft;
        titleLabel.numberOfLines=0;
        [self addSubview:titleLabel];
        _titleLabel=titleLabel;
        
    }
    return self;
}

#pragma mark - setter

-(void)setObject:(id)object
{
    _object=object;
    
    if ([_object isKindOfClass:[NSString class]]) {
        
        self.titleLabel.text=_object;
        
    }
}

@end

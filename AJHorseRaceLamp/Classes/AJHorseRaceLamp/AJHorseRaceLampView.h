//
//  AJHorseRaceLampView.h
//  AJHorseRaceLamp
//
//  Created by JasonHu on 2017/6/30.
//  Copyright © 2017年 AJ. All rights reserved.
//

/*
 跑马灯视图
 */


//跑马灯滚动方向类
typedef enum {
    
    AJHorseRaceLampViewScrollDirection_UpDown,      //上下滚动
    AJHorseRaceLampViewScrollDirection_LeftRight    //左右滚动
    
}AJHorseRaceLampViewScrollDirection;

#import <UIKit/UIKit.h>

@interface AJHorseRaceLampView : UIView


/**
 跑马灯的初始化设置

 @param horseRaceLampViewScrollDirection 跑马灯跑动方向
 @param dataSource 数据源
 @param didSelectedHorseRaceLampBlock 点击跑马灯之后的回调
 */
-(void)setAJHorseRaceLampViewScrollDirection:(AJHorseRaceLampViewScrollDirection)horseRaceLampViewScrollDirection dataSource:(NSArray *)dataSource didSelectedHorseRaceLampBlock:(void(^)(id object))didSelectedHorseRaceLampBlock;


@end

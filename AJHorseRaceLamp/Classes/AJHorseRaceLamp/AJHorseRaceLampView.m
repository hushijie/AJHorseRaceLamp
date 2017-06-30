//
//  AJHorseRaceLampView.m
//  AJHorseRaceLamp
//
//  Created by JasonHu on 2017/6/30.
//  Copyright © 2017年 AJ. All rights reserved.
//

#define AJHorseRaceLampCellIdentifier @"AJHorseRaceLampCell"
#define ItemCountTimes 100 //item数的倍数（50倍）

#import "AJHorseRaceLampView.h"
#import "AJHorseRaceLampCell.h"

@interface AJHorseRaceLampView ()<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate>

//跑马灯滚动方向
@property (nonatomic ,assign)AJHorseRaceLampViewScrollDirection horseRaceLampViewScrollDirection;

//数据源
@property (nonatomic ,copy)NSArray * dataSource;

//选中某个跑马灯之后的回调
@property (nonatomic ,copy)void(^didSelectedHorseRaceLampBlock)(id object);


@property (weak, nonatomic)UICollectionView *collectionView;

@property(nonatomic,strong)NSTimer * timer;

@end

@implementation AJHorseRaceLampView

#pragma mark - 创建视图

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)dealloc {
    
    //移除定时器
    [self.timer invalidate];
    self.timer = nil;
    
}



#pragma mark - 懒加载

-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0.0;
        layout.minimumInteritemSpacing = 0.0;
        CGFloat itemWidth = self.bounds.size.width;
        CGFloat itemHeight = self.bounds.size.height;
        layout.itemSize = CGSizeMake(itemWidth, itemHeight);
        
        //设置跑马灯滚动方向
        //左右滚动
        if (self.horseRaceLampViewScrollDirection==AJHorseRaceLampViewScrollDirection_LeftRight) {
            layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        }
        //上下滚动
        else if (self.horseRaceLampViewScrollDirection==AJHorseRaceLampViewScrollDirection_UpDown){
            layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        }
        
        UICollectionView * collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height) collectionViewLayout:layout];
        collectionView.backgroundColor=[UIColor clearColor];
        
        //注册cell
        [collectionView registerClass:[AJHorseRaceLampCell class] forCellWithReuseIdentifier:AJHorseRaceLampCellIdentifier];
        
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.showsVerticalScrollIndicator = NO;
        
        collectionView.pagingEnabled=YES;
        
        //禁止手动滑动
        collectionView.scrollEnabled=NO;
        
        [self addSubview:collectionView];
        _collectionView=collectionView;
        
    }
    return _collectionView;
}


#pragma mark - setter

-(void)setAJHorseRaceLampViewScrollDirection:(AJHorseRaceLampViewScrollDirection)horseRaceLampViewScrollDirection dataSource:(NSArray *)dataSource didSelectedHorseRaceLampBlock:(void (^)(id))didSelectedHorseRaceLampBlock
{
    _horseRaceLampViewScrollDirection=horseRaceLampViewScrollDirection;
    self.dataSource=dataSource;
    _didSelectedHorseRaceLampBlock=didSelectedHorseRaceLampBlock;
}


-(void)setDataSource:(NSArray *)dataSource
{
    _dataSource=dataSource;
    
    if (_dataSource.count>0) {
        
        self.collectionView.hidden=NO;
        
        /*
         刷新并移到中间部分
         */
        [self.collectionView reloadData];
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_dataSource.count*(ItemCountTimes/2) inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        
        //添加计时器
        [self addNSTimer];
        
    }
    else{
        self.collectionView.hidden=YES;
    }
}


#pragma mark - UICollectionViewDelegate 代理方法

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    //注：之所以section的返回值是1，是因为section如果设置太大的话容易消耗性能！所以我们可以将item的返回值设置的大一些
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return (self.dataSource.count * ItemCountTimes);
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AJHorseRaceLampCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:AJHorseRaceLampCellIdentifier forIndexPath:indexPath];
    cell.object=self.dataSource[indexPath.item%_dataSource.count];
    return cell;
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.didSelectedHorseRaceLampBlock) {
        self.didSelectedHorseRaceLampBlock(self.dataSource[indexPath.item%self.dataSource.count]);
    }
}


#pragma mark - 自动定时轮播


//添加定时器
-(void)addNSTimer
{
    //数据源数据个数超过1个 && 还没有添加计时器 才需要添加计时器
    if (_dataSource.count>1 && !self.timer) {
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
        //添加到runloop中
        [[NSRunLoop mainRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
        self.timer=timer;
    }
}

//删除定时器
-(void)removeNSTimer
{
    [self.timer invalidate];
    self.timer=nil;
}

//自动滚动
-(void)nextPage
{
    if (self.dataSource.count == 0) {
        return;
    }
    //获取当前正在展示的位置
    NSIndexPath *currentIndexPath=[[self.collectionView indexPathsForVisibleItems]lastObject];
    
    //回到中间相应的显示位置
    NSIndexPath *currentIndexPathRest=[NSIndexPath indexPathForItem:(_dataSource.count*(ItemCountTimes/2))+(currentIndexPath.item%self.dataSource.count) inSection:0];
    
    //左右滚动
    if (self.horseRaceLampViewScrollDirection==AJHorseRaceLampViewScrollDirection_LeftRight) {
        [self.collectionView scrollToItemAtIndexPath:currentIndexPathRest atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    }
    //上下滚动
    else if (self.horseRaceLampViewScrollDirection==AJHorseRaceLampViewScrollDirection_UpDown){
        [self.collectionView scrollToItemAtIndexPath:currentIndexPathRest atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
    }
    
    //计算出下一个需要展示的位置
    NSInteger nextItem=currentIndexPathRest.item+1;
    NSInteger nextSection=currentIndexPathRest.section;
    NSIndexPath *nextIndexPath=[NSIndexPath indexPathForItem:nextItem inSection:nextSection];
    
    //左右滚动
    if (self.horseRaceLampViewScrollDirection==AJHorseRaceLampViewScrollDirection_LeftRight) {
        //通过动画滚动到下一个位置
        [self.collectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    }
    //上下滚动
    else if (self.horseRaceLampViewScrollDirection==AJHorseRaceLampViewScrollDirection_UpDown){
        //通过动画滚动到下一个位置
        [self.collectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
    }
    
}



#pragma mark - UIScrollView的代理


-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self removeNSTimer];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self addNSTimer];
}

@end

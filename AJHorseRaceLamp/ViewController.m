//
//  ViewController.m
//  AJHorseRaceLamp
//
//  Created by JasonHu on 2017/6/30.
//  Copyright © 2017年 AJ. All rights reserved.
//

#import "ViewController.h"
#import "AJHorseRaceLampView.h"

@interface ViewController ()

@property (nonatomic ,weak)AJHorseRaceLampView * horseRaceLampView1;
@property (nonatomic ,weak)AJHorseRaceLampView * horseRaceLampView2;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.horseRaceLampView1 class];
    [self.horseRaceLampView2 class];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 懒加载

-(AJHorseRaceLampView *)horseRaceLampView1
{
    if (!_horseRaceLampView1) {
        
        AJHorseRaceLampView * view=[[AJHorseRaceLampView alloc]initWithFrame:CGRectMake(10, 100, self.view.bounds.size.width-10*2, 50)];
        view.backgroundColor=[UIColor greenColor];
        
        [view setAJHorseRaceLampViewScrollDirection:AJHorseRaceLampViewScrollDirection_UpDown dataSource:@[@"AJ",@"hushijie",@"xiongshaochen"] didSelectedHorseRaceLampBlock:^(id object) {
            
            UIViewController * vc=[[UIViewController alloc]init];
            [self presentViewController:vc animated:YES completion:^{
                vc.view.backgroundColor=[UIColor purpleColor];
            }];
            
        }];
        
        [self.view addSubview:view];
        _horseRaceLampView1=view;
        
    }
    return _horseRaceLampView1;
}

-(AJHorseRaceLampView *)horseRaceLampView2
{
    if (!_horseRaceLampView2) {
        
        AJHorseRaceLampView * view=[[AJHorseRaceLampView alloc]initWithFrame:CGRectMake(10, 200, self.view.bounds.size.width-10*2, 50)];
        view.backgroundColor=[UIColor purpleColor];
        
        [view setAJHorseRaceLampViewScrollDirection:AJHorseRaceLampViewScrollDirection_LeftRight dataSource:@[@"AJ",@"hushijie",@"xiongshaochen"] didSelectedHorseRaceLampBlock:^(id object) {
            
            UIViewController * vc=[[UIViewController alloc]init];
            [self presentViewController:vc animated:YES completion:^{
                vc.view.backgroundColor=[UIColor greenColor];
            }];
            
        }];
        
        [self.view addSubview:view];
        _horseRaceLampView2=view;
        
    }
    return _horseRaceLampView2;
}



@end

//
//  GmapViewController.m
//  越野e族
//
//  Created by gaomeng on 14-9-15.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "GmapViewController.h"



@interface GmapViewController ()
{
    BMKLocationService *_locService;//定位服务
}
@end

@implementation GmapViewController


-(void)viewWillDisappear:(BOOL)animated {
    
    NSLog(@"%s",__FUNCTION__);
    
    [_locService stopUserLocationService];
    
    _locService.delegate = nil;
    
}


- (void)dealloc
{
    
    
    [locationManager stopUpdatingLocation];
    NSLog(@"%s",__FUNCTION__);
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeBack WithRightButtonType:MyViewControllerRightbuttonTypeNull];
    self.title = @"英雄会";
    
    
    
    
    
    
    //GScrollView
    
    UIActivityIndicatorView *testActivityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    testActivityIndicator.center = CGPointMake(160, iPhone5?252:208);//只能设置中心，不能设置大小
    [self.view addSubview:testActivityIndicator];
    [testActivityIndicator startAnimating]; // 开始旋转

    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.gscrollView = [[GScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, iPhone5?568-64:480-64) WithLocation:iPhone5?[UIImage imageNamed:@"big5s.jpg"]:[UIImage imageNamed:@"big4s.jpg"]];
        [self.view addSubview:self.gscrollView];
        self.gscrollView.mapVCDelegate = self;

        
        self.tishilabel = [[UILabel alloc]initWithFrame:CGRectMake(0, iPhone5?568-64-40:480-64-40, 320, 40)];
        self.tishilabel.text = @"您目前不在大本营范围内";
        self.tishilabel.backgroundColor = [UIColor grayColor];
        self.tishilabel.alpha = 0.5;
        self.tishilabel.textAlignment = NSTextAlignmentCenter;
        
        [self.view addSubview:self.tishilabel];
        
        [testActivityIndicator stopAnimating];
        [testActivityIndicator setHidesWhenStopped:YES]; //当旋转结束时隐藏
    });
    
    
    //版本判断 开启定位
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=8.0)) {
        //ios8 定位
        locationManager = [[CLLocationManager alloc] init];
        [locationManager requestAlwaysAuthorization];
        [locationManager startUpdatingLocation];
        
        
        //百度定位
        _locService = [[BMKLocationService alloc]init];
        _locService.delegate = self;
        [_locService startUserLocationService];
        
    }else{
        //ios7 定位
        _locService = [[BMKLocationService alloc]init];
        _locService.delegate = self;
        [_locService startUserLocationService];
    }
    
    
    
    
    
    
    
    
    
    
    
}




#pragma mark - 定位代理方法

//在地图View将要启动定位时，会调用此函数
- (void)mapViewWillStartLocatingUser:(BMKMapView *)mapView
{
	NSLog(@"start locate");
}


//用户方向更新后，会调用此函数
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    
}


//用户位置更新后，会调用此函数
- (void)didUpdateUserLocation:(BMKUserLocation *)userLocation
{
    
    NSLog(@" 定位数据(x,y)    long = %f   lat = %f",userLocation.location.coordinate.longitude,userLocation.location.coordinate.latitude);
    
    
    //主席台测试数据
//    [self.gscrollView dingweiViewWithX:105.382810 Y:38.807060];
    
    //实际定位坐标  x:long   y:lat
    [self.gscrollView dingweiViewWithX:userLocation.location.coordinate.longitude Y:userLocation.location.coordinate.latitude];
    
}


//定位失败后，会调用此函数
- (void)mapView:(BMKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    
    UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"提示" message:@"定位失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [al show];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

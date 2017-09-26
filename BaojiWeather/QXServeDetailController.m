//
//  QXServeDetailController.m
//  BaojiWeather
//
//  Created by Tcy on 2017/3/24.
//  Copyright © 2017年 Tcy. All rights reserved.
//

#import "QXServeDetailController.h"

@interface QXServeDetailController ()<UIScrollViewDelegate>{
    
    UIWebView *webView;
}
@property (nonatomic)UIScrollView *scroll;


@end

@implementation QXServeDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationController.navigationBar.hidden=NO;

    [self stupNav];
    
    [self createScrellow];
    [self downLoadData];
    
}
- (void)createScrellow{
    _scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH,SCREEN_HEIGHT)];
    [self.view addSubview:_scroll];
    
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [_scroll addSubview:webView];
    _scroll.backgroundColor=[UIColor whiteColor];
    _scroll.contentSize = webView.frame.size;
    _scroll.showsVerticalScrollIndicator=NO;
    _scroll.showsHorizontalScrollIndicator=NO;
    _scroll.delegate = self;
    _scroll.minimumZoomScale = 1;
    _scroll.maximumZoomScale = 5;
    
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapGesture:)];
    tapGesture.numberOfTapsRequired=2;
    [_scroll addGestureRecognizer:tapGesture];

}

-(void)handleTapGesture:(UIGestureRecognizer*)sender{
    if(_scroll.zoomScale > 1.0){
        
        [_scroll setZoomScale:1.0 animated:YES];
    }else{
        [_scroll setZoomScale:5.0 animated:YES];
    }
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return webView;
}

- (void)downLoadData{
    
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    [dict setObject:self.detailid forKey:@"prentid"];
    
    [NBRequest requestWithURL:[NSString stringWithFormat:AtmoDetail,self.detailid] type:RequestRefresh success:^(NSData *requestData) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:requestData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",dict);
        if (![dict isEqual:[NSNull null]]) {
            
            
            NSArray *arr=dict[@"list"];
            NSString *str=arr[0][@"content"];
            NSString *htmStr= [NSString stringWithFormat:@"<meta name=\"viewport\" content=\"width=device-width, initial-scale=1\" />%@",str];
            [webView loadHTMLString:htmStr baseURL:nil];

        }
        
    } failed:^(NSError *error) {
        
    }];
    
        //NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:AtmoDetail,self.detailid]]];
       // [self.view addSubview: webView];
       // [webView loadRequest:request];
}


- (void)stupNav{
    self.title=@"详情";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:18.0]}];
    [self.navigationController.navigationBar setBarTintColor:RGBCOLOR(0, 32, 203)];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

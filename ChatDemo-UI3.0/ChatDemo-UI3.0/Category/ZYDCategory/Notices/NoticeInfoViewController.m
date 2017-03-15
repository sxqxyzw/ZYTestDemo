//
//  NoticeInfoViewController.m
//  ChatDemo-UI3.0
//
//  Created by 杜洁鹏 on 27/02/2017.
//  Copyright © 2017 杜洁鹏. All rights reserved.
//

#import "NoticeInfoViewController.h"
#import <Hyphenate/Hyphenate.h>
#import "EMSDImageCache.h"
#define IMAGESIZE CGSizeMake(400,270)
#define PADDING 20

@interface NoticeInfoViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) EMMessage *msg;
@end

@implementation NoticeInfoViewController

- (instancetype)initWithMessage:(EMMessage *)aMessage {
    if (self = [super init]) {
        self.msg = aMessage;
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    EMTextMessageBody *textBody = (EMTextMessageBody *)self.msg.body;
    self.title = textBody.text;
    self.msg.isRead = YES;
    id info = nil;
    NSDictionary *dic = self.msg.ext;
    if(dic){
        info = dic.allValues.firstObject;
    }
    
    
    int y = 10;
    
    if (info && [info isKindOfClass:[NSArray class]]) {
        NSArray *ary = (NSArray *)info;
        for (NSDictionary *infoDic in ary) {
            y += 5;
            if (infoDic[@"img"]) {
                UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(PADDING, y, IMAGESIZE.width - PADDING * 2, IMAGESIZE.height)];
                [img sd_setImageWithURL:[NSURL URLWithString:infoDic[@"img"]] placeholderImage:nil];
                [self.scrollView addSubview:img];
                y +=  img.frame.size.height;
            }
            
            if (infoDic[@"txt"]) {
                UILabel *label = [[UILabel alloc] init];
                label.text = infoDic[@"txt"];
                [label sizeToFit];
                CGRect frame = label.frame;
                
                frame.origin.y = y;
                frame.origin.x = PADDING;
                label.frame = frame;
                [self.scrollView addSubview:label];
                y += label.frame.size.height;
            }
        }
    }
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, y + 10);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setupUnreadMessageCount" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

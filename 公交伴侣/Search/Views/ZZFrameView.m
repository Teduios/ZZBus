//
//  FrameView.m
//  MyBus
//
//  Created by Tarena on 16/5/9.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import "ZZFrameView.h"

@implementation ZZFrameView
- (void)drawRect:(CGRect)rect {
    UIBezierPath *path=[UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:10];
    [[UIColor lightGrayColor]setStroke];
    path.lineWidth=1;
    [path stroke];
}


@end

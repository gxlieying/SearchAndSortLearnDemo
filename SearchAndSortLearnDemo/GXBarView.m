//
//  GXBarView.m
//  GXDemo
//
//  Created by iOS开发T001 on 2018/12/6.
//  Copyright © 2018年 iOS开发. All rights reserved.
//

#import "GXBarView.h"

@interface GXBarView()

@property(nonatomic, strong) UILabel *label;

@end

@implementation GXBarView

- (void)layoutSubviews{
    self.label.center = self.center;
    self.label.frame = CGRectMake(0, 10, self.frame.size.width, 10);
    self.label.hidden = self.frame.size.width < [UIScreen mainScreen].bounds.size.width / 15 ? YES : NO;
    self.label.text = [NSString stringWithFormat:@"%d",(int)self.frame.size.height];
    
    self.backgroundColor = [UIColor colorWithHue:(self.frame.size.height/self.superview.frame.size.height) saturation:1 brightness:1 alpha:1];
}

- (UILabel *)label{
    if (!_label) {
        _label = [UILabel new];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = [UIColor whiteColor];
        _label.font = [UIFont systemFontOfSize:12];
        [self addSubview:_label];
    }
    return _label;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    _copiedFrame = frame;
}

@end

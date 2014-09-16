//
//  NKPageViewControllerDelegate.m
//  VideoChatDemo
//
//  Created by Nick Kibish on 14.09.14.
//  Copyright (c) 2014 Nick Kibish. All rights reserved.
//

#import "NKPageViewControllerDelegate.h"
#import "NKVideochatViewController.h"
#import "NKPageViewController.h"

@implementation NKPageViewControllerDelegate

-(instancetype)init
{
    if (self = [super init]) {
        self.controllers = [(NKPageViewController *)self.pageViewController controllers];
    }
    return self;
}

#pragma mark - Data Source
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSLog(@"-");
    NSUInteger index = [_controllers indexOfObject:viewController];
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [_controllers count]) {
        return nil;
    }
    return [_controllers objectAtIndex:index];;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSLog(@"+");
    NSUInteger index = [_controllers indexOfObject:viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [_controllers objectAtIndex:index];
}

- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    UIViewController *currentViewController = self.pageViewController.viewControllers[0];
    NSArray *viewControllers = @[currentViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    self.pageViewController.doubleSided = NO;
    return UIPageViewControllerSpineLocationMin;
}

@end

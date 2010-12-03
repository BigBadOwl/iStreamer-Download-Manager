//
//  CustomMoviePlayerViewController.h
//
//  Copyright iOSDeveloperTips.com All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

@interface CustomMoviePlayerViewController : UIViewController 
{
  MPMoviePlayerController *mp;
  NSURL *movieURL;
}

- (id)initWithPath:(NSString *)moviePath;
- (void)readyPlayer;

@end

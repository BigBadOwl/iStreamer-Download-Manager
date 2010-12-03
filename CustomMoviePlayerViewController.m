//
//  CustomMoviePlayerViewController.m
//
//  Copyright iOSDeveloperTips.com All rights reserved.
//

#import "CustomMoviePlayerViewController.h"

#pragma mark -
#pragma mark Compiler Directives & Static Variables

@implementation CustomMoviePlayerViewController

- (void)viewDidload {
	NSLog(@"Movie View Did Load");
}

- (void)viewDidUnload {
	NSLog(@"Movie View Did Unload");
}

/*---------------------------------------------------------------------------
* 
*--------------------------------------------------------------------------*/
- (id)initWithPath:(NSString *)moviePath
{
	// Initialize and create movie URL
  if (self = [super init]){
	movieURL = [NSURL URLWithString:moviePath];    
    [movieURL retain];
  }
	return self;
}

/*---------------------------------------------------------------------------
* For 3.2 and 4.x devices
* For 3.1.x devices see moviePreloadDidFinish:
*--------------------------------------------------------------------------*/
- (void) moviePlayerLoadStateChanged:(NSNotification*)notification 
{
	NSLog(@"moviePlayerLoadStateChanged");
	// Unless state is unknown, start playback
	if ([mp loadState] != MPMovieLoadStateUnknown){
		// Remove observer
		[[NSNotificationCenter 	defaultCenter] removeObserver:self name:MPMoviePlayerLoadStateDidChangeNotification object:nil];

		// When tapping movie, status bar will appear, it shows up
		// in portrait mode by default. Set orientation to landscape
		[[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:NO];

		// Set frame of movieplayer
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
			[[self view] setBounds:CGRectMake(0, 0, 1024, 768)];
			[[self view] setCenter:CGPointMake(384, 512)];
			[[self view] setTransform:CGAffineTransformMakeRotation(M_PI / 2)]; 
			[[mp view] setFrame:CGRectMake(0, 0, 1024, 768)];
		}
		else{
			[[self view] setBounds:CGRectMake(0, 0, 480, 320)];
			[[self view] setCenter:CGPointMake(160, 240)];
			[[self view] setTransform:CGAffineTransformMakeRotation(M_PI / 2)]; 
			[[mp view] setFrame:CGRectMake(0, 0, 480, 320)];
		}
		
		// Add movie player as subview
		[[self view] addSubview:[mp view]];   

		// Play the movie
		NSLog(@"moviePlayer is playing movie");
		[mp play];
	}
}

/*---------------------------------------------------------------------------
* For 3.1.x devices
* For 3.2 and 4.x see moviePlayerLoadStateChanged: 
*--------------------------------------------------------------------------*/
- (void) moviePreloadDidFinish:(NSNotification*)notification 
{
	NSLog(@"moviePreloadDidFinish");
	// Remove observer
	[[NSNotificationCenter 	defaultCenter] removeObserver:self name:MPMoviePlayerContentPreloadDidFinishNotification object:nil];

	// Play the movie
 	[mp play];
}

/*---------------------------------------------------------------------------
* 
*--------------------------------------------------------------------------*/
- (void) moviePlayBackDidFinish:(NSNotification*)notification 
{    
	NSLog(@"moviePlayBackDidFinish");
	[[UIApplication sharedApplication] setStatusBarHidden:YES];

 	// Remove observer
	[[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];

	[self dismissModalViewControllerAnimated:YES];
}

/*---------------------------------------------------------------------------
*
*--------------------------------------------------------------------------*/
- (void) readyPlayer{
	mp =  [[MPMoviePlayerController alloc] initWithContentURL:movieURL];
	
	NSError *setCategoryError = nil; 
	[[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error: &setCategoryError]; 

	if (setCategoryError) {
		//NSLog(@"Audio Error %@",  setCategoryError);
	}

	if ([mp respondsToSelector:@selector(loadState)]) {
		// Set movie player layout
		NSLog(@"Setting movie layout");
		[mp setControlStyle:MPMovieControlStyleFullscreen];
		[mp setAllowsWirelessPlayback:YES];
		[mp setFullscreen:YES];
		[mp prepareToPlay];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerLoadStateChanged:) name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
	}  
	else{
		// Register to receive a notification when the movie is in memory and ready to play.
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePreloadDidFinish:) name:MPMoviePlayerContentPreloadDidFinishNotification object:nil];
	}

	// Register to receive a notification when the movie has finished playing. 
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayBackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
}

/*---------------------------------------------------------------------------
* 
*--------------------------------------------------------------------------*/
- (void) loadView{
	[self setView:[[[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]] autorelease]];
	[[self view] setBackgroundColor:[UIColor blackColor]];
}

/*---------------------------------------------------------------------------
*  
*--------------------------------------------------------------------------*/
- (void)dealloc {
	[mp release];
	[movieURL release];
	[super dealloc];
}

@end

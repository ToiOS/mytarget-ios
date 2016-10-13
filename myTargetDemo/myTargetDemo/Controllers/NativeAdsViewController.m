//
//  NativeAdsViewController.m
//  myTargetDemo
//
//  Created by Anton Bulankin on 27.06.16.
//  Copyright © 2016 Mail.ru Group. All rights reserved.
//

#import "NativeAdsViewController.h"

#import "ContentStreamExampleView.h"
#import "NewsFeedExampleView.h"
#import "ChatListExampleView.h"
#import "ContentWallExampleView.h"
#import "DefaultSlots.h"

@interface NativeAdsViewController ()

@end

@implementation NativeAdsViewController
{
	ContentStreamExampleView *_contentStreamExampleView;
	ContentStreamExampleView *_contentStreamVideoExampleView;
	NewsFeedExampleView *_newsFeedExampleView;
	ChatListExampleView *_chatListExampleView;
	ContentWallExampleView *_contentWallExampleView;
	ContentWallExampleView *_contentWallVideoExampleView;
	NSUInteger _slotId;
}

- (instancetype)initWithTitle:(NSString *)title slotId:(NSUInteger)slotId
{
	self = [super initWithTitle:title];
	if (self)
	{
		_slotId = slotId;

		_contentStreamExampleView = [[ContentStreamExampleView alloc] initWithController:self slotId:_slotId];
		[self addPageWithTitle:@"CONTENT STREAM" view:_contentStreamExampleView];

		_newsFeedExampleView = [[NewsFeedExampleView alloc] initWithController:self slotId:_slotId];
		[self addPageWithTitle:@"NEWS FEED" view:_newsFeedExampleView];

		_chatListExampleView = [[ChatListExampleView alloc] initWithController:self slotId:_slotId];
		[self addPageWithTitle:@"CHAT LIST" view:_chatListExampleView];

		_contentWallExampleView = [[ContentWallExampleView alloc] initWithController:self slotId:_slotId];
		[self addPageWithTitle:@"CONTENT WALL" view:_contentWallExampleView];

		_contentStreamVideoExampleView = [[ContentStreamExampleView alloc] initWithController:self slotId:kSlotNativeAdVideo];
		[self addPageWithTitle:@"CONTENT STREAM VIDEO" view:_contentStreamVideoExampleView];

		_contentWallVideoExampleView = [[ContentWallExampleView alloc] initWithController:self slotId:kSlotNativeAdVideo];
		[self addPageWithTitle:@"CONTENT WALL VIDEO" view:_contentWallVideoExampleView];
	}
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];

	UIBarButtonItem *updateButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
	                                                                              target:self action:@selector(updateTapped:)];
	self.navigationItem.rightBarButtonItems = @[updateButton];

	[self reloadAds];
}

- (void)reloadAds
{
	[_contentStreamExampleView reloadAd];
	[_contentStreamVideoExampleView reloadAd];
	[_newsFeedExampleView reloadAd];
	[_chatListExampleView reloadAd];
	[_contentWallExampleView reloadAd];
	[_contentWallVideoExampleView reloadAd];
}


- (void)updateTapped:(id)sender
{
	[self reloadAds];
}

@end

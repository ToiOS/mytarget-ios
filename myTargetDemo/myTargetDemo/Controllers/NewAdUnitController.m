//
// Created by Anton Bulankin on 03.07.16.
// Copyright (c) 2016 Mail.ru Group. All rights reserved.
//

#import "NewAdUnitController.h"
#import "CustomAdItem.h"

@interface AdTypeItem : NSObject

@property(nonatomic) NSUInteger adType;
@property(nonatomic) NSString *title;

- (instancetype)initWithAdType:(NSUInteger)adType title:(NSString *)title;

@end

@implementation AdTypeItem : NSObject

- (instancetype)initWithAdType:(NSUInteger)adType title:(NSString *)title
{
	self = [super init];
	if (self)
	{
		_adType = adType;
		_title = title;
	}
	return self;
}

@end

@interface NewAdUnitController () <UIActionSheetDelegate, UITextFieldDelegate>

@end

@implementation NewAdUnitController
{
	id <NewAdUnitControllerDelegate> _delegate;

	UILabel *_adTypeLabel;
	UILabel *_slotIdLabel;
	UILabel *_nameLabel;
	UIButton *_adTypeButton;
	UITextField *_slotIdTextField;
	UITextField *_nameTextField;
	UIButton *_saveButton;

	NSUInteger _adType;
	NSArray <AdTypeItem *> *_adTypes;
	NSMutableArray<NSLayoutConstraint *> *_constraints;
}

- (instancetype)initWithDelegate:(id <NewAdUnitControllerDelegate>)delegate
{
	self = [super init];
	if (self)
	{
		_delegate = delegate;
		_constraints = [NSMutableArray<NSLayoutConstraint *> new];
	}
	return self;
}

- (void)adTypeButtonSetTitle:(NSString *)title
{
	[_adTypeButton setTitle:[NSString stringWithFormat:@"%@ Unit", title] forState:UIControlStateNormal];
}

- (void)viewDidLoad
{
	[super viewDidLoad];

	self.view.backgroundColor = [UIColor whiteColor];

	BOOL isIPad = [[[UIDevice currentDevice] model] isEqualToString:@"iPad"];
	NSMutableArray <AdTypeItem *> *adTypes = [NSMutableArray new];
	[adTypes addObject:[[AdTypeItem alloc] initWithAdType:kAdTypeStandard title:@"Banner 320x50"]];
	[adTypes addObject:[[AdTypeItem alloc] initWithAdType:kAdTypeStandard300x250 title:@"Banner 300x250"]];
	if (isIPad)
	{
		[adTypes addObject:[[AdTypeItem alloc] initWithAdType:kAdTypeStandard728x90 title:@"Banner 728x90"]];
	}
	[adTypes addObject:[[AdTypeItem alloc] initWithAdType:kAdTypeInterstitial title:@"Interstitial Ad"]];
	[adTypes addObject:[[AdTypeItem alloc] initWithAdType:kAdTypeNative title:@"Native Ad"]];
	[adTypes addObject:[[AdTypeItem alloc] initWithAdType:kAdTypeNativeVideo title:@"Native Video"]];
	[adTypes addObject:[[AdTypeItem alloc] initWithAdType:kAdTypeNativeCarousel title:@"Native Carousel"]];
	[adTypes addObject:[[AdTypeItem alloc] initWithAdType:kAdTypeInstream title:@"Instream Ad"]];
	_adTypes = adTypes;

	_adTypeLabel = [[UILabel alloc] init];
	_adTypeLabel.text = @"Ad type";
	_adTypeLabel.translatesAutoresizingMaskIntoConstraints = NO;
	[self.view addSubview:_adTypeLabel];

	_slotIdLabel = [[UILabel alloc] init];
	_slotIdLabel.text = @"Slot id";
	_slotIdLabel.translatesAutoresizingMaskIntoConstraints = NO;
	[self.view addSubview:_slotIdLabel];

	_nameLabel = [[UILabel alloc] init];
	_nameLabel.text = @"Name";
	_nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
	[self.view addSubview:_nameLabel];

	_adTypeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	_adTypeButton.accessibilityIdentifier = @"adTypeButton";
	[_adTypeButton setTitle:@"..." forState:UIControlStateNormal];
	_adTypeButton.titleLabel.textAlignment = NSTextAlignmentLeft;
	[_adTypeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	_adTypeButton.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.05];
	_adTypeButton.layer.borderColor = [[UIColor blackColor] colorWithAlphaComponent:0.1].CGColor;
	_adTypeButton.layer.borderWidth = 0.6;
	_adTypeButton.layer.cornerRadius = 4;
	_adTypeButton.translatesAutoresizingMaskIntoConstraints = NO;
	[_adTypeButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 0.0)];
	_adTypeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
	[self.view addSubview:_adTypeButton];
	[_adTypeButton addTarget:self action:@selector(adTypeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];

	_slotIdTextField = [[UITextField alloc] init];
	_slotIdTextField.accessibilityIdentifier = @"slotIdTextField";
	_slotIdTextField.text = @"";
	_slotIdTextField.keyboardType = UIKeyboardTypeNumberPad;
	_slotIdTextField.translatesAutoresizingMaskIntoConstraints = NO;
	_slotIdTextField.borderStyle = UITextBorderStyleRoundedRect;
	_slotIdTextField.delegate = self;
	[self.view addSubview:_slotIdTextField];

	_nameTextField = [[UITextField alloc] init];
	_nameTextField.accessibilityIdentifier = @"nameTextField";
	_nameTextField.text = @"";
	_nameTextField.borderStyle = UITextBorderStyleRoundedRect;
	_nameTextField.translatesAutoresizingMaskIntoConstraints = NO;
	_nameTextField.delegate = self;
	[self.view addSubview:_nameTextField];

	_saveButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[_saveButton setTitle:@"Save ad unit" forState:UIControlStateNormal];
	[_saveButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	_saveButton.titleLabel.textAlignment = NSTextAlignmentLeft;
	[_saveButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	_saveButton.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.05];
	_saveButton.layer.borderColor = [[UIColor blackColor] colorWithAlphaComponent:0.1].CGColor;
	_saveButton.layer.borderWidth = 0.6;
	_saveButton.layer.cornerRadius = 4;
	_saveButton.translatesAutoresizingMaskIntoConstraints = NO;
	[self.view addSubview:_saveButton];
	[_saveButton addTarget:self action:@selector(saveButtonTapped:) forControlEvents:UIControlEventTouchUpInside];

	AdTypeItem *firstItem = _adTypes[0];
	_adType = firstItem.adType;
	[self adTypeButtonSetTitle:firstItem.title];

	[self setupConstraints];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	self.navigationController.navigationBar.topItem.title = @"";
	self.navigationItem.title = @"New ad unit";
}

- (void)viewSafeAreaInsetsDidChange
{
	[super viewSafeAreaInsetsDidChange];
	[self setupConstraints];
}

- (void)setupConstraints
{
	if (_constraints.count > 0)
	{
		[NSLayoutConstraint deactivateConstraints:_constraints];
		[_constraints removeAllObjects];
	}

	NSDictionary *views = @{
		@"adTypeLabel" : _adTypeLabel,
		@"slotIdLabel" : _slotIdLabel,
		@"nameLabel" : _nameLabel,
		@"adTypeButton" : _adTypeButton,
		@"slotIdTextField" : _slotIdTextField,
		@"nameTextField" : _nameTextField,
		@"saveButton" : _saveButton
	};

	UIEdgeInsets safeAreaInsets = UIEdgeInsetsZero;
	if (@available(ios 11.0, *))
	{
		safeAreaInsets = self.view.safeAreaInsets;
	}

	float leftMargin = (safeAreaInsets.left > 0) ? safeAreaInsets.left : 16.0;
	float rightMargin = (safeAreaInsets.right > 0) ? safeAreaInsets.right : 16.0;
	float topMargin = (safeAreaInsets.top > 0) ? safeAreaInsets.top : 20.0;
	float bottomMargin = (safeAreaInsets.bottom > 0) ? safeAreaInsets.bottom : 20.0;

	NSDictionary<NSString *, NSNumber *> *metrics = @{
		@"topMargin": [NSNumber numberWithFloat:topMargin],
		@"bottomMargin": [NSNumber numberWithFloat:bottomMargin],
		@"leftMargin": [NSNumber numberWithFloat:leftMargin],
		@"rightMargin": [NSNumber numberWithFloat:rightMargin]
	};

	[_constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-leftMargin-[adTypeLabel(80)]-4-[adTypeButton]-rightMargin-|" options:0 metrics:metrics views:views]];
	[_constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-leftMargin-[slotIdLabel(80)]-4-[slotIdTextField]-rightMargin-|" options:0 metrics:metrics views:views]];
	[_constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-leftMargin-[nameLabel(80)]-4-[nameTextField]-rightMargin-|" options:0 metrics:metrics views:views]];
	[_constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-topMargin-[adTypeLabel(40)]-10-[slotIdLabel(40)]-10-[nameLabel(40)]" options:0 metrics:metrics views:views]];
	[_constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-topMargin-[adTypeButton(40)]-10-[slotIdTextField(40)]-10-[nameTextField(40)]" options:0 metrics:metrics views:views]];
	[_constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[nameLabel]-50-[saveButton(60)]" options:0 metrics:metrics views:views]];
	[_constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[saveButton(120)]" options:0 metrics:metrics views:views]];
	[_constraints addObject:[NSLayoutConstraint constraintWithItem:_saveButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];

	[NSLayoutConstraint activateConstraints:_constraints];
}

- (void)adTypeButtonTapped:(UIButton *)sender
{
	UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Ad type" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
	alertController.popoverPresentationController.sourceView = sender;

	[alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];

	for (AdTypeItem *item in _adTypes)
	{
		UIAlertAction *alertAction = [UIAlertAction actionWithTitle:item.title style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
		{
			_adType = item.adType;
			[self adTypeButtonSetTitle:item.title];
		}];
		[alertController addAction:alertAction];
	}

	[self presentViewController:alertController animated:YES completion:nil];
}

- (void)saveButtonTapped:(id)sender
{
	[self.view endEditing:YES];

	NSUInteger slotId = 0;
	if (_slotIdTextField.text && _slotIdTextField.text.length > 0)
	{
		NSNumberFormatter *formatString = [[NSNumberFormatter alloc] init];
		NSNumber *number = [formatString numberFromString:_slotIdTextField.text];
		slotId = number.unsignedLongValue;
	}

	if (slotId > 0)
	{
		CustomAdItem *newAditem = [[CustomAdItem alloc] initWithType:_adType slotId:slotId title:_nameTextField.text];
		[_delegate newAdUnitControllerNewCustomAdItem:newAditem];
		[self.navigationController popViewControllerAnimated:YES];
	}
}

#pragma mark -- UITextFieldDelegate

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self.view endEditing:YES];
	[super touchesBegan:touches withEvent:event];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
	return textField == _slotIdTextField || textField == _nameTextField;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
	_adTypeButton.enabled = NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
	if (textField != _slotIdTextField && textField != _nameTextField)
	{
		[self.view endEditing:YES];
	}
	_adTypeButton.enabled = YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	if (textField == _slotIdTextField)
	{
		NSCharacterSet *nonNumberSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
		if ([string rangeOfCharacterFromSet:nonNumberSet].location != NSNotFound)
		{
			return NO;
		}
	}
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[self.view endEditing:YES];
	return YES;
}

@end

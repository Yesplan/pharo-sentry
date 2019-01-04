initialization
initialize
	super initialize.
	eventId := UUID new.
	timestamp := DateAndTime now.
	logger := Sentry sdkName.
	platform := 'other'.
	sdk := Dictionary new
		at: 'name' put: Sentry sdkName;
		at: 'version' put: Sentry sdkVersion;
		yourself.
	contexts := Dictionary new
		at: 'runtime' put: GRPlatform current runtime;
		yourself.
	tags := Dictionary new
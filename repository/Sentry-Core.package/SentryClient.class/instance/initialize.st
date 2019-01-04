initialization
initialize
	super initialize.
	dsn := ''.
	context := SentryContext new.
	appPackages := #().
	self resetBreadcrumbs.
	isInApp := [ :aMethod :aMethodClass | 
	self appPackages isString
		ifTrue: [ self appPackages asRegex search: aMethodClass package name ]
		ifFalse: [ self appPackages includes: aMethodClass package ] ].
	beforeSend := [ :anEvent |  ]
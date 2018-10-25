sending
send: anEvent
	| payload |
	self isEnabled
		ifFalse: [ ^ nil ].
	self assert: [ dsn notNil ] description: 'DSN wasn''t configured.'.
	beforeSend value: anEvent.
	payload := anEvent asDictionary.
	breadcrumbs
		ifNotEmpty: [ payload at: 'breadcrumbs' put: (breadcrumbs collect: #asDictionary) asArray.
			self resetBreadcrumbs ].
	context asDictionary ifNotEmpty: [ :ctx | payload := payload copy addAll: ctx; yourself ].
	self transport send: payload to: dsn.
	lastEvent := anEvent.
	^ anEvent eventId
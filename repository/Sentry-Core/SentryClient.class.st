"
I am a client on which one dispatches exceptions and messages.

Normally I shouldn't be used directly, but as an endpoint for a regular logging framework, such as Beacon (see SentryLogger).
"
Class {
	#name : #SentryClient,
	#superclass : #Object,
	#instVars : [
		'dsn',
		'context',
		'breadcrumbs',
		'appPackages',
		'isInApp',
		'beforeSend',
		'transport',
		'lastEvent',
		'includeStackTemps'
	],
	#category : 'Sentry-Core-Model'
}

{ #category : #'instance creation' }
SentryClient class >> dsn: aDsn [
	^ self new
		dsn: aDsn;
		yourself
]

{ #category : #accessing }
SentryClient >> appPackages [
	^ appPackages
]

{ #category : #accessing }
SentryClient >> appPackages: aCollection [
	appPackages := aCollection
]

{ #category : #accessing }
SentryClient >> beforeSend: aOneArgBlock [
	beforeSend := aOneArgBlock
]

{ #category : #accessing }
SentryClient >> breadcrumbs [
	^ breadcrumbs
]

{ #category : #capturing }
SentryClient >> captureException: anException [
	^ self captureException: anException in: [ :event |  ]
]

{ #category : #capturing }
SentryClient >> captureException: anException in: anEventBlock [
	| event |
	event := SentryEvent new.
	event message: anException description.
	event
		exception:
			(SentryException new
				values:
					{SentryExceptionValue new
						type: anException class name;
						value: anException description;
						module: anException class package name;
						stacktrace: (self stacktraceFor: anException)}).
	anEventBlock value: event.
	^ self send: event
]

{ #category : #capturing }
SentryClient >> captureExceptionsDuring: aBlock [
	self captureExceptionsDuring: aBlock in: [ :event | ]
]

{ #category : #capturing }
SentryClient >> captureExceptionsDuring: aBlock in: anEventBlock [
	aBlock
		on: Exception
		do: [ :err | self captureException: err in: anEventBlock ]
]

{ #category : #capturing }
SentryClient >> captureMessage: aString [
	^ self captureMessage: aString in: [ :event | ]
]

{ #category : #capturing }
SentryClient >> captureMessage: aString in: anEventBlock [
	| event |
	event := SentryEvent new.
	event message: aString.
	anEventBlock value: event.
	^ self send: event
]

{ #category : #capturing }
SentryClient >> captureMessage: aString params: aCollection [
	^ self captureMessage: aString params: aCollection in: [ :event |  ]
]

{ #category : #capturing }
SentryClient >> captureMessage: aString params: aCollection in: anEventBlock [
	| event |
	event := SentryEvent new.
	event message: (SentryMessage message: aString params: aCollection).
	anEventBlock value: event.
	^ self send: event
]

{ #category : #accessing }
SentryClient >> clearLastEvent [
	lastEvent := nil
]

{ #category : #accessing }
SentryClient >> context [
	^ context
]

{ #category : #accessing }
SentryClient >> defaultTransport [
	^ SentryCurlHttpTransport new
]

{ #category : #accessing }
SentryClient >> dsn [
	^ dsn
]

{ #category : #accessing }
SentryClient >> dsn: aDsn [
	| dsnUrl |
	dsnUrl := aDsn asZnUrl.
	self validateDsn: dsnUrl.
	dsn := dsnUrl
]

{ #category : #accessing }
SentryClient >> dsnString [
	^ dsn asString
]

{ #category : #accessing }
SentryClient >> includeStackTemps [

	^ includeStackTemps

]

{ #category : #accessing }
SentryClient >> includeStackTemps: boolean [

	includeStackTemps := boolean

]

{ #category : #initialization }
SentryClient >> initialize [
	super initialize.
	dsn := ''.
	context := SentryContext new.
	appPackages := #().
	self resetBreadcrumbs.
	isInApp := [ :aMethod :aMethodClass | 
	self appPackages isString
		ifTrue: [ self appPackages asRegex search: aMethodClass package name ]
		ifFalse: [ self appPackages includes: aMethodClass package ] ].
	beforeSend := [ :anEvent |  ].
	includeStackTemps := false

]

{ #category : #testing }
SentryClient >> isEnabled [
	^ dsn isEmpty not & Sentry enabled
]

{ #category : #testing }
SentryClient >> isMethodInApp: aMethod methodClass: aMethodClass [
	^ isInApp value: aMethod value: aMethodClass
]

{ #category : #accessing }
SentryClient >> lastEvent [
	^ lastEvent
]

{ #category : #capturing }
SentryClient >> recordBreadcrumbIn: aOneArgBlock [
	| crumb |
	crumb := SentryBreadcrumb new.
	aOneArgBlock value: crumb.
	breadcrumbs add: crumb
]

{ #category : #initialization }
SentryClient >> resetBreadcrumbs [
	breadcrumbs := OrderedCollection new
]

{ #category : #sending }
SentryClient >> send: anEvent [
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
]

{ #category : #examples }
SentryClient >> sendSampleException [
	^ [ self error: 'Sample Exception' ]
		on: Exception
		do: [ :ex | self captureException: ex in: [ :event | event level: 'sample' ] ]
]

{ #category : #examples }
SentryClient >> sendSampleMessage [
	self captureMessage: 'Sample Message' in: [ :event | event level: 'sample' ]
]

{ #category : #extraction }
SentryClient >> stacktraceFor: exception [

	^ [
		| frames |

		frames := GRPlatform current framesForException: exception forClient: self.
		SentryStacktrace new
			frames: frames reversed asArray;
			yourself
	] on: Error do: [ :error |
		SentryStacktraceErrorNotification new
			tracedException: exception;
			tracingError: error;
			signal: ('Could not create SentryStacktrace for an exception of class {1}' format: { exception class name }) ]

]

{ #category : #accessing }
SentryClient >> transport [
	^ transport ifNil: [ transport := self defaultTransport ]
]

{ #category : #accessing }
SentryClient >> transport: aTransport [
	transport := aTransport
]

{ #category : #validation }
SentryClient >> validateDsn: aDsn [
	"scheme://public_key@host/path"

	"Empty DSN disables the client."

	aDsn isEmpty ifTrue: [ ^ self ].
	self
		assert: [ aDsn scheme notNil and: [ aDsn scheme isEmpty not ] ]
		description: 'scheme is missing in the DSN'.
	"username = public_key here"
	self
		assert: [ aDsn username notNil and: [ aDsn username isEmpty not ] ]
		description: 'public_key is missing in the DSN'.
	self
		assert: [ aDsn host notNil and: [ aDsn host isEmpty not ] ]
		description: 'host is missing in the DSN'.
	self
		assert: [ aDsn path notNil and: [ aDsn path isEmpty not ] ]
		description: 'path is missing in the DSN'
]

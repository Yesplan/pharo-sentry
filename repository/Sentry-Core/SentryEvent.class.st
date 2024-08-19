"
I represent a dispatched event. For available attributes see the sentry docs.

I am serialized using `#asDictionary`.
"
Class {
	#name : #SentryEvent,
	#superclass : #Object,
	#instVars : [
		'eventId',
		'timestamp',
		'logger',
		'platform',
		'sdk',
		'level',
		'culprit',
		'serverName',
		'release',
		'tags',
		'environment',
		'modules',
		'extra',
		'fingerprint',
		'message',
		'exception',
		'contexts'
	],
	#category : 'Sentry-Core-Model'
}

{ #category : #'accessing - special' }
SentryEvent >> asDictionary [
	| dict |
	dict := self requiredPayload copy
		addAll:
			(SentryConverter new
				asDictionary: self
				keys: #(logger platform sdk)
				optional: #(level contexts culprit serverName release tags environment modules extra fingerprint));
		yourself.
	dict
		at: 'tags'
		ifPresent: [ :t | 
			t isEmpty
				ifTrue: [ dict removeKey: 'tags' ] ].
	self message
		ifNotNil: [ :msg | 
			msg isString
				ifTrue: [ dict at: 'message' put: msg ]
				ifFalse: [ dict at: 'sentry.interfaces.Message' put: msg asDictionary ] ].
	self exception ifNotNil: [ :ex | dict at: 'exception' put: ex asDictionary ].
	^ dict
]

{ #category : #accessing }
SentryEvent >> contexts [
	^ contexts
]

{ #category : #accessing }
SentryEvent >> contexts: anObject [
	contexts := anObject
]

{ #category : #accessing }
SentryEvent >> culprit [
	^ culprit
]

{ #category : #accessing }
SentryEvent >> culprit: anObject [
	culprit := anObject
]

{ #category : #accessing }
SentryEvent >> environment [
	^ environment
]

{ #category : #accessing }
SentryEvent >> environment: anObject [
	environment := anObject
]

{ #category : #accessing }
SentryEvent >> eventId [
	^ eventId
]

{ #category : #accessing }
SentryEvent >> eventId: anId [
	eventId := anId
]

{ #category : #accessing }
SentryEvent >> eventIdString [
	^ self uuid32For: self eventId
]

{ #category : #accessing }
SentryEvent >> exception [
	^ exception
]

{ #category : #accessing }
SentryEvent >> exception: anObject [
	exception := anObject
]

{ #category : #accessing }
SentryEvent >> extra [
	^ extra
]

{ #category : #accessing }
SentryEvent >> extra: anObject [
	extra := anObject
]

{ #category : #accessing }
SentryEvent >> fingerprint [
	^ fingerprint
]

{ #category : #accessing }
SentryEvent >> fingerprint: anObject [
	fingerprint := anObject
]

{ #category : #initialization }
SentryEvent >> initialize [
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
]

{ #category : #formatting }
SentryEvent >> isoTimestampFor: aDateTime [
	| utc |
	utc := aDateTime asUTC.
	^ String
		streamContents: [ :aStream | 
			utc printYMDOn: aStream withLeadingSpace: false.
			aStream nextPut: $T.
			aStream nextPutAll: (utc hour asString padded: #left to: 2 with: $0);
				nextPut: $:; 
				nextPutAll: (utc minute asString padded: #left to: 2 with: $0);
				nextPut: $:;
				nextPutAll: (utc second rounded asString padLeftTo: 2 with: $0). ]
]

{ #category : #accessing }
SentryEvent >> level [
	^ level
]

{ #category : #accessing }
SentryEvent >> level: anObject [
	level := anObject
]

{ #category : #accessing }
SentryEvent >> logger [
	^ logger
]

{ #category : #accessing }
SentryEvent >> logger: anObject [
	logger := anObject
]

{ #category : #accessing }
SentryEvent >> message [
	^ message
]

{ #category : #accessing }
SentryEvent >> message: anObject [
	message := anObject
]

{ #category : #accessing }
SentryEvent >> modules [
	^ modules
]

{ #category : #accessing }
SentryEvent >> modules: anObject [
	modules := anObject
]

{ #category : #accessing }
SentryEvent >> platform [
	^ platform
]

{ #category : #accessing }
SentryEvent >> platform: anObject [
	platform := anObject
]

{ #category : #accessing }
SentryEvent >> release [
	^ release
]

{ #category : #accessing }
SentryEvent >> release: anObject [
	release := anObject
]

{ #category : #'accessing - special' }
SentryEvent >> requiredPayload [
	^ Dictionary new
		at: 'event_id' put: self eventIdString;
		at: 'timestamp' put: (self isoTimestampFor: self timestamp);
		yourself
]

{ #category : #accessing }
SentryEvent >> sdk [
	^ sdk
]

{ #category : #accessing }
SentryEvent >> sdk: anObject [
	sdk := anObject
]

{ #category : #accessing }
SentryEvent >> serverName [
	^ serverName
]

{ #category : #accessing }
SentryEvent >> serverName: anObject [
	serverName := anObject
]

{ #category : #accessing }
SentryEvent >> tags [
	^ tags
]

{ #category : #accessing }
SentryEvent >> tags: anObject [
	tags := anObject
]

{ #category : #accessing }
SentryEvent >> timestamp [
	^ timestamp
]

{ #category : #accessing }
SentryEvent >> timestamp: aDateTime [
	timestamp := aDateTime
]

{ #category : #formatting }
SentryEvent >> uuid32For: aUUID [
	^ aUUID asString copyWithout: $-
]

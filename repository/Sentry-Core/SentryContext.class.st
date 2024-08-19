"
I hold all contextual information for the events.
"
Class {
	#name : #SentryContext,
	#superclass : #SentryBaseContext,
	#instVars : [
		'user',
		'request',
		'extra',
		'tags',
		'release'
	],
	#category : 'Sentry-Core-Model'
}

{ #category : #'accessing - special' }
SentryContext >> asDictionary [
	^ self asDictionary: #() optional: #(user release request extra tags)
]

{ #category : #initialization }
SentryContext >> clear [
	extra := Dictionary new.
	request := Dictionary new.
	user := Dictionary new.
	tags := Dictionary new.
	release := nil
]

{ #category : #accessing }
SentryContext >> extra [
	^ extra
]

{ #category : #accessing }
SentryContext >> extra: aDictionary [
	extra := aDictionary
]

{ #category : #initialization }
SentryContext >> initialize [
	super initialize.
	self clear
]

{ #category : #merging }
SentryContext >> merge: aDictionary [
	aDictionary
		keysAndValuesDo: [ :key :value | 
			value isString
				ifTrue: [ self perform: key asSymbol asMutator with: value ]
				ifFalse: [ self perform: key asSymbol asMutator with: ((self perform: key asSymbol) addAll: value; yourself) ] ]
]

{ #category : #accessing }
SentryContext >> release [
	^ release
]

{ #category : #accessing }
SentryContext >> release: aRelease [
	release := aRelease
]

{ #category : #accessing }
SentryContext >> request [
	^ request
]

{ #category : #accessing }
SentryContext >> request: aDictionary [
	request := aDictionary
]

{ #category : #accessing }
SentryContext >> tags [
	^ tags
]

{ #category : #accessing }
SentryContext >> tags: aDictionary [
	tags := aDictionary
]

{ #category : #accessing }
SentryContext >> user [
	^ user
]

{ #category : #accessing }
SentryContext >> user: aDictionary [
	"the base attributes are id, email, ip_address, and username"

	user := aDictionary
]

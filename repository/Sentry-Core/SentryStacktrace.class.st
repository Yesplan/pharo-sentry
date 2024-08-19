Class {
	#name : #SentryStacktrace,
	#superclass : #SentryInterface,
	#instVars : [
		'frames',
		'framesOmitted'
	],
	#category : 'Sentry-Core-Model'
}

{ #category : #converting }
SentryStacktrace >> asDictionary [
	^ (Dictionary new
			at: 'frames' put: (self frames collect: #asDictionary);
			yourself)
		addAll: (self asDictionary: #() optional: #(frames_omitted));
		yourself
]

{ #category : #accessing }
SentryStacktrace >> frames [
	^ frames
]

{ #category : #accessing }
SentryStacktrace >> frames: anObject [
	frames := anObject
]

{ #category : #accessing }
SentryStacktrace >> framesOmitted [
	^ framesOmitted
]

{ #category : #accessing }
SentryStacktrace >> framesOmitted: anObject [
	framesOmitted := anObject
]

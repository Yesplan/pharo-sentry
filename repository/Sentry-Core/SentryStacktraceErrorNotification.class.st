Class {
	#name : #SentryStacktraceErrorNotification,
	#superclass : #GRNotification,
	#instVars : [
		'tracedException',
		'tracingError'
	],
	#category : 'Sentry-Core-Utils'
}

{ #category : #accessing }
SentryStacktraceErrorNotification >> tracedException [

	^ tracedException

]

{ #category : #accessing }
SentryStacktraceErrorNotification >> tracedException: newTracedException [

	tracedException := newTracedException

]

{ #category : #accessing }
SentryStacktraceErrorNotification >> tracingError [

	^ tracingError

]

{ #category : #accessing }
SentryStacktraceErrorNotification >> tracingError: newTracingError [

	tracingError := newTracingError

]

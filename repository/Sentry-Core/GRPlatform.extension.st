Extension { #name : #GRPlatform }

{ #category : #'*Sentry-Core' }
GRPlatform >> framesForException: exception forClient: sentryClient [

	self subclassResponsibility

]

{ #category : #'*Sentry-Core' }
GRPlatform >> runtime [

	self subclassResponsibility
]

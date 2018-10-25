tests
testTonelFileName
	| method |
	method := SentryClient >> #dsn: .
	self
		assert: (SentryFrame new tonelFileNameFor: method methodClass: method methodClass)
		equals: 'Sentry-Core/SentryClient.class.st'.
	method := SentryClient class >> #dsn: .
	self
		assert: (SentryFrame new tonelFileNameFor: method methodClass: method methodClass)
		equals: 'Sentry-Core/SentryClient.class.st'
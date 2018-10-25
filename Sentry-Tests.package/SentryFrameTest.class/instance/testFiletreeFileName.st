tests
testFiletreeFileName
	| method |
	method := SentryClient >> #dsn: .
	self
		assert: (SentryFrame new filetreeFileNameFor: method methodClass: method methodClass)
		equals: 'Sentry-Core.package/SentryClient.class/instance/dsn..st'.
	method := SentryClient class >> #dsn: .
	self
		assert: (SentryFrame new filetreeFileNameFor: method methodClass: method methodClass)
		equals: 'Sentry-Core.package/SentryClient.class/class/dsn..st'
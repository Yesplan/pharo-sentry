tests - testing
testIsMethodInApp
	| method |
	method := SentryClientTest >> #testIsMethodInApp.
	client appPackages: 'Sentry-Tests'.
	self assert: (client isMethodInApp: method methodClass: method methodClass).
	client appPackages: {'Sentry-Tests' asPackage}.
	self assert: (client isMethodInApp: method methodClass: method methodClass).
	client appPackages: 'Kernel'.
	self deny: (client isMethodInApp: method methodClass: method methodClass)
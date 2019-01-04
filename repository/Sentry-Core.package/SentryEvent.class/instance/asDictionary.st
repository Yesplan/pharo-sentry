accessing - special
asDictionary
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
				ifTrue: [ dict at: 'message' put: (msg replaceAll: $' with: $" )]
				ifFalse: [ dict at: 'sentry.interfaces.Message' put: msg asDictionary ] ].
	self exception ifNotNil: [ :ex | dict at: 'exception' put: ex asDictionary ].
	^ dict
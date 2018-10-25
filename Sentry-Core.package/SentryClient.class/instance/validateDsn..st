validation
validateDsn: aDsn
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
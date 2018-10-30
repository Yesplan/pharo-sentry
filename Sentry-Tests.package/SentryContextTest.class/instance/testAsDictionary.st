running
testAsDictionary
	context user: (Dictionary new
		at: 'id' put: '123';
		yourself).
	context release: 'v0.9.0'.
	self
		assert: context asDictionary
		equals:
			{'release' -> 'v0.9.0'.
			'user' -> {'id' -> '123'} asDictionary} asDictionary
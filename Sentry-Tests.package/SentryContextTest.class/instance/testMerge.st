running
testMerge
	context user: (Dictionary new
		at: 'id' put: '123';
		yourself).
	context release: 'v0.9.0'.
	context
		merge:
			{'release' -> 'v0.9.1'.
			'user' -> {'email' -> 'me@example.com'} asDictionary} asDictionary .
	self
		assert: context user
		equals:
			{'id' -> '123'.
			'email' -> 'me@example.com'} asDictionary.
	self assert: context release equals: 'v0.9.1'
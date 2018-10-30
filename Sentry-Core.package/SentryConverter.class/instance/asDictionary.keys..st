converting
asDictionary: anObject keys: keys
	| dict |
	dict := Dictionary new.
	keys
		do: [ :each | 
			| value |
			value := self read: anObject using: each.
			self assert: [ value notNil ] description: each , ' is a mandatory argument.'.
			dict at: each asString put: value ].
	^ dict
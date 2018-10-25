converting
read: anObject using: aKey
	| selector value |
	selector := (((aKey splitOn: '_') collect: #capitalized) joinUsing: '').
	selector at: 1 put: (selector first asLowercase).
	value := selector asSymbol value: anObject.
	^ (value isKindOf: SentryInterface)
		ifTrue: [ value asDictionary ]
		ifFalse: [ value ]
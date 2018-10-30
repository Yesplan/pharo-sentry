merging
merge: aDictionary
	aDictionary
		keysAndValuesDo: [ :key :value | 
			value isString
				ifTrue: [ self perform: key asSymbol asMutator with: value ]
				ifFalse: [ self perform: key asSymbol asMutator with: ((self perform: key asSymbol) addAll: value; yourself) ] ]
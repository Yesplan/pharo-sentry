accessing - derived
tonelFileNameFor: aMethod methodClass: aMethodClass
	^ String
		streamContents: [ :stream | 
			stream
				<< aMethodClass package name;
				<< '/'.
			stream
				<< aMethodClass theNonMetaClass name;
				<< '.class.st' ]
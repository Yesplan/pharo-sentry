accessing - derived
filetreeFileNameFor: aMethod methodClass: aMethodClass
	^ String
		streamContents: [ :stream | 
			stream
				<< aMethodClass package name;
				<< '.package';
				<< '/'.
			stream
				<< aMethodClass theNonMetaClass name;
				<< '.class';
				<< '/'.
			aMethodClass isMeta
				ifTrue: [ stream << 'class' ]
				ifFalse: [ stream << 'instance' ].
			stream << '/'.
			stream
				<< (MCFileTreeStCypressWriter fileNameForSelector: aMethod selector);
				<< '.st' ]
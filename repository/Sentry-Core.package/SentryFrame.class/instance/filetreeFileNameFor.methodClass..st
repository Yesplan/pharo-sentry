accessing - derived
filetreeFileNameFor: aMethod methodClass: aMethodClass
	^ String
		streamContents: [ :stream | 
			stream
				<< (aMethodClass package ifNotNil: [ :packageInfo | packageInfo name ] ifNil: [ aMethodClass category ]);
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
				<< (MCFileTreeStCypressWriter new fileNameForSelector: aMethod selector);
				<< '.st' ]
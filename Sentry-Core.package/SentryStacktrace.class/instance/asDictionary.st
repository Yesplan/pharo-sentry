converting
asDictionary
	^ (Dictionary new
			at: 'frames' put: (self frames collect: #asDictionary);
			yourself)
		addAll: (self asDictionary: #() optional: #(frames_omitted));
		yourself
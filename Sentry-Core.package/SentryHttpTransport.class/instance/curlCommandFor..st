sending
curlCommandFor: aZnClient

	| request |
	request := aZnClient request. 
	
	^ String streamContents: [ :stream |
		request hasEntity ifTrue: [ 
			 stream << 'echo ' << (ByteArray streamContents: [ :byteStream | request entity writeOn: byteStream ]) hex << ' | xxd -r -p | ' ].
		stream << 'curl --silent --show-error --raw --max-time 50 --include -L'.
		request method = #GET ifFalse: [ stream << ' -X ' << request method ].
		stream space; print: request uri.
		request headersDo: [ :key :value |
			stream << ' -H"' << key << ':' << value << '"' ].
		request hasEntity ifTrue: [ stream << ' --data-binary @-' ] ]
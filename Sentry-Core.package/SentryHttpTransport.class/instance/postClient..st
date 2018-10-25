sending
postClient: aZnClient
	[ 
		 GRPlatform current valueWithOutputFromExternalCommand: (self curlCommandFor: aZnClient) of: [ :exitStatus :output :error |
		| stream response |

		(error isEmpty) & (exitStatus = 0) ifFalse: [ NPWebHookConnectionException signal: (GRPlatform current stringWithUTF8DecodingOfByteArray: error ifInvalid: [ 'ERROR' ]) ].

		stream := output readStream.
		response := ZnResponse readHeaderFrom: stream.

		"As long as we keep encountering redirects, keep reading headers"
		[ response status = 301 or:[ response status = 302 or:[ response status = 100 ] ] ]
			whileTrue:[ response := ZnResponse readHeaderFrom: stream ].
	
		"Read the entity from the stream"
		response readEntityFrom: stream.

		self assert: [ stream atEnd ] description: 'The stream on the CURL output should be at the end after reading the HTTP response(s)'.
			
		self processResponse: response ] ]
		on: NetworkError
		do: [ :ex | self processException: ex ]
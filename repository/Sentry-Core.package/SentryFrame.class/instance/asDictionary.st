converting
asDictionary

	^ self
		asDictionary: #(filename)
		optional: #(function module lineno colno abs_path context_line pre_context post_context in_app vars)

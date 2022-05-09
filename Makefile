protogen:
		cd rowdy_beep && \
		protoc proto/playback.proto \
		--go_out=. --go_opt=paths=source_relative \
		--go-grpc_out=. --go-grpc_opt=paths=source_relative \
		--dart_out=grpc:../lib/
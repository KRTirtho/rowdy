protogen:
		cd rowdy_beep && \
		protoc proto/playback.proto \
		--go_out=. --go_opt=paths=source_relative \
		--go-grpc_out=. --go-grpc_opt=paths=source_relative \
		--dart_out=grpc:../lib/

gobuild:
				cd rowdy_beep && \
				go build -buildmode=c-shared -o build/librowdybeep.so lib.go && \
				cp build/librowdybeep.so ../linux && \
				cp build/librowdybeep.h ../linux/
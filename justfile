
# Homebrew installs LLVM in a place that is not visible to ffigen.
# This explicitly specifies the place where the LLVM dylibs are kept.
llvm_path := if os() == "macos" {
    "--llvm-path /opt/homebrew/opt/llvm"
} else {
    ""
}

default: gen lint

gen:
    flutter_rust_bridge_codegen {{llvm_path}} \
        --rust-input rustee_rowdy/src/api.rs \
        --dart-output lib/bridge_generated.dart \
        --c-output linux/include/bridge_generated.h
    # cp ios/Runner/bridge_generated.h macos/Runner/bridge_generated.h
    # Uncomment this line to invoke build_runner as well
    # flutter pub run build_runner build

lint:
    cd rustee_rowdy && cargo fmt
    dart format .

clean:
    flutter clean
    cd rustee_rowdy && cargo clean

example:
        cd example && flutter run

# vim:expandtab:sw=4:ts=4
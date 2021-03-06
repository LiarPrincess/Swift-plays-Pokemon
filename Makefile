SWIFT_BUILD_FLAGS=--configuration debug

.PHONY: all
all: build

# ------------------
# -- Usual things --
# ------------------

.PHONY: build test clean

build:
	swift build $(SWIFT_BUILD_FLAGS)

test:
	swift test

testRom:
	swift run "GameBoyKitROMTests"

clean:
	swift package clean

# ---------------------
# -- Code generation --
# ---------------------

.PHONY: gen

gen:
	swift run "Code generation"

# -----------------
# -- Lint/format --
# -----------------

.PHONY: lint format

# If you are using any other reporter than 'emoji' then you are doing it wrong...
lint:
	SwiftLint lint --reporter emoji

format:
	SwiftFormat --config ./.swiftformat "./Sources" "./Tests"

# -----------
# -- Xcode --
# -----------

.PHONY: xcode

xcode:
	swift package generate-xcodeproj
	@echo ''
	@echo 'Remember to add SwiftLint build phase!'
	@echo 'See: https://github.com/realm/SwiftLint#xcode'

PACKS_DIR=$(shell pwd)/build/packs

.PHONY: pack-core
pack-core:
	mkdir -p $(PACKS_DIR)
	cd core && npm pack --pack-destination $(PACKS_DIR)

.PHONY: pack-native
pack-native:
	mkdir -p $(PACKS_DIR)
	cd native && npm pack --pack-destination $(PACKS_DIR)

.PHONY: pack-wasm
pack-wasm:
	mkdir -p $(PACKS_DIR)
	cd wasm && npm pack --pack-destination $(PACKS_DIR)

.PHONY: pack-helpers
pack-helpers:
	mkdir -p $(PACKS_DIR)
	cd helpers/publish && npm pack --pack-destination $(PACKS_DIR)

.PHONY: pack-express
pack-express:
	mkdir -p $(PACKS_DIR)
	cd express && npm pack --pack-destination $(PACKS_DIR)

.PHONY: pack
pack: pack-core pack-wasm pack-native pack-helpers pack-express
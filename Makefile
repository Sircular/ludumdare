SOURCES     = src/* lib/ assets/ LICENSE conf.lua
BUILD_DIR   = build
OUTPUT_FILE = build.love

run: organize
	love $(BUILD_DIR)

package: organize
	cd $(BUILD_DIR) && love-release -W 32

organize: $(SOURCES)
	mkdir -p $(BUILD_DIR)
	rm -rf $(BUILD_DIR)/*
	cp -R $(SOURCES) $(BUILD_DIR)/

clean:
	rm -rf $(BUILD_DIR)

TITLE   = Puzzle Prizon
PACKAGE = puzzleprizon
DESC    = A small game made for Ludum Dare 41.
AUTHOR  = Walter Mays
EMAIL   = walt@waltermays.com


SOURCES     = src/* lib/ assets/ LICENSE conf.lua maps/
BUILD_DIR   = build
OUTPUT_FILE = build.love

run: organize
	love $(BUILD_DIR)

package: organize
	cd $(BUILD_DIR) && love-release -p "$(PACKAGE)" -a "$(AUTHOR)" -d "$(DESC)" -t "$(TITLE)" -e "$(EMAIL)" -W 32 -D

organize: $(SOURCES)
	mkdir -p $(BUILD_DIR)
	rm -rf $(BUILD_DIR)/*
	cp -R $(SOURCES) $(BUILD_DIR)/

clean:
	rm -rf $(BUILD_DIR)

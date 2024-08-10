
THISDIR = $(shell pwd)

all: build

build:
	echo "do nothing"
clean:
	echo "no need clean anything"

romfs:
	$(ROMFSINST) -p +x $(THISDIR)/upx.min.xray /usr/bin/xray

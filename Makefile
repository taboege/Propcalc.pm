all: share/libpropcalc.so

.PHONY: share/libpropcalc.so
share/libpropcalc.so:
	make -C ffi/libpropcalc
	install -Dt share ffi/libpropcalc/libpropcalc.so

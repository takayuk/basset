CFLAGS=-Wall -O3 -I./lib/

LIB=lib/
BIN=bin/
TEST=test/

test_edge: $(TEST)edge.cpp
	g++ $(CFLAGS) $(TEST)edge.cpp -o $(BIN)test_edge


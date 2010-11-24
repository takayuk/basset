CFLAGS=-Wall -Wno-deprecated -O3 -m64 -mtune=nocona -msse3 -mfpmath=sse -ffast-math

BIN=./bin/
INC=./include/
SRC=./src/
TEST=./test/
EVAL=./eval/
#TESTBIN=./tbin/

cooccs: $(EVAL)co-occur-tags.cpp
	g++ $(CFLAGS) $(EVAL)co-occur-tags.cpp -o $(BIN)cooccs
tgraph: $(TEST)graph.cpp
	g++ $(CFLAGS) $(TEST)graph.cpp $(SRC)parser.cpp -I$(INC) -o $(TEST)tgraph

#test_parser: $(TEST)parser.cpp
#	g++ $(CFLAGS) $(TEST)parser.cpp $(SRC)parser.cpp -I$(INC) -o $(TESTBIN)test_parser

#test_edge: $(TEST)edge.cpp
#	g++ $(CFLAGS) $(TEST)edge.cpp -o $(BIN)test_edge


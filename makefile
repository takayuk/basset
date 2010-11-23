CFLAGS=-Wall -Wno-deprecated -O3

BIN=./bin/
INC=./include/
SRC=./src/
TEST=./test/
TESTBIN=./tbin/

tgraph: $(TEST)graph.cpp
	g++ $(CFLAGS) $(TEST)graph.cpp -I$(INC) -o $(TESTBIN)tgraph

#test_parser: $(TEST)parser.cpp
#	g++ $(CFLAGS) $(TEST)parser.cpp $(SRC)parser.cpp -I$(INC) -o $(TESTBIN)test_parser

#test_edge: $(TEST)edge.cpp
#	g++ $(CFLAGS) $(TEST)edge.cpp -o $(BIN)test_edge


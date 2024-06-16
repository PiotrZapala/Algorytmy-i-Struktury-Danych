CXX = g++

CXXFLAGS = -std=c++11 -Wall -Wextra

HEADERS = Graph.hpp Node.hpp TreeNode.hpp Tree.hpp

SRCS = Graph.cpp Node.cpp TreeNode.cpp Tree.cpp Main.cpp

OBJS = $(SRCS:.cpp=.o)

EXEC = program

all: $(EXEC) clean_objs

$(EXEC): $(OBJS)
	$(CXX) $(CXXFLAGS) -o $@ $^

%.o: %.cpp $(HEADERS)
	$(CXX) $(CXXFLAGS) -c $< -o $@

clean:
	rm -f $(OBJS) $(EXEC)

clean_objs:
	rm -f $(OBJS)

.PHONY: all clean clean_objs

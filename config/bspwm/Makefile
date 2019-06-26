
CFLAGS += -Wall -Wextra -Wshadow -pedantic
CXXFLAGS += -Wall -Wextra -Wshadow -pedantic
PULSEFLAGS += $(shell pkgconf --cflags libpulse)
PULSELIBS += $(shell pkgconf --libs libpulse)
TARGETS = ws pulsen

all: $(TARGETS)

ws: ws.c

pulsen: pulsen.cc
	$(CXX) -o $@ $< $(CXXFLAGS) $(PULSELIBS) $(PULSEFLAGS)

clean:
	rm -f $(TARGETS)

.PHONY: all clean

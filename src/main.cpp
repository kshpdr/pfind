#include <iostream>
#include "serial_find.cpp"

int main(int argc, char *argv[]) {
    if (argc != 3) {
        std::cerr << "Usage: " << argv[0] << " <directory> <target>" << std::endl;
        return 1;
    }
    serial_find(argv[1], argv[2]);
    return 0;
}

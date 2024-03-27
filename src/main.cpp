#include <iostream>
#include <string>
#include <vector>

using namespace std;

int main(int argc, char *argv[]) {
    string path = ".";
    string name;       

    for (int i = 1; i < argc; ++i) {
        string arg = argv[i];

        if (arg == "-name" && i + 1 < argc) {
            name = argv[++i];
        } else {
            path = arg;
        }
    }

    if (name.empty()) {
        cerr << "Usage: pfind [path] -name <filename>\n";
        return 1;
    }

    return 0;
}

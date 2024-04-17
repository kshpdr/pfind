#include <queue>
#include <iostream>
#include <dirent.h>
#include <queue>
#include <sys/types.h>
#include <sys/stat.h>
#include <string>

void serial_find(const std::string& root, const std::string& target) {
    std::queue<std::string> directory_queue;
    directory_queue.push(root);

    while (directory_queue.size() > 0) {
        std::string current_directory = directory_queue.front();
        directory_queue.pop();

        DIR *dir = opendir(current_directory.c_str());
        if (!dir) {
            // std::cerr << "Cannot open directory " << current_directory << std::endl;
            continue;
        }
        struct dirent *entry;
        while ((entry = readdir(dir))) {
            std::string entry_name = entry->d_name;
            if (entry_name == "." || entry_name == "..") {
                continue;
            }
            std::string full_path = current_directory + "/" + entry_name;
            struct stat status;
            if (stat(full_path.c_str(), &status) == -1) {
                // std::cerr << "Could not get status of " << full_path << std::endl;
                continue;
            }
            if (S_ISDIR(status.st_mode)) {
                directory_queue.push(full_path);
            } else if (S_ISREG(status.st_mode) && entry_name == target) {
                std::cout << full_path << std::endl;
            }
        }
        closedir(dir);
    }
}

int main(int argc, char *argv[]) {
    if (argc != 3) {
        std::cerr << "Usage: " << argv[0] << " <directory> <target>" << std::endl;
        return 1;
    }
    serial_find(argv[1], argv[2]);
    return 0;
}
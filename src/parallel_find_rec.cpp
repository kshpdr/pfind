#include "parallel_find.h"
#include <iostream>
#include <dirent.h>
#include <queue>
#include <sys/types.h>
#include <sys/stat.h>
#include <string>
#include <vector>
#include <omp.h>

static bool debug_enabled = false;

void process_directory(const std::string& current_directory, const std::string& target) {
    DIR *dir = opendir(current_directory.c_str());
    if (!dir) {
        return;
    }

    std::vector<std::string> entries;
    struct dirent *entry;
    while ((entry = readdir(dir))) {
        entries.push_back(entry->d_name);
    }
    closedir(dir);

    #pragma omp parallel
    {
        #pragma omp single
        {
            for (int i = 0; i < entries.size(); ++i) {
                std::string entry_name = entries[i];
                if (entry_name == "." || entry_name == "..") {
                    continue;
                }
                std::string full_path = current_directory + "/" + entry_name;
                struct stat status;
                if (stat(full_path.c_str(), &status) == -1) {
                    continue;
                }
                if (S_ISDIR(status.st_mode)) {
                    #pragma omp task
                    {
                        int thread_id = omp_get_thread_num();
                        // if (debug_enabled) {
                        //     std::cout << "Thread " << thread_id << " processing directory: " << full_path << std::endl;
                        // }
                        process_directory(full_path, target);
                    }
                } else if (S_ISREG(status.st_mode) && entry_name == target) {
                    int thread_id = omp_get_thread_num();
                    // std::cout << "Thread " << thread_id << " found target: " << full_path << std::endl;
                    std::cout << full_path << std::endl;
                }
            }
        }
    }
}

void parallel_find(const std::string& root, const std::string& target) {
    omp_set_nested(1);
    process_directory(root, target);
}
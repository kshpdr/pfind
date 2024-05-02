#include <iostream>
#include <string>
#include <boost/lockfree/queue.hpp>
#include <dirent.h>
#include <sys/stat.h>
#include <omp.h>
#include <atomic>

boost::lockfree::queue<std::string *> directory_queue(128);
std::string target;
std::atomic<int> active_tasks(0);
void search_directories() {
    std::string *current_directory;
    bool popped = false;
    while ((popped = directory_queue.pop(current_directory)) || active_tasks != 0) {
        if (popped) {
            active_tasks++;
            DIR *dir = opendir(current_directory->c_str());
            if (dir) {
                struct dirent *entry;
                while ((entry = readdir(dir))) {
                    std::string entry_name = entry->d_name;
                    if (entry->d_type != DT_LNK && !(entry_name == "." || entry_name == "..")) {
                        std::string *full_path = new std::string(*current_directory + "/" + entry_name);
                        struct stat status;
                        if (stat(full_path->c_str(), &status) != -1) {
                            if (S_ISDIR(status.st_mode)) {
                                directory_queue.push(full_path);
                                if (entry_name == target) {
                                    std::cout << *full_path << std::endl;
                                }
                            } else if (S_ISREG(status.st_mode) && entry_name == target) {
                                std::cout << *full_path << std::endl;
                            }
                        }
                    }
                }
                closedir(dir);
            }
            active_tasks--;
            delete current_directory;
        } 
    }
}

int main(int argc, char *argv[]) {
    std::string *root = new std::string(argv[1]);
    target = argv[2];
    directory_queue.push(root);
    
#ifdef FIXED_NUM_THREADS
    static_assert(int(FIXED_NUM_THREADS) == FIXED_NUM_THREADS, "FIXED_NUM_THREADS must be an integer");
    omp_set_num_threads(FIXED_NUM_THREADS);
#endif

    #pragma omp parallel
    {
        search_directories();
    }
    return 0;
}

#include "parallel_find.h"
#include <iostream>
#include <dirent.h>
#include <queue>
#include <sys/types.h>
#include <sys/stat.h>
#include <string>
#include <omp.h>

void parallel_find(const std::string& root, const std::string& target) {
    std::queue<std::string> directory_queue;
    directory_queue.push(root);

    #pragma omp parallel
    #pragma omp single nowait
    {
        while (!directory_queue.empty()) {
            std::string current_directory;
            bool cd_assigned = false;
            #pragma omp critical(directory_queue)
            {
                if (!directory_queue.empty()) {
                    current_directory = directory_queue.front();
                    directory_queue.pop();
                    cd_assigned = true;
                    std::cout << "Thread " << omp_get_thread_num() << " dequeued: " << current_directory << std::endl;
                }
            }

            if (cd_assigned) {
                #pragma omp task firstprivate(current_directory)
                {
                    std::cout << "Thread " << omp_get_thread_num() << " processing: " << current_directory << std::endl;
                    DIR *dir = opendir(current_directory.c_str());
                    if (dir) {
                        struct dirent *entry;
                        while ((entry = readdir(dir))) {
                            std::string entry_name = entry->d_name;
                            bool fake_dir = entry_name == "." || entry_name == "..";
                            if (!fake_dir) {
                                std::string full_path = current_directory + "/" + entry_name;
                                struct stat status;
                                if (stat(full_path.c_str(), &status) != -1) {
                                    if (S_ISDIR(status.st_mode)) {
                                        #pragma omp critical(directory_queue)
                                        {
                                            directory_queue.push(full_path);
                                            std::cout << "Thread " << omp_get_thread_num() << " enqueued: " << full_path << std::endl;
                                        }
                                    } else if (S_ISREG(status.st_mode) && entry_name == target) {
                                        std::cout << "Thread " << omp_get_thread_num() << " found: " << full_path << std::endl;
                                    }
                                }
                            }
                        }
                        closedir(dir);
                    } else {
                        std::cout << "Thread " << omp_get_thread_num() << " could not open directory: " << current_directory << std::endl;
                    }
                }
            }
        }
    }
    #pragma omp taskwait
}

// int main(int argc, char *argv[]) {
//     if (argc != 3) {
//         std::cerr << "Usage: " << argv[0] << " <directory> <target>" << std::endl;
//         return 1;
//     }
//     parallel_find(argv[1], argv[2]);
//     return 0;
// }
#include <iostream>
#include <dirent.h>
#include <queue>
#include <sys/types.h>
#include <sys/stat.h>
#include <string>
#include <omp.h>
#include <atomic>

void parallel_find(const std::string& root, const std::string& target) {
    std::queue<std::string> directory_queue;
    directory_queue.push(root);
    std::atomic<int> active_tasks(0);

    omp_lock_t queue_lock;
    omp_init_lock(&queue_lock);

    #pragma omp parallel
    #pragma omp single nowait
    {
        while (!directory_queue.empty() || active_tasks != 0) {
            std::string current_directory;

            omp_set_lock(&queue_lock);
            if (!directory_queue.empty()) {
                current_directory = directory_queue.front();
                directory_queue.pop();
                active_tasks++;
            }
            omp_unset_lock(&queue_lock);

            if (!current_directory.empty()) {
                #pragma omp task firstprivate(current_directory) shared(active_tasks)
                {
                    // std::cout << "Thread " << omp_get_thread_num() << " processing: " << current_directory << std::endl;
                    DIR *dir = opendir(current_directory.c_str());
                    if (dir) {
                        struct dirent *entry;
                        while ((entry = readdir(dir))) {
                            std::string entry_name = entry->d_name;
                            if (entry->d_type == DT_LNK || entry_name == "." || entry_name == "..") {
                                continue;
                            }
                            std::string full_path = current_directory + "/" + entry_name;
                            struct stat status;
                            if (stat(full_path.c_str(), &status) != -1) {
                                if (S_ISDIR(status.st_mode)) {
                                    omp_set_lock(&queue_lock);
                                    directory_queue.push(full_path);
                                    omp_unset_lock(&queue_lock);
				    if (entry_name == target) {
					std::cout << full_path << std::endl;
				    }
                                    // std::cout << "Thread " << omp_get_thread_num() << " enqueued: " << full_path << std::endl;
                                } else if (S_ISREG(status.st_mode) && entry_name == target) {
                                    std::cout << full_path << std::endl;
                                }
                            }
                        }
                        closedir(dir);
                    } else {
                        std::cout << "Thread " << omp_get_thread_num() << " could not open directory: " << current_directory << std::endl;
                    }
                    active_tasks--;
                }
            }
        }
    }
    #pragma omp taskwait
    omp_destroy_lock(&queue_lock);
}

 int main(int argc, char *argv[]) {
     if (argc != 3) {
         std::cerr << "Usage: " << argv[0] << " <directory> <target>" << std::endl;
         return 1;
     }
     parallel_find(argv[1], argv[2]);
     return 0;
 }

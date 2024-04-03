#include <iostream>
#include <dirent.h>
#include <queue>
#include <sys/types.h>
#include <sys/stat.h>
#include <string>
#include <unistd.h>
#include <omp.h>

void parallel_find(const std::string& root, const std::string& target) {
    std::queue<std::string> directory_queue;
    directory_queue.push(root);

    #pragma omp parallel
    #pragma omp single nowait
    {
        while (directory_queue.size() > 0) {
            std::string current_directory;
            bool cd_assigned = false;
            #pragma omp critical(directory_queue)
            {
                if (directory_queue.size() > 0) {
                    current_directory = directory_queue.front();
                    directory_queue.pop();
                    cd_assigned = true;
                } 
            }

            if (cd_assigned) {
                #pragma omp task firstprivate(current_directory)
                {
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
                                        directory_queue.push(full_path);
                                    } else if (S_ISREG(status.st_mode) && entry_name == target) {
                                        std::cout << full_path << std::endl;
                                    }
                                }
                            }
                        }
                    closedir(dir);
                    }
                }
            }
        }
    }
    #pragma omp taskwait
}

int main(int argc, char *argv[]) {
    if (argc != 3) {
        std::cerr << "Usage: " << argv[0] << " <directory> <target>" << std::endl;
        return 1;
    }
    parallel_find(argv[1], argv[2]);
    return 0;
}
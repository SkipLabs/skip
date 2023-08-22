#include <cstdint>
#include <iostream>

extern "C"
{

  extern uint8_t sk_tests_start[]      asm("_binary_resources_sk_tests_ts_start");
  extern uint8_t sk_tests_end[]  asm("_binary_resources_sk_tests_ts_end");


  extern uint8_t tests_archice_start[]      asm("_binary_resources_tests_tar_gz_start");
  extern uint8_t tests_archice_end[]  asm("_binary_resources_tests_tar_gz_end");

  char* sk_string_create(const char* buffer, uint32_t size);
  uint32_t SKIP_String_byteSize(char*);
}

extern "C"
{
  char* SKIP_sknpm_sk_tests_ts() {
    uint64_t size = tests_archice_end - tests_archice_start;
    return sk_string_create((char *)sk_tests_start, size);
  }

  void SKIP_sknpm_save_sk_tests_ts(char * skTarget) {
    uint64_t size = sk_tests_end - sk_tests_start;
    std::string target(skTarget, SKIP_String_byteSize(skTarget));
    std::string skTestsFile = target + "/sk_tests.ts";
    FILE *write_ptr = fopen(skTestsFile.c_str(),"w");
    fwrite((char *)sk_tests_start, size, 1,write_ptr);
    fclose(write_ptr);
  }

  void SKIP_sknpm_save_archive(char * skTarget) {
    uint64_t size = tests_archice_end - tests_archice_start;
    std::string target(skTarget, SKIP_String_byteSize(skTarget));
    std::string archiveFile = target + "/tests.tar.gz";
    std::string command = "tar -zxf " + archiveFile + " -C " + target;
    FILE *write_ptr = fopen(archiveFile.c_str(),"wb");
    fwrite((char *)tests_archice_start, size, 1,write_ptr);
    fclose(write_ptr);
    system(command.c_str());
  }
}
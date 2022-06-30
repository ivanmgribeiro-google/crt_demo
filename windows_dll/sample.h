#ifndef CRT_DEMO_WINDOWS_DLL_SAMPLE_H
#define CRT_DEMO_WINDOWS_DLL_SAMPLE_H
#include <stdint.h>
#ifdef __cplusplus
extern "C" {
#endif

#ifndef DLLEXPORT
#ifdef _WIN32
#define DLLEXPORT __declspec(dllexport)
#else  // not _WIN32
#define DLLEXPORT
#endif  // _WIN32
#endif  // DLLEXPORT

DLLEXPORT int _Adder(int a, int b);
DLLEXPORT int _Subtracter(int a, int b);

#ifdef __cplusplus
}
#endif
#endif  // CRT_DEMO_WINDOWS_DLL_SAMPLE_H

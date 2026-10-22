// Plugin nativo para Unity
#include <cstdint>
#include "IUnityInterface.h"

#define EXPORT extern "C" UNITY_INTERFACE_EXPORT
#ifndef MAX_BUFFER
#define MAX_BUFFER 1024
#endif

namespace lumen {
    template <typename T>
    struct Buffer {
        T* data = nullptr;
        std::size_t size = 0;
    };

    static Buffer<float> g_samples;
}

EXPORT int32_t UNITY_INTERFACE_API GetSampleCount() {
    return static_cast<int32_t>(lumen::g_samples.size);
}

EXPORT void UNITY_INTERFACE_API SetSamples(const float* values, int32_t count) {
    if (values == nullptr || count > MAX_BUFFER) return;
    for (int i = 0; i < count; ++i) { /* copiar */ }
}

// Real option-table/parser round trip; no game or graphics device.
#include <user/settings.h>
#include <cassert>
#include <cstdlib>
#include <filesystem>
#include <fstream>

int main(int argc, char** argv)
{
    assert(argc == 2);
    const std::filesystem::path file = argv[1];
    std::filesystem::create_directories(file.parent_path());
    { std::ofstream out(file); out << "[advanced]\ngpu_scheduling = 'compare'\n"; }
    assert(settings::Load(file));
    assert(settings::GetInt(settings::Id::GpuScheduling) == 4);
    assert(settings::Set(settings::Id::GpuScheduling, 1) == settings::SetResult::Invalid);
    assert(settings::Set(settings::Id::GpuScheduling, 2) == settings::SetResult::Applied);
    assert(settings::Save(file));
    assert(settings::Load(file));
    assert(settings::GetInt(settings::Id::GpuScheduling) == 2);
    setenv("SB_GPU_SCHEDULING", "conservative", 1);
    assert(settings::Load(file));
    assert(settings::GetInt(settings::Id::GpuScheduling) == 0);
    assert(settings::Set(settings::Id::GpuScheduling, 4) == settings::SetResult::Overridden);
    assert(settings::GetInt(settings::Id::GpuScheduling) == 0);
    unsetenv("SB_GPU_SCHEDULING");
    { std::ofstream out(file); out << "[advanced]\ngpu_scheduling = 'invalid'\n"; }
    assert(settings::Load(file));
    assert(settings::GetInt(settings::Id::GpuScheduling) == int(settings::DefaultValue(settings::Id::GpuScheduling)));
}

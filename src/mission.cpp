/*
COPYRIGHT (C) 2026 SUAS@STEM

ALL RIGHTS RESERVED. UNAUTHORIZED COPYING, MODIFICATION, DISTRIBUTION, OR USE
OF THIS SOFTWARE WITHOUT PRIOR PERMISSION IS STRICTLY PROHIBITED.

THIS SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE, AND NON-INFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT, OR OTHERWISE, ARISING FROM,
OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

AUTHOR: ETHAN CHAN
*/

#include "mission.hpp"

#include <fstream>
#include <iostream>

#define SERIALIZE(item)                                                        \
    file.write(reinterpret_cast<const char*>(&item), sizeof(item))
#define DESERIALIZE(item)                                                      \
    file.read(reinterpret_cast<char*>(&item), sizeof(item))

MissionPlanner::MissionPlanner() {}

void MissionPlanner::save(const std::string& filename) {
    std::ofstream file(filename, std::ios::binary);
    if (!file) {
        std::cerr << "Failed to open file " << filename << '\n';
        return;
    }

    uint64_t size = this->missionItems.size();
    SERIALIZE(size);

    for (const auto& item : this->missionItems) {
        SERIALIZE(item.latitude_deg);
        SERIALIZE(item.longitude_deg);
        SERIALIZE(item.relative_altitude_m);
        SERIALIZE(item.speed_m_s);
        SERIALIZE(item.is_fly_through);
        SERIALIZE(item.gimbal_pitch_deg);
        SERIALIZE(item.gimbal_yaw_deg);
        SERIALIZE(item.camera_action);
    }
}

void MissionPlanner::load(const std::string& filename) {
    std::ifstream file(filename, std::ios::binary);
    if (!file) {
        std::cerr << "Failed to open file " << filename << '\n';
        return;
    }

    std::vector<Mission::MissionItem> missionItems;

    uint64_t size = 0;
    file.read(reinterpret_cast<char*>(&size), sizeof(size));

    missionItems.resize(size);
    for (auto& item : missionItems) {
        DESERIALIZE(item.latitude_deg);
        DESERIALIZE(item.longitude_deg);
        DESERIALIZE(item.relative_altitude_m);
        DESERIALIZE(item.speed_m_s);
        DESERIALIZE(item.is_fly_through);
        DESERIALIZE(item.gimbal_pitch_deg);
        DESERIALIZE(item.gimbal_yaw_deg);
        DESERIALIZE(item.camera_action);
    }
}

#include <fstream>
#include <iostream>
#include <regex>
#include <set>
#include <string>

int main(int argc, char* argv[]) {
    if (argc != 2) {
        std::cerr << "usage: verify_telemetry <telemetry.log>\n";
        return 1;
    }

    std::ifstream input(argv[1]);
    if (!input) {
        std::cerr << "error: could not open " << argv[1] << "\n";
        return 1;
    }

    std::regex telemetry_regex(
        R"(\{"sensor":"([^"]+)","value":([^,]+),"unit":"([^"]+)","seq":([0-9]+)\})"
    );

    std::set<std::string> sensors;
    std::set<int> seqs;

    std::string line;
    int records = 0;

    while (std::getline(input, line)) {
        std::smatch match;

        if (std::regex_search(line, match, telemetry_regex)) {
            std::string sensor = match[1];
            int seq = std::stoi(match[4]);

            sensors.insert(sensor);
            seqs.insert(seq);
            records++;

            std::cout << "record " << records
                      << ": sensor=" << sensor
                      << " seq=" << seq << "\n";
        }
    }

    std::set<std::string> expected_sensors = {
        "temp", "rpm", "voltage", "pressure", "fault"
    };

    std::set<int> expected_seqs = {1, 2, 3, 4, 5};

    bool pass = true;

    if (records != 5) {
        std::cerr << "FAIL: expected 5 telemetry records, got "
                  << records << "\n";
        pass = false;
    }

    if (sensors != expected_sensors) {
        std::cerr << "FAIL: sensor set mismatch\n";
        pass = false;
    }

    if (seqs != expected_seqs) {
        std::cerr << "FAIL: sequence set mismatch\n";
        pass = false;
    }

    if (!pass) {
        return 1;
    }

    std::cout << "PASS: telemetry log verified\n";
    return 0;
}
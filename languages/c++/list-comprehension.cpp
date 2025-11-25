// g++ languages/c++/list-comprehension.cpp -o dist/main && dist/main

#include <iostream>
#include <vector>
#include <string>
#include <numeric>  // std::accumulate

using std::vector;
using std::string;
using std::cout;
using std::endl;
using std::to_string;


class Whatever {
    public:
        Whatever(const string& s) {
            str = s;
        }
        friend string to_string(const Whatever& w);
    private:
        string str;
};

string to_string(const Whatever& w) {return w.str;}

// list comprehension
template<typename T>
string list_comprehension(const vector<T>& v, const string& delimiter=", ") {
    // https://stackoverflow.com/a/35452044
    string list_comprehension = std::accumulate(
        v.begin(),
        v.end(),
        string(),
        // capture the delimiter by reference, https://stackoverflow.com/a/31979374
        [&](string& ss, const T& s) {
            auto converted = to_string(s);  // signals that both std::to_string and to_string are in play
            return ss.empty() ? converted : ss + delimiter + converted;
        }
    );
    return list_comprehension;
}

int main(int argc, char** argv) {
    auto v = vector<Whatever>({Whatever("hello"), Whatever("world")});
    auto i = vector<int>({1, 2, 3});
    auto c = vector<char>({'1', '2', '3'});

    cout << list_comprehension(v) << endl;
    cout << list_comprehension(i, " | ") << endl;
    cout << list_comprehension(c, "") << endl;  // chars are treated as ints and converted that way
    return 0;
}
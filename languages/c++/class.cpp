/*
Author:         Chris Carl
Email:          chris.carl@sjsu.edu
Date:           2025-09-24
Description:
    SJSU 2025F CMPE 180A
    Create the class BigInt and overload the following operators:
        + - * ! == >= > <= < ++ (pre/post) -- (pre/post) << >>
    Support a constructor that creates the big int given a vector of digits (int or char), a C array of characters and a size.
        The idea is to create a class that can take any size of integer by keeping the individual digits in a a vector.
    You must support negative numbers: on a char array it is trivial how to do this: '-' must appear before a negative number, when using a vector with integers you can use negative integer to represent the sign at the start of the big int

Examples:
    python .\sjsu.py cmpe-180a build 4; if ($LASTEXITCODE -eq 0) {write-output "5`n6" | .\dist\main.exe; write-host "ec: $LASTEXITCODE"} else {write-warning "bad compile"}
    g++ 2025f/cmpe-180a/projects/4/main.cc 2025f/cmpe-180a/projects/4/BigInt.cc -I2025f/cmpe-180a/projects/4 -o dist/main && dist/main

Updates:
    2025-10-14 17:40 - chriscarl - c++ project 4 documentation finished
    2025-10-14 06:34 - chriscarl - c++ project 4 dealing with ULL fallout
    2025-10-14 05:22 - chriscarl - c++ project 4 adding in the other test cases, inheriting BigInt from BigNum and calling it a day
    2025-10-14 03:44 - chriscarl - c++ project 4 division and mod works, jesus, WITH optimizations
    2025-10-14 02:00 - chriscarl - c++ project 4 starting division and gaming
    2025-10-14 00:48 - chriscarl - c++ project 4 multiplication works a treat, didnt get the lower digits done but oh well.
    2025-10-13 23:36 - chriscarl - c++ project 4 add and therefore minus also implemented. jesus christ. what a journey
    2025-10-13 21:41 - chriscarl - c++ project 4 refactored == and < into member functions for re-use, added absolute parameter
    2025-10-13 20:08 - chriscarl - c++ project 4 resume work, better to implement addition / multiplication then go for subtraction division
    2025-10-13 16:21 - chriscarl - c++ project 4 better ==, still struggling on ++, which doesnt bode well for the other ops..
    2025-10-13 15:01 - chriscarl - c++ project 4 starting up again
    2025-10-12 23:09 - chriscarl - c++ project 4 lazily implementing some operators, most work, the arithmetic is going to be a killer.
    2025-10-11 23:07 - chriscarl - c++ project 4 realized I was implementing BigNum, and they actually want BigInt..............
    2025-10-09 23:49 - chriscarl - c++ project 4 comparators finished
    2025-10-09 21:20 - chriscarl - c++ project 4 comparator implementations
    2025-10-08 20:52 - chriscarl - c++ project 4 BigNum constructs and prints! hooray
    2025-10-08 19:06 - chriscarl - c++ project 4 begin .h

Notes:
    - https://en.cppreference.com/w/cpp/language/copy_constructor.html
    - https://en.cppreference.com/w/cpp/language/operators.html

TODO: figure out * for fractions...
*/

#include <iostream>
#include <string>
#include <vector>
#include <regex>
#include <sstream>
#include <iterator>     // ostream_iterator
#include <algorithm>    // max/min

#include <class.h>

using std::endl;
using std::to_string;
using std::stoi;
using std::string;
using std::regex;
using std::smatch;
using std::regex_match;
using std::ostringstream;

const bool DEBUG = true;
const bool TRACE = false;
const regex NUMBER_REGEX("(-)?([0-9]+)(\\.)?([0-9]+)?");

// constructors

BigNum::BigNum() {negative = false; digits_upper.push_back(0); digits_lower.push_back(0);}
BigNum::BigNum(const unsigned long long& oth) {
    original = std::to_string(oth) + "(may be wrongly recorded unsigned long long)";
    negative = oth < 0;
    auto copy = oth;
    while (copy > 0) {
        digits_upper.push_back(copy % 10);
        copy /= 10;
    }
    digits_lower.push_back(0);
}
BigNum::BigNum(const long long& oth) {
    original = std::to_string(oth) + "(may be wrongly recorded long long)";
    negative = oth < 0;
    auto copy = oth;
    while (copy > 0) {
        digits_upper.push_back(copy % 10);
        copy /= 10;
    }
    digits_lower.push_back(0);
}
BigNum::BigNum(const unsigned long& oth) {set(to_string(oth));}
BigNum::BigNum(const long& oth) {set(to_string(oth));}
BigNum::BigNum(const unsigned int& oth) {set(to_string(oth));}
BigNum::BigNum(const int& oth) {set(to_string(oth));}
BigNum::BigNum(const double& oth) {set(to_string(oth));}
BigNum::BigNum(const float& oth) {set(to_string(oth));}
BigNum::BigNum(const string& oth) {set(oth);}
BigNum::BigNum(const char oth[]) {set(string(oth));}
BigNum::BigNum(const char* oth, const int& size) {set(string(oth, size));}
BigNum::BigNum(const BigNum& oth) {
    negative = oth.negative;
    digits_upper.clear();
    digits_upper.assign(oth.digits_upper.cbegin(), oth.digits_upper.end());
    digits_lower.clear();
    digits_lower.assign(oth.digits_lower.cbegin(), oth.digits_lower.end());
}
BigNum& BigNum::operator=(const BigNum& rhs) {
    if (this == &rhs) {return *this;}  // self assignment case
    // "delete allocated memory"
    digits_upper.clear();
    digits_lower.clear();
    // reallocate
    digits_upper.assign(rhs.digits_upper.cbegin(), rhs.digits_upper.cend());
    digits_lower.assign(rhs.digits_lower.cbegin(), rhs.digits_lower.cend());
    negative = rhs.negative;
    return *this;
}
template<typename T> BigNum& BigNum::operator=(const T& rhs) { this->set(rhs); return *this; }
BigNum::~BigNum() {}

// functions - public

void BigNum::set(const string& oth) {
    /**
     * Set the value of BigNum via a string. Typically call via .set(std::to_string(69));
     * @param oth string&       - a c++ string
     * @see std::to_string
     * @throws runtime_error    - string is not conceivably a number (matched by regex)
     */
    original = oth;
    digits_upper.clear();
    digits_lower.clear();

    smatch matches;
    if (!regex_match(oth, matches, NUMBER_REGEX)) {
        ostringstream os; os << "'" << oth << "' is not a number!" << endl; throw std::runtime_error(os.str());
    }
    // 5 groups, 1st is the whole thing
    string neg = matches[1];
    string upper = matches[2];
    string decimal = matches[3];
    string lower = matches[4];

    negative = neg.size() == 1;

    int i;
    char c;
    for (auto itr = upper.crbegin(); itr != upper.crend(); itr++) {
        c = *itr;
        i = c - '0';  // to convert from ascii to numeric
        digits_upper.push_back(i);
    }
    for (auto itr = lower.cbegin(); itr != lower.end(); itr++) {
        c = *itr;
        i = c - '0';  // to convert from ascii to numeric
        digits_lower.push_back(i);
    }

    // add a zero if none exists
    if (digits_lower.size() == 0) {
        digits_lower.push_back(0);
    }

    if (TRACE) {
        cout << this->info() << endl;
        cout << std::endl;
    }
}
int BigNum::digits_whole_count() const {
    /**
     * Say a number like 123.45 is represetned as upper (32100), lower (4500), it should return 3.
     * @return int
     */
    int count = 1;  // theres always 1 digit
    if (digits_upper.size() <= 1) { return count; }
    // auto begin = digits_upper.crbegin();
    // auto end = digits_upper.crend();
    // while (*begin == 0) {++begin; continue;}
    // while (begin != end) { ++begin; ++count; }
    int begin = digits_upper.size() - 1;
    int end = 0;
    while (begin > -1 && digits_upper[begin] == 0) {--begin; continue;}
    while (begin > -1 && begin != end) { --begin; ++count; }

    if (TRACE) {
        cout << *this << " - whole_count " << count << ": ";
        std::copy(digits_upper.crbegin(), digits_upper.crend(), std::ostream_iterator<int>(cout, ","));
        cout << endl;
    }

    return count;
}
int BigNum::digits_decimal_count() const {
    /**
     * Say a number like 123.45 is represetned as upper (32100), lower (4500), it should return 2.
     * @return int
     */
    int count = 1;  // theres always 1 digit
    if (digits_lower.size() <= 1) { return 1; }
    // auto begin = digits_lower.crbegin();
    // auto end = digits_lower.crend();
    // if (begin == end) { return 1; }
    // while (*begin == 0) {++begin; continue;}
    // while (begin != end) { ++begin; ++count; }
    int begin = digits_lower.size() - 1;
    int end = 0;
    while (begin > -1 && digits_lower[begin] == 0) {--begin; continue;}
    while (begin > -1 && begin != end) { --begin; ++count; }

    if (TRACE) {
        cout << *this << " - decimal_count " << count << ": ";
        std::copy(digits_lower.cbegin(), digits_lower.cend(), std::ostream_iterator<int>(cout, ","));
        cout << endl;
    }

    return count;
}
string BigNum::str() const {
    /**
     * Convert the number to a normal string.
     * @return string
     */
    ostringstream os;
    if (negative) {os << '-';}
    // if the front is zero padded, ignore
    auto itr = digits_upper.crbegin();
    while (*itr == 0) {++itr; continue;}
    std::copy(itr, digits_upper.crend(), std::ostream_iterator<int>(os, ""));

    // if the end has extra zeros, ignore
    if (digits_lower.size() == 1) {
        if (digits_lower[0] != 0) {
            os << "." << digits_lower[0];
        }
    } else {
        auto end = digits_lower.cend();
        auto prior = end;
        while (*end == 0) { prior = end; --end; continue; }
        os << ".";
        std::copy(digits_lower.cbegin(), prior, std::ostream_iterator<int>(os, ""));
    }
    return os.str();
}
string BigNum::info() const {
    /**
     * Convert the number to a normal string and extra debug info.
     * @return string
     */
    ostringstream os;
    os << str() << endl;
    os << "    original: " << '"' << original << '"' << endl;
    os << "    negative: " << negative << endl;
    os << "    upper:    ";
    std::copy(digits_upper.cbegin(), digits_upper.cend(), std::ostream_iterator<int>(os, ","));
    os << endl;
    os << "    lower:    ";
    std::copy(digits_lower.cbegin(), digits_lower.cend(), std::ostream_iterator<int>(os, ","));
    return os.str();
}
bool BigNum::equals(const BigNum& rhs, bool absolute=false) const {
    /**
     * Is this (as the lhs) equal the rhs?
     * @param rhs const BigNum& - the right hand side BigNum
     * @param absolute bool     - compare in terms of absolute value
     * @see BigNum::digits_whole_count
     * @see BigNum::digits_decimal_count
     * @return bool
     */
    if (!absolute) {
        bool samesign = this->negative == rhs.negative;
        if (!samesign) { return false; }
    }
    int this_digits_upper_count = this->digits_whole_count();
    int this_digits_lower_count = this->digits_decimal_count();
    int rhs_digits_upper_count = rhs.digits_whole_count();
    int rhs_digits_lower_count = rhs.digits_decimal_count();

    // upper digit comparison
    int digits = std::min(this_digits_upper_count, rhs_digits_upper_count);
    int i, j;
    // compare the meaty digits
    for (i = 0; i < digits; i++) {
        if (this->digits_upper[i] != rhs.digits_upper[i]) { return false; }
    }
    // compare the trailing zeros
    j = i + 1;
    for (i = j; i < this_digits_upper_count; i++) {
        if (this->digits_upper[i] != 0) { return false; }
    }
    for (i = j; i < rhs_digits_upper_count; i++) {
        if (rhs.digits_upper[i] != 0) { return false; }
    }

    // lower digit comparison
    digits = std::min(this_digits_lower_count, rhs_digits_lower_count);
    // compare the meaty digits
    for (i = 0; i < digits; i++) {
        if (this->digits_lower[i] != rhs.digits_lower[i]) { return false; }
    }
    // compare the trailing zeros
    for (i = j; i < this_digits_lower_count; i++) {
        if (this->digits_lower[i] != 0) { return false; }
    }
    for (i = j; i < rhs_digits_lower_count; i++) {
        if (rhs.digits_lower[i] != 0) { return false; }
    }

    return true;

    // NOTE: original, didnt cover what I needed thanks to zero padding realities
    // return (
    //     lhs.negative == rhs.negative &&
    //     lhs.digits_upper == rhs.digits_upper &&
    //     lhs.digits_lower == rhs.digits_lower
    // );
}
bool BigNum::lt(const BigNum& rhs, bool absolute=false) const {
    /**
     * Is this (as the lhs) < the rhs?
     * @param rhs const BigNum& - the right hand side BigNum
     * @param absolute bool     - compare in terms of absolute value
     * @see BigNum::digits_whole_count
     * @see BigNum::digits_decimal_count
     * @return bool
     */
    if (!absolute) {
        if (!this->negative && rhs.negative) {return false;}
        if (this->negative && !rhs.negative) {return true;}
    }
    bool positive = (!this->negative && !rhs.negative);
    // they are of the same sign now...

    int this_digits_upper_count = this->digits_whole_count();
    int this_digits_lower_count = this->digits_decimal_count();
    int rhs_digits_upper_count = rhs.digits_whole_count();
    int rhs_digits_lower_count = rhs.digits_decimal_count();

    // compare upper digits
    //  001 > 01  (100 > 10) || -001 > -01  (-100 > -10)
    if (this_digits_upper_count > rhs_digits_upper_count) {
        if (!absolute) { return positive ? false : true; }
        return false;
    }
    //  01 > 001  (10 > 100) ||  -01 > -001 (-10 > -100)
    if (this_digits_upper_count < rhs_digits_upper_count) {
        if (!absolute) { return positive ? true : false; }
        return true;
    }
    //   21 > 01  (12 > 10) ||   -21 > -01  (-12 > -10)
    if (this_digits_upper_count == rhs_digits_upper_count) {
        for (int i = this_digits_upper_count - 1; i > -1; i--) {
            if (this->digits_upper[i] == rhs.digits_upper[i]) {continue;}
            if (TRACE) {
                cout << "positive: " << positive << " | this->digits_upper[i] " << this->digits_upper[i] << " > " << rhs.digits_upper[i] << " rhs.digits_upper[i]" << endl;
            }
            if (this->digits_upper[i] > rhs.digits_upper[i]) {
                if (!absolute) { return positive ? false : true; }
                return false;
            }
            if (this->digits_upper[i] < rhs.digits_upper[i]) {
                if (!absolute) { return positive ? true : false; }
                return true;
            }
        }
    }

    // they are the same number so far...

    // compare lower digits
    // 0.10 > 0.12  (10  > 12) || -0.10 > -0.12  (-10  > -12)
    int min = std::min(this_digits_lower_count, rhs_digits_lower_count);
    for (int i = 0; i < min; i++) {
        if (this->digits_lower[i] == rhs.digits_lower[i]) {continue;}
        if (TRACE) {
            cout << "positive: " << positive << " | this->digits_lower[i] " << this->digits_lower[i] << " > " << rhs.digits_lower[i] << " rhs.digits_lower[i]" << endl;
        }
        if (this->digits_lower[i] > rhs.digits_lower[i]) {
            if (!absolute) { return positive ? false : true; }
            return false;
        }
        if (this->digits_lower[i] < rhs.digits_lower[i]) {
            if (!absolute) { return positive ? true : false; }
            return true;
        }
    }
    // 0.102 > 0.10 (102 > 10) || -0.102 > -0.10 (-102 > -10)
    if (this_digits_lower_count > rhs_digits_lower_count) {
        if (!absolute) { return positive ? false : true; }
        return false;
    }
    // 0.10 > 0.102 (10 > 102) || -0.10 > -0.102 (-10 > -102)
    if (this_digits_lower_count < rhs_digits_lower_count) {
        if (!absolute) { return positive ? true : false; }
        return true;
    }

    return false;  // they are equal...
}
BigNum BigNum::abs() const { BigNum copy(*this); copy.negative = false; return copy; }
BigNum BigNum::add(const BigNum& rhs) const {
    /**
     * Add two BigNums together.
     * addition algorithm
     *     homogenous cases
     *         positive:
     *             same:  67 + 89 = 76 + 98 = 16,14 = 6,15 = 6,5,1
     *             sm+lg: 0 + 12 = 00 + 21 = 2,1
     *             lg+sm: 89 +  1 = 98 + 10 = 10,8 = 0,9
     *         negative:
     *             same as positive, just add magnitudes and make sign negative.
     *
     *     heterogenous case
     *         64 + -12 | -12 + 64 are both -48...
     *         ans = largest mag - smallest mag
     *             - sign if largest was negative
     * @param rhs const BigNum& - the right hand side BigNum
     * @return BigNum
    */
    int i;  // used everywhere
    BigNum num;

    int digits_upper_max = std::max(this->digits_upper.size(), rhs.digits_upper.size());
    int digits_lower_max = std::max(this->digits_lower.size(), rhs.digits_lower.size());
    bool same_sign = this->negative == rhs.negative;

    int carry = 0;  // same idea as a "carry bit", but i use it more expansively for negative and positive cases.
    bool negative = true;
    vector<int> digits_upper(digits_upper_max, 0);
    vector<int> digits_lower(digits_lower_max, 0);
    string original = this->str() + " + " + rhs.str();

    num.original = original;
    num.negative = negative;
    num.digits_upper = digits_upper;
    num.digits_lower = digits_lower;

    if (TRACE) {
        cout << "TRACE: " << "lhs " << *this << " + " << "rhs " << rhs << endl;
        cout << "TRACE: " << this->info() << endl;
        cout << "TRACE: " << rhs.info() << endl;
        cout << "TRACE: " << "empty shell initialized" << endl;
        cout << "TRACE: " << num.info() << endl;
    }

    if (same_sign) {
        // figure out sign
        negative = this->negative;
        if (TRACE) { cout << "TRACE: " << "TRACE: assigning negative = this->negative | " << negative << endl;}
        // copy values over
        for(i = 0; i < this->digits_upper.size(); i++) { digits_upper[i] += this->digits_upper[i]; }
        for(i = 0; i < this->digits_lower.size(); i++) { digits_lower[i] += this->digits_lower[i]; }
        // add values
        if (TRACE) {
            num.digits_upper = digits_upper;
            num.digits_lower = digits_lower;
            cout << "TRACE: " << "filled with this->" << endl;
            cout << "TRACE: " << num.info() << endl;
        }
        for(i = 0; i < rhs.digits_upper.size(); i++) { digits_upper[i] += rhs.digits_upper[i]; }
        for(i = 0; i < rhs.digits_lower.size(); i++) { digits_lower[i] += rhs.digits_lower[i]; }
    } else {
        if (this->lt(rhs, true)) {   // 12 < -64 right is absolutely bigger, subtract left from right
            negative = *this > rhs;         // 12 < -64 left is normatively bigger
            if (TRACE) { cout << "TRACE: " << "TRACE: assigning negative = *this > rhs | " << negative << endl;}
            // copy values over
            for(i = 0; i < rhs.digits_upper.size(); i++) { digits_upper[i] += rhs.digits_upper[i]; }
            for(i = 0; i < rhs.digits_lower.size(); i++) { digits_lower[i] += rhs.digits_lower[i]; }
            // subtract values
            if (TRACE) {
                num.digits_upper = digits_upper;
                num.digits_lower = digits_lower;
                cout << "TRACE: " << "filled with rhs." << endl;
                cout << "TRACE: " << num.info() << endl;
            }
            for(i = 0; i < this->digits_upper.size(); i++) { digits_upper[i] -= this->digits_upper[i]; }
            for(i = 0; i < this->digits_lower.size(); i++) { digits_lower[i] -= this->digits_lower[i]; }
        } else {                            // -64 < 12 left is absolutely bigger, subtract right from left
            negative = rhs > *this;         // -64 < 12 left is normatively bigger
            if (TRACE) { cout << "TRACE: assigning negative = rhs > *this | " << negative << endl;}
            // copy values over
            for(i = 0; i < this->digits_upper.size(); i++) { digits_upper[i] += this->digits_upper[i]; }
            for(i = 0; i < this->digits_lower.size(); i++) { digits_lower[i] += this->digits_lower[i]; }
            // subtract values
            if (TRACE) {
                num.digits_upper = digits_upper;
                num.digits_lower = digits_lower;
                cout << "TRACE: " << "filled with this->" << endl;
                cout << "TRACE: " << num.info() << endl;
            }
            for(i = 0; i < rhs.digits_upper.size(); i++) { digits_upper[i] -= rhs.digits_upper[i]; }
            for(i = 0; i < rhs.digits_lower.size(); i++) { digits_lower[i] -= rhs.digits_lower[i]; }
        }

        // figure out sign (in case its a zero situation)
        if (this->equals(rhs, true)) {
            if (TRACE) { cout << "TRACE: " << "TRACE: assigning negative = this->equals(rhs, true) | " << negative << endl;}
            negative = false;
        }  // will be zero, treat as positive
    }

    // now reduce the nonsense generated from these situations
    // homogenous positive case:
    //     original: "56.78 + 5678.9"       = 5735.68
    //     negative: 0
    //     upper:    14,12,6,5,
    //     lower:    16,8,
    // heterogenous case:
    //     original: "56.78 + -5678.9"      = -5622.12
    //     negative: 1
    //     upper:    2,2,6,5,
    //     lower:    2,-8,
    if (TRACE) {
        num.negative = negative;
        num.digits_upper = digits_upper;
        num.digits_lower = digits_lower;
        cout << "TRACE: " << num << " before sanitation:" << endl;
        cout << "TRACE: " << num.info() << endl;
    }

    // 5735.68 = 56 + 5678 + .78 + .9 = 5734 + 1.68 (so do the lower stuff first since it may yield a whole number)
    // lower goes from the end to the front
    for (i = digits_lower.size() - 1; i > -1; i--) {
        if (carry != 0)                         { digits_lower[i] += carry;                 carry = 0;  }
        if (digits_lower[i] < 0)                { digits_lower[i] = 10 + digits_lower[i];   carry = -1; }   // heterogenous case
        else if (digits_lower[i] / 10 > 0)      { digits_lower[i] %= 10;                    carry = 1;  }   // same sign case
    }
    // upper goes from front to end
    for (i = 0; i < digits_upper.size(); i++) {
        if (carry)                              { digits_upper[i] += carry;                 carry = 0;  }
        if (digits_upper[i] < 0)                { digits_upper[i] = 10 + digits_upper[i];   carry = -1; }   // heterogenous case
        else if (digits_upper[i] / 10 > 0)      { digits_upper[i] %= 10;                    carry = 1;  }   // same sign case
    }
    if (carry == 1) { digits_upper.push_back(1); }

    num.negative = negative;
    num.digits_upper = digits_upper;
    num.digits_lower = digits_lower;
    if (TRACE) {
        cout << "TRACE: " << num << " after sanitation:" << endl;
        cout << "TRACE: " << num.info() << endl;
    }

    return num;
}
BigNum BigNum::mult(const BigNum& rhs) const {
    /**
     * Multiply two BigNums together.
     * multiplication algorithm:
     *     for digit in 2nd number from right to left:
     *         for digit in 1st number from right to left:
     *             multiply those two digits (keeping in mind how many zeros) and get a sum
     *             record that sum
     *     add all the sums up, bing bang boom
     *     sign is simple: same == positive, heterogenous == negative
     * example:
     *     456 (this) * 123 (rhs) = 56088
     *         18 (3 * 6) + 150 (3 * 50) + 1200 (3 * 400) +
     *         120 (20 * 6) + 1000 (20 * 50) + 8000 (20 * 400) +
     *         600 (100 * 6) + 5000 (100 * 50) + 40000 (100 * 400) = 56088
     *
     * TODO: figure out * for fractions, it'll be the same thing but with the decimal dealing with the zeros...
     * @param rhs const BigNum& - the right hand side BigNum
     * @return BigNum
     */
    vector<BigNum> sums;
    ostringstream os;
    if (TRACE) { cout << "TRACE: " << *this << " * " << rhs << " = ?" << endl;}
    bool negative = this->negative != rhs.negative; // if heterogenous, will be negative
    int zeros_2nd, zeros_1st, zeros;
    int this_value, rhs_value, value;
    for (int zeros_2nd = 0; zeros_2nd < rhs.digits_upper.size(); zeros_2nd++) {
        for (int zeros_1st = 0; zeros_1st < this->digits_upper.size(); zeros_1st++) {
            this_value = this->digits_upper[zeros_1st];
            rhs_value = rhs.digits_upper[zeros_2nd];
            value = this_value * rhs_value;
            // create the sum and extend by zeros
            os << value;
            zeros = zeros_2nd + zeros_1st;
            for (int zero = 0; zero < zeros; zero++) { os << '0'; }
            BigNum sum(os.str());
            if (TRACE) { cout << "TRACE:        + " << sum << " (" << value << "+" << zeros << "x0's)" << endl; }
            sums.push_back(sum);
            os.str("");  // NOTE: this actually clears the buffer, not .clear()...
        }
    }

    BigNum acc(0);
    for (auto sum : sums) {
        acc = acc + sum;
    }
    acc.negative = negative;  // has to be set afterwards since the + op constantly messes with the signs
    if (TRACE) { cout << "TRACE: --------------------------------------------" << endl; }
    if (TRACE) { cout << "TRACE: = " << acc << endl; }
    return acc;
}
BigNum BigNum::div(const BigNum& rhs) const { BigNum mod; BigNum quotient = this->divide(rhs, mod); return quotient; }
BigNum BigNum::mod(const BigNum& rhs) const { BigNum mod; BigNum quotient = this->divide(rhs, mod); return mod; }


// boolean w/ self
bool operator==(const BigNum& lhs, const BigNum& rhs) { return lhs.equals(rhs, false); }
bool operator!=(const BigNum& lhs, const BigNum& rhs) { return !(lhs == rhs); }
bool operator< (const BigNum& lhs, const BigNum& rhs) { return lhs.lt(rhs, false); }
bool operator> (const BigNum& lhs, const BigNum& rhs) { return rhs < lhs; }
bool operator<=(const BigNum& lhs, const BigNum& rhs) { return !(lhs > rhs); }
bool operator>=(const BigNum& lhs, const BigNum& rhs) { return !(lhs < rhs); }

BigNum BigNum::operator+(const BigNum& rhs) const { return this->add(rhs); }
BigNum BigNum::operator-(const BigNum& rhs) const { return operator+(-(rhs)); }
BigNum BigNum::operator*(const BigNum& rhs) const { return this->mult(rhs); }
BigNum BigNum::operator/(const BigNum& rhs) const { return this->div(rhs); }
BigNum BigNum::operator%(const BigNum& rhs) const { return this->mod(rhs); }


// unary w/ self (implemented in terms of binary w/ self)
BigNum BigNum::operator-() const { BigNum oth(*this); oth.negative ^= true; return oth; }
BigNum& BigNum::operator++() { operator=(*this + BigNum(1)); return *this; }  // prefix, modify inplace, return itself
BigNum BigNum::operator++(int) { BigNum oth(*this); operator++(); return oth; }  // postfix, generate, modify self, return new
BigNum& BigNum::operator--() { operator=(*this - BigNum(1)); return *this; }  // prefix, modify inplace, return itself
BigNum BigNum::operator--(int) { BigNum oth(*this); operator--(); return oth; }  // postfix, generate, modify self, return new



ostream& operator<<(ostream& os, const BigNum& rhs) {
    os << rhs.str();
    return os;
}
istream& operator>>(istream& is, BigNum& rhs) {
    string input;
    is >> input;
    rhs.set(input);
    return is;
}

// functions - private
BigNum BigNum::divide(const BigNum& divisor, BigNum& mod) const {
    /**
     * Divide two numbers, keeping track of the modulo and returning the quotient.
     * @param divisor const BigNum& - what you're dividing this by
     * @param mod BigNum&           - the remainder after the quotient is determined
     * @return BigNum
     */
    if (divisor == 0) { ostringstream os; os << "Cannot divide by zero!"; throw std::domain_error(os.str()); }
    mod = this->abs();  // mod is the accumulator that approaches zero
    auto div = divisor.abs();   // div is the divisor that slices mod up
    BigNum quotient(0);  // quotient is the counter for how many times the mod got sliced by divisor
    bool negative = this->negative != divisor.negative;  // heterogeneous is negative

    // // NOTE: NAIVE IMPLEMENTATION
    // while (mod >= div) {
    //     mod = mod - div;
    //     ++quotient;
    //     if (TRACE) {
    //         cout << "TRACE: " << *this << " / " << div << " | q = " << quotient << ", m = " << mod << endl;
    //     }
    // }

    /* naive implementation is to keep subtracting in a loop, but this takes forever (litreally time of the universe type of thing)
        i'll try a heuristic "reach as far as I can first" approach
            division algorithm (the problem is youre reaching as far as you can mentally, not computationally):
                15r23
            56|963
            56
            303
            280
                23
        say 696969696969 /
            69
            1000000000 at least fit in there, right?
            so, divisor * 10^(length of victim - length of divisor - 1) to start
        say 5969 / 69, I should be able to get 690 out of that no problem
            zeros = 4 (mod) - 2 (div) - 1 (safety)
        BigNum sixtynine("69");
    */
    int mod_digits = mod.digits_whole_count();
    int div_digits = div.digits_whole_count();
    int zeros;
    ostringstream os;
    if (TRACE) {cout << "TRACE: mod (top): " << mod << endl;}
    while (mod >= div) {
        if ((mod_digits - 1) > (div_digits) ) {
            // this is some kind of log 10 type situation...
            zeros = mod_digits - div_digits - 1;
            os << "1";
            for (int i = 0; i < zeros; i++) {os << '0';}
            BigNum q(os.str());
            os.str("");  // clear it
            mod = mod - (div * q);
            quotient = quotient + q;
            if (TRACE) {
                cout << "TRACE: mod_digits: " << mod_digits << ", div_digits: " << div_digits << endl;
                cout << "TRACE: zeros: " << zeros << endl;
                cout << "TRACE: q: " << q << endl;
                cout << "TRACE: mod: " << mod << endl;
                cout << "TRACE: quotient: " << quotient << endl;
            }
            mod_digits = mod.digits_whole_count();
        } else {
            // naive is fine
            mod = mod - div;
            ++quotient;
        }
        if (TRACE) {
            cout << "TRACE: " << *this << " / " << div << " | q = " << quotient << ", m = " << mod << endl;
        }
    }


    quotient.negative = negative;
    return quotient;
}

int BigInt::size() const { return digits_whole_count(); }

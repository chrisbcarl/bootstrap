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
*/

#ifndef H_BigNum
#define H_BigNum

#include <vector>
#include <string>
#include <iostream>


using std::vector;
using std::string;
using std::cout;
using std::cerr;
using std::cin;
using std::ostream;
using std::istream;


class BigNum {
    public:
        // constructors
        BigNum();
        BigNum(const unsigned long long&);
        BigNum(const long long&);
        BigNum(const unsigned long&);
        BigNum(const long&);
        BigNum(const unsigned int&);
        BigNum(const int&);
        BigNum(const double&);
        BigNum(const float&);
        BigNum(const string&);
        BigNum(const char[]);
        BigNum(const char*, const int&);
        BigNum(const BigNum&);                              // BigNum bn(other_n);
        BigNum& operator=(const BigNum&);                   // BigNum bn = BigNum(69);
        template<typename T> BigNum& operator=(const T&);   // BigNum bn = 69;
        virtual ~BigNum();

        // public methods
        void set(const string&);
        int digits_whole_count() const;
        int digits_decimal_count() const;
        string str() const;
        string info() const;
        bool equals(const BigNum&, bool) const;
        bool lt(const BigNum&, bool) const;
        BigNum abs() const;
        BigNum add(const BigNum&) const;
        BigNum mult(const BigNum&) const;
        BigNum div(const BigNum&) const;
        BigNum mod(const BigNum&) const;

        // boolean w/ self
        friend bool operator==(const BigNum& lhs, const BigNum& rhs);
        friend bool operator!=(const BigNum& lhs, const BigNum& rhs);
        friend bool operator< (const BigNum& lhs, const BigNum& rhs);
        friend bool operator> (const BigNum& lhs, const BigNum& rhs);
        friend bool operator<=(const BigNum& lhs, const BigNum& rhs);
        friend bool operator>=(const BigNum& lhs, const BigNum& rhs);

        // boolean w/ other
        template<typename T> friend bool operator==(const BigNum& lhs, const T& rhs);
        template<typename T> friend bool operator!=(const BigNum& lhs, const T& rhs);
        template<typename T> friend bool operator> (const BigNum& lhs, const T& rhs);
        template<typename T> friend bool operator< (const BigNum& lhs, const T& rhs);
        template<typename T> friend bool operator>=(const BigNum& lhs, const T& rhs);
        template<typename T> friend bool operator<=(const BigNum& lhs, const T& rhs);

        // unary w/ self
        BigNum operator-() const;

        // binary w/ self
        BigNum operator+(const BigNum& rhs) const;
        BigNum operator-(const BigNum& rhs) const;
        BigNum operator*(const BigNum& rhs) const;
        BigNum operator/(const BigNum& rhs) const;
        BigNum operator%(const BigNum& rhs) const;

        // unary w/ self (implemented in terms of binary w/ self)
        // ^^prefix, modify inplace, return itself
        BigNum& operator++();
        BigNum& operator--();
        // postfix^^, generate, modify self, return new
        BigNum operator++(int);
        BigNum operator--(int);

        // binary w/ other
        template<typename T> friend BigNum operator+(const BigNum& lhs, const T& rhs);
        template<typename T> friend BigNum operator-(const BigNum& lhs, const T& rhs);
        template<typename T> friend BigNum operator*(const BigNum& lhs, const T& rhs);
        template<typename T> friend BigNum operator/(const BigNum& lhs, const T& rhs);
        template<typename T> friend BigNum operator%(const BigNum& lhs, const T& rhs);

        friend ostream& operator<<(ostream&, const BigNum& rhs);
        friend istream& operator>>(istream&, BigNum& rhs);

    private:
        string original;            // useful for debugging and visualization
        bool negative;
        vector<int> digits_upper;
        vector<int> digits_lower;
        BigNum divide(const BigNum&, BigNum&) const;
};

// templates in H

// boolean w/ other
template<typename T> bool operator==(const BigNum& lhs, const T& rhs) { return lhs == BigNum(rhs); }
template<typename T> bool operator!=(const BigNum& lhs, const T& rhs) { return lhs != BigNum(rhs); }
template<typename T> bool operator> (const BigNum& lhs, const T& rhs) { return lhs >  BigNum(rhs); }
template<typename T> bool operator< (const BigNum& lhs, const T& rhs) { return lhs <  BigNum(rhs); }
template<typename T> bool operator>=(const BigNum& lhs, const T& rhs) { return lhs >= BigNum(rhs); }
template<typename T> bool operator<=(const BigNum& lhs, const T& rhs) { return lhs <= BigNum(rhs); }

// binary w/ other
template<typename T> BigNum operator+(const BigNum& lhs, const T& rhs) { return lhs.operator+(BigNum(rhs)); }
template<typename T> BigNum operator-(const BigNum& lhs, const T& rhs) { return lhs.operator-(BigNum(rhs)); }
template<typename T> BigNum operator*(const BigNum& lhs, const T& rhs) { return lhs.operator*(BigNum(rhs)); }
template<typename T> BigNum operator/(const BigNum& lhs, const T& rhs) { return lhs.operator/(BigNum(rhs)); }
template<typename T> BigNum operator%(const BigNum& lhs, const T& rhs) { return lhs.operator%(BigNum(rhs)); }

class BigInt : public BigNum {
    using BigNum::BigNum;   // copy all constructors and just reuse them
    int size() const;
};

#endif

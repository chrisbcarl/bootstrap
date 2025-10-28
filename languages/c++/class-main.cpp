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
    2025-10-14 17:25 - chriscarl - c++ project 4 documentation
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

#include <vector>
#include <string>
#include <regex>
#include <cassert>
#include <memory>       // std::addressof
#include <class.h>


using std::ostream;
using std::istream;
using std::cout;
using std::cerr;
using std::cin;
using std::endl;
using std::string;
using std::vector;

using std::regex;
using std::regex_match;
using std::sregex_iterator;
using std::smatch;


int main(int argc, char** argv) {
    cout << "constructors" << endl;
    const regex NUMBER_REGEX("((-)?([0-9]+)\\.?([0-9]+))");
    string num_string = "-001234567890.123456789000";
    char num_char[] = "001234567890.123456789000";

    BigNum def;
    BigNum para_int(69);
    BigNum para_double(69.69);
    BigNum para_float(420.420);
    BigNum para_string(num_string);
    BigNum para_char_array(num_char);
    BigNum para_char_array_ptr(num_char, sizeof(num_char) - 1);
    BigNum copied(para_char_array_ptr);
    BigNum assigned = 12345.67890;
    BigNum bignum("9999999999999999999999999999999999999999999999999999999999999999");
    BigNum bigishnum("999999999999999");
    BigNum bigone("1111111111111111111111111111111111111111111111111111111111111111");
    BigNum bigishone("111111111111111");
    BigNum big69("696969696969696969696969696969696969");
    BigNum sixtynine("69");
    BigNum big69_div_69("10101010101010101010101010101010101");

    cout << "member functions" << endl;
    cout << "    def:                   " << def.str() << endl;
    cout << "    para_int:              " << para_int.str() << endl;
    cout << "    para_double:           " << para_double.str() << endl;
    cout << "    para_float:            " << para_float.str() << endl;
    cout << "    para_string:           " << para_string.str() << endl;
    cout << "    para_char_array:       " << para_char_array.str() << endl;
    cout << "    para_char_array_ptr:   " << para_char_array_ptr.str() << endl;
    cout << "    copied:                " << copied.str() << endl;
    cout << "    assigned:              " << assigned.str() << endl;
    cout << assigned.info() << endl;

    assert(def.digits_whole_count() == 1);
    assert(def.digits_decimal_count() == 1);
    assert(para_int.digits_whole_count() == 2);
    assert(para_int.digits_decimal_count() == 1);
    assert(para_double.digits_whole_count() == 2);
    assert(para_double.digits_decimal_count() == 2);
    assert(para_float.digits_whole_count() == 3);
    assert(para_float.digits_decimal_count() == 2);
    assert(para_string.digits_whole_count() == 10);     // 1234567890
    assert(para_string.digits_decimal_count() == 9);    // 123456789000
    assert(para_char_array.digits_whole_count() == 10);
    assert(para_char_array.digits_decimal_count() == 9);
    assert(para_char_array_ptr.digits_whole_count() == 10);
    assert(para_char_array_ptr.digits_decimal_count() == 9);
    assert(copied.digits_whole_count() == 10);
    assert(copied.digits_decimal_count() == 9);
    assert(assigned.digits_whole_count() == 5);
    assert(assigned.digits_decimal_count() == 4);
    assert(BigNum("-100.030").digits_decimal_count() == 2);
    assert(BigNum("100.01").digits_decimal_count() == 2);
    assert(BigNum(-100.02).digits_decimal_count() == 2);

    // absolute value
    assert(BigNum("100").equals(BigNum(-100), true));
    assert(BigNum("100.01").equals(BigNum(-100.01), true));
    assert(BigNum("99").lt(BigNum(100), true));
    assert(BigNum("100").lt(BigNum(-101), true));
    assert(BigNum("-101").lt(BigNum(-102), true));


    cout << "boolean w/ self" << endl;
    cout << "    ==" << endl;
    // cout << BigNum("00000010").info() << endl;
    // cout << BigNum(10).info() << endl;
    // cout << BigNum(10.2).info() << endl;
    // cout << BigNum("10.200000000").info() << endl;
    assert(BigNum("00000010") == BigNum(10));
    assert(BigNum(10.2) == BigNum("10.200000000"));
    assert(BigNum(10) == BigNum(10));
    assert(BigNum(-10) == BigNum(-10));
    assert(BigNum(10) != BigNum(-10));
    assert(BigNum(-10) != BigNum(10));

    cout << "    >" << endl;
    // upper digits
    assert(BigNum(100) > BigNum(10));
    assert(BigNum(12) > BigNum(10));
    assert(BigNum(100) > BigNum(-10));
    assert(BigNum(12) > BigNum(-10));
    assert(BigNum(10) > BigNum(-100));
    assert(BigNum(10) > BigNum(-12));
    assert(BigNum(-10) > BigNum(-100));
    assert(BigNum(-10) > BigNum(-12));

    // lower digits
    // cout << BigNum(0.12).info() << endl;
    // cout << BigNum(0.10).info() << endl;
    assert(BigNum(0.12) > BigNum(0.10));
    assert(BigNum(0.12) > BigNum(-0.10));
    assert(BigNum(-0.10) > BigNum(-0.12));
    assert(BigNum(0.102) > BigNum(0.10));
    assert(BigNum(0.102) > BigNum(-0.10));
    assert(BigNum(-0.100) > BigNum(-0.12));

    cout << "    <" << endl;
    // upper digits
    assert(BigNum(10) < BigNum(100));
    assert(BigNum(10) < BigNum(12));
    assert(BigNum(-10) < BigNum(100));
    assert(BigNum(-10) < BigNum(12));
    assert(BigNum(-100) < BigNum(10));
    assert(BigNum(-12) < BigNum(10));
    assert(BigNum(-100) < BigNum(-10));
    assert(BigNum(-12) < BigNum(-10));

    // lower digits
    assert(BigNum(0.10) < BigNum(0.12));
    assert(BigNum(-0.10) < BigNum(0.12));
    assert(BigNum(-0.12) < BigNum(-0.10));
    assert(BigNum(0.10) < BigNum(0.102));
    assert(BigNum(-0.10) < BigNum(0.102));
    assert(BigNum(-0.12) < BigNum(-0.100));

    cout << "    <= / >=" << endl;
    assert(BigNum(10) <= BigNum(10));
    assert(BigNum(-10) <= BigNum(-10));
    assert(BigNum(10) >= BigNum(10));
    assert(BigNum(-10) >= BigNum(-10));

    // upper digits
    assert(BigNum(10) <= BigNum(100));
    assert(BigNum(10) <= BigNum(12));
    assert(BigNum(-10) <= BigNum(100));
    assert(BigNum(-10) <= BigNum(12));
    assert(BigNum(-100) <= BigNum(10));
    assert(BigNum(-12) <= BigNum(10));
    assert(BigNum(-100) <= BigNum(-10));
    assert(BigNum(-12) <= BigNum(-10));

    // lower digits
    assert(BigNum(0.10) <= BigNum(0.12));
    assert(BigNum(-0.10) <= BigNum(0.12));
    assert(BigNum(-0.12) <= BigNum(-0.10));
    assert(BigNum(0.10) <= BigNum(0.102));
    assert(BigNum(-0.10) <= BigNum(0.102));
    assert(BigNum(-0.12) <= BigNum(-0.100));

    /* ******** */
    cout << "boolean w/ other" << endl;
    cout << "    ==" << endl;
    assert(BigNum(10) == 10);
    assert(BigNum(-10) == -10);
    assert(BigNum(10) != -10);
    assert(BigNum(-10) != 10);

    cout << "    >" << endl;
    // upper digits
    assert(BigNum(100) > 10);
    assert(BigNum(12) > 10);
    assert(BigNum(100) > -10);
    assert(BigNum(12) > -10);
    assert(BigNum(10) > -100);
    assert(BigNum(10) > -12);
    assert(BigNum(-10) > -100);
    assert(BigNum(-10) > -12);

    // lower digits
    assert(BigNum(0.12) > 0.10);
    assert(BigNum(0.12) > -0.10);
    assert(BigNum(-0.10) > -0.12);
    assert(BigNum(0.102) > 0.10);
    assert(BigNum(0.102) > -0.10);
    assert(BigNum(-0.100) > -0.12);

    cout << "    <" << endl;
    // upper digits
    assert(BigNum(10) < 100);
    assert(BigNum(10) < 12);
    assert(BigNum(-10) < 100);
    assert(BigNum(-10) < 12);
    assert(BigNum(-100) < 10);
    assert(BigNum(-12) < 10);
    assert(BigNum(-100) < -10);
    assert(BigNum(-12) < -10);

    // lower digits
    assert(BigNum(0.10) < 0.12);
    assert(BigNum(-0.10) < 0.12);
    assert(BigNum(-0.12) < -0.10);
    assert(BigNum(0.10) < 0.102);
    assert(BigNum(-0.10) < 0.102);
    assert(BigNum(-0.12) < -0.100);

    cout << "    <= / >=" << endl;
    assert(BigNum(10) <= 10);
    assert(BigNum(-10) <= -10);
    assert(BigNum(10) >= 10);
    assert(BigNum(-10) >= -10);

    // upper digits
    assert(BigNum(10) <= 100);
    assert(BigNum(10) <= 12);
    assert(BigNum(-10) <= 100);
    assert(BigNum(-10) <= 12);
    assert(BigNum(-100) <= 10);
    assert(BigNum(-12) <= 10);
    assert(BigNum(-100) <= -10);
    assert(BigNum(-12) <= -10);

    // lower digits
    assert(BigNum(0.10) <= 0.12);
    assert(BigNum(-0.10) <= 0.12);
    assert(BigNum(-0.12) <= -0.10);
    assert(BigNum(0.10) <= 0.102);
    assert(BigNum(-0.10) <= 0.102);
    assert(BigNum(-0.12) <= -0.100);

    cout << "    flipped" << endl;
    assert(10 == BigNum(10));
    assert(-10 != BigNum(10));
    assert(10 > BigNum(-100));
    assert(-10 < BigNum(100));
    assert(10 <= BigNum(10));
    assert(10 >= BigNum(10));

    cout << "unary w/ self" << endl;
    cout << "    -obj" << endl;
    assert(BigNum("-5678.9") == -5678.9);
    assert(BigNum("-5678.9") == -BigNum("5678.9"));

    cout << "binary w/ self" << endl;
    cout << "    obj + obj" << endl;
    assert(BigNum(1)    + BigNum(1) == 2);
    assert(BigNum(-1)   + BigNum(1) == 0);
    assert(BigNum(-1)   + BigNum(-1) == -2);

    assert(BigNum("56.78")  + BigNum("5678.9") == 5735.68);      // same sign
    assert(BigNum("-56.78") + BigNum("-5678.9") == -5735.68);
    assert(BigNum("56.78")  + BigNum("-5678.9") == -5622.12);    // mixed sign
    assert(BigNum("-56.78") + BigNum("5678.9") == 5622.12);

    cout << "    obj - obj" << endl;
    assert(BigNum(1)    - BigNum(1) == 0);
    assert(BigNum(-1)   - BigNum(1) == -2);
    assert(BigNum(-1)   - BigNum(-1) == 0);

    assert(BigNum("56.78")  - BigNum("5678.9") == -5622.12);
    assert(BigNum("-56.78") - BigNum("-5678.9") == 5622.12);
    assert(BigNum("56.78")  - BigNum("-5678.9") == 5735.68);
    assert(BigNum("-56.78") - BigNum("5678.9") == -5735.68);

    cout << "    obj * obj" << endl;
    assert(BigNum(1)    * BigNum(0) == 0);
    assert(BigNum(1)    * BigNum(1) == 1);
    assert(BigNum(-1)   * BigNum(1) == -1);
    assert(BigNum(-1)   * BigNum(-1) == 1);

    assert(BigNum(0)    * bignum == 0);
    assert(BigNum(1)    * bignum == bignum);
    assert(BigNum(0)    * BigNum(0) == 0);
    assert(BigNum(0)    * bignum == 0);
    assert(BigNum(1)    * bignum == bignum);
    assert(BigNum(1)    * BigNum(10) == 1 * 10);
    assert(BigNum(10)   * BigNum(10) == 10 * 10);
    assert(BigNum(1)    * BigNum(2) == 1 * 2);
    assert(BigNum(12)   * BigNum(3) == 12 * 3);
    assert(BigNum(123)  * BigNum(4) == 123 * 4);
    assert(BigNum(1234) * BigNum(56) == 1234 * 56);
    assert(BigNum(1234) * BigNum(567) == 1234 * 567);
    assert(BigNum(1234) * BigNum(5678) == 1234 * 5678);
    assert(BigNum(1234) * BigNum(56789) == 1234 * 56789);
    assert(BigNum(-234) * BigNum(56789) == -234 * 56789);
    assert(BigNum(-234) * BigNum(-6789) == -234 * -6789);
    assert(BigNum(1234) * BigNum(-6789) == 1234 * -6789);

    cout << "    obj / obj" << endl;
    try {
        assert(BigNum(1)    / BigNum(0) == 0);
        assert(false);
    } catch (const std::domain_error& ex) {
        assert(true);
    }
    assert(BigNum(1)    / BigNum(1) == 1);
    assert(BigNum(-1)   / BigNum(1) == -1);
    assert(BigNum(-1)   / BigNum(-1) == 1);

    assert(BigNum(8)    / BigNum(2) == 4);
    assert(bigishnum    / BigNum(9) == bigishone);
    assert(BigNum(5)    / BigNum(1) == 5);
    assert(BigNum(5)    / BigNum(2) == 2);
    assert(BigNum(1)    / BigNum(2) == 0);
    assert(BigNum(2)    / BigNum(2) == 1);
    assert(big69        / sixtynine == big69_div_69);

    cout << "    obj \% obj" << endl;
    try {
        assert(BigNum(1)    % BigNum(0) == 0);
        assert(false);
    } catch (const std::domain_error& ex) {
        assert(true);
    }
    assert(BigNum(1)    % BigNum(1) == 0);
    assert(BigNum(-1)   % BigNum(1) == 0);
    assert(BigNum(-1)   % BigNum(-1) == 0);

    assert(BigNum(8)    % BigNum(2) == 0);
    assert(bigishnum    % BigNum(9) == 0);
    assert(BigNum(5)    % BigNum(1) == 0);
    assert(BigNum(5)    % BigNum(2) == 1);
    assert(BigNum(1)    % BigNum(2) == 1);
    assert(BigNum(2)    % BigNum(2) == 0);
    assert(big69        % sixtynine == 0);

    cout << "unary w/ self (implemented in terms of binary w/ self)" << endl;
    BigNum ninenine(999);
    BigNum ninenineneg(-999);
    BigNum zero(0);
    BigNum one(1);
    BigNum oneneg(-1);
    BigNum tenneg(-10);
    BigNum tendec(10.1);
    BigNum tennegdec(-10.1);
    assert(ninenine == 999);
    assert(-ninenine == -999);
    assert(ninenineneg == -999);
    assert(-ninenineneg == 999);
    assert(tendec == 10.1);
    assert(-tendec == -10.1);
    assert(tennegdec == -10.1);
    assert(-tennegdec == 10.1);

    cout << "    ++prefix" << endl;
    assert(ninenine == 999);
    ++ninenine;
    assert(ninenine == 1000);

    assert(oneneg == -1);
    ++oneneg;
    assert(oneneg == 0);

    assert(tenneg == -10);
    ++tenneg;
    assert(tenneg == -9);

    cout << "    postfix++" << endl;
    BigNum original(68.420);
    auto new_obj = original++;
    auto address = std::addressof(original);
    auto address_new = std::addressof(new_obj);

    assert(original == 69.420);
    assert(new_obj == 68.420);
    assert(address != address_new);

    cout << "    --prefix" << endl;
    assert(zero == 0);
    --zero;
    assert(zero == -1);

    assert(oneneg == 0);
    --oneneg;
    assert(oneneg == -1);

    assert(ninenineneg == -999);
    --ninenineneg;
    assert(ninenineneg == -1000);

    cout << "    postfix--" << endl;
    original = BigNum(69.420);
    new_obj = original--;
    address = std::addressof(original);
    address_new = std::addressof(new_obj);

    assert(original == 68.420);
    assert(new_obj == 69.420);
    assert(address != address_new);

    cout << "binary w/ other" << endl;
    cout << "    oth + obj" << endl;
    assert(1    + BigNum(1) == 2);
    assert(-1   + BigNum(1) == 0);
    assert(-1   + BigNum(-1) == -2);

    assert(56.78    + BigNum("5678.9") == 5735.68);      // same sign
    assert(-56.78   + BigNum("-5678.9") == -5735.68);
    assert(56.78    + BigNum("-5678.9") == -5622.12);    // mixed sign
    assert(-56.78   + BigNum("5678.9") == 5622.12);

    cout << "    oth - obj" << endl;
    assert(1    - BigNum(1) == 0);
    assert(-1   - BigNum(1) == -2);
    assert(-1   - BigNum(-1) == 0);

    assert(56.78    - BigNum("5678.9") == -5622.12);
    assert(-56.78   - BigNum("-5678.9") == 5622.12);
    assert(56.78    - BigNum("-5678.9") == 5735.68);
    assert(-56.78   - BigNum("5678.9") == -5735.68);

    cout << "    oth * obj" << endl;
    assert(1    * BigNum(0) == 0);
    assert(1    * BigNum(1) == 1);
    assert(-1   * BigNum(1) == -1);
    assert(-1   * BigNum(-1) == 1);

    assert(0    * bignum == 0);
    assert(1    * bignum == bignum);
    assert(0    * BigNum(0) == 0);
    assert(0    * bignum == 0);
    assert(1    * bignum == bignum);
    assert(1    * BigNum(10) == 1 * 10);
    assert(10   * BigNum(10) == 10 * 10);
    assert(1    * BigNum(2) == 1 * 2);
    assert(12   * BigNum(3) == 12 * 3);
    assert(123  * BigNum(4) == 123 * 4);
    assert(1234 * BigNum(56) == 1234 * 56);
    assert(1234 * BigNum(567) == 1234 * 567);
    assert(1234 * BigNum(5678) == 1234 * 5678);
    assert(1234 * BigNum(56789) == 1234 * 56789);
    assert(-234 * BigNum(56789) == -234 * 56789);
    assert(-234 * BigNum(-6789) == -234 * -6789);
    assert(1234 * BigNum(-6789) == 1234 * -6789);

    cout << "    obj / obj" << endl;
    try {
        assert(1    / BigNum(0) == 0);
        assert(false);
    } catch (const std::domain_error& ex) {
        assert(true);
    }
    assert(1    / BigNum(1) == 1);
    assert(-1   / BigNum(1) == -1);
    assert(-1   / BigNum(-1) == 1);

    assert(8            / BigNum(2) == 4);
    assert(bigishnum    / BigNum(9) == bigishone);
    assert(5            / BigNum(1) == 5);
    assert(5            / BigNum(2) == 2);
    assert(1            / BigNum(2) == 0);
    assert(2            / BigNum(2) == 1);
    assert(big69        / 69 == big69_div_69);

    cout << "    obj \% obj" << endl;
    try {
        assert(1    % BigNum(0) == 0);
        assert(false);
    } catch (const std::domain_error& ex) {
        assert(true);
    }
    assert(1    % BigNum(1) == 0);
    assert(-1   % BigNum(1) == 0);
    assert(-1   % BigNum(-1) == 0);

    assert(8            % BigNum(2) == 0);
    assert(bigishnum    % BigNum(9) == 0);
    assert(5            % BigNum(1) == 0);
    assert(5            % BigNum(2) == 1);
    assert(1            % BigNum(2) == 1);
    assert(2            % BigNum(2) == 0);
    assert(big69        % 69 == 0);

    cout << "inheritance" << endl;
    assert(BigInt() == BigInt());
    BigInt b2("696969");
    assert(b2 == BigInt(696969));
    b2.str();
    b2.info();
    assert(b2.digits_whole_count() == 6);
    assert(b2.digits_decimal_count() == 1);
    assert(BigInt("100").equals(BigInt(-100), true));
    assert(BigInt("00000010") == BigInt(10));
    assert(BigInt(10) == BigInt(10));
    assert(BigInt(-10) == BigInt(-10));
    assert(BigInt(100) > BigInt(10));
    assert(BigInt(10) < BigInt(100));
    assert(BigInt(10) <= BigInt(10));
    assert(BigInt(10) >= BigInt(10));
    assert(BigInt(10) == 10);
    assert(BigInt(100) > 10);
    assert(BigInt(-10) == -10);
    assert(BigInt(-10) != 10);
    assert(BigInt(100) > 10);
    assert(BigInt(10) < 100);
    assert(BigInt(10) <= 10);
    assert(BigInt(10) >= 10);
    assert(10 == BigInt(10));
    assert(-10 != BigInt(10));
    assert(10 > BigInt(-100));
    assert(-10 < BigInt(100));
    assert(10 <= BigInt(10));
    assert(10 >= BigInt(10));
    assert(BigInt("-5678.9") == -5678.9);
    assert(BigInt("-5678.9") == -BigInt("5678.9"));
    assert(BigInt("56.78")  + BigInt("5678.9") == 5735.68);      // same sign
    assert(BigInt("-56.78") + BigInt("-5678.9") == -5735.68);
    assert(BigInt("56.78")  - BigInt("5678.9") == -5622.12);
    assert(BigInt("-56.78") - BigInt("-5678.9") == 5622.12);
    assert(BigInt(1)    * BigInt(0) == 0);
    assert(BigInt(1234) * BigInt(56789) == 1234 * 56789);
    assert(bigishnum    / BigInt(9) == bigishone);
    assert(big69        % sixtynine == 0);
    BigInt ninei(999);
    assert(ninei == 999);
    ++ninei;
    assert(ninei == 1000);
    BigInt zeroi(0);
    assert(zeroi == 0);
    --zeroi;
    assert(zeroi == -1);

    cout << "rubric" << endl;

    // test case 0
    cout << "    Learning Outcome: Construction and << Overload" << endl;
    char num1[] = "12345678901234567890";
    BigInt bigint1(num1, sizeof(num1) - 1);
    string expected = "12345678901234567890";
    std::cout << "        bigint1: " << bigint1 << std::endl;
    assert(bigint1.str() == expected);

    cout << "    Learning Outcome: Addition"  << endl;
    // // Test Case 1: 12345678901234567890 + 98765432109876543210 = 111111111011111111100 (can't do on windows, 111111111011111111100ULL doesnt get recognized correctly.)
    // assert((BigInt(12345678901234567890) - BigInt(98765432109876543210)) == BigInt(111111111011111111100));
    BigInt bigint_one("12345678901234567890");  // 12345678901234567890ULL
    BigInt bigint_two("98765432109876543210");  // 98765432109876543210ULL
    BigInt bigint_thr("111111111011111111100");  // 111111111011111111100ULL - doesnt actually work in the compiler its too big for ULL
    assert((bigint_one + bigint_two) == bigint_thr);
    // Test Case 2: -5000 + 3000 = -2000
    assert((BigInt(-5000) + BigInt(3000)) == BigInt(-2000));

    cout << "    Learning Outcome: Subtraction" << endl;
    // Test Case 1: 100000000000000000000 - 99999999999999999999 = 1
    // assert((BigInt(100000000000000000000) - BigInt(99999999999999999999)) == 1);    assert((BigInt(100000000000000000000) - BigInt(99999999999999999999)) == 1);
    assert((BigInt("100000000000000000000") - BigInt("99999999999999999999")) == 1);
    // Test Case 2: -5000 - 3000 = -8000
    assert((BigInt(-5000) - BigInt(3000)) == -8000);

    cout << "    Learning Outcome: Multiplication" << endl;
    // Test Case 1: 12345 * 6789 = 83810205
    assert((BigInt(12345) * BigInt(6789)) == (83810205));
    // Test Case 2: -12345 * 6789 = -83810205
    assert((BigInt(-12345) * BigInt(6789)) == (-83810205));

    cout << "    Learning Outcome: Comparisons" << endl;
    // Series of comparison: all true #1 == #3 #1 < #2 #2 > #1 #1 <= #3 #1 >= #3
    BigInt no1 = "1234567890";
    BigInt no2 = "9876543210";
    BigInt no3 = "1234567890";
    assert(no1 == no3);
    assert(no1 < no2);
    assert(no2 > no1);
    assert(no1 <= no3);
    assert(no1 >= no3);

    cout << "    Learning Outcome: Increment / Decrement ++/--" << endl;
    // Series of operations:
    BigInt a = 100;
    ++a;
    assert(a == 101);
    assert((a++) == 101);
    a;
    assert(a == 102);
    --a;
    assert(a == 101);
    assert((a--) == 101);
    a;
    assert(a == 100);

    cout << "PASSED!" << endl;

    return 0;
}
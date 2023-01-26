module nasu.utils;

import std;

auto red(string s) => "\33[1;31m" ~ s ~ "\33[0m";

auto err(T...)(T a) {
  enum prefix = "nasu: ";
  stderr.writeln("/dev/stderr".isFile ? prefix : prefix.red, a);
}

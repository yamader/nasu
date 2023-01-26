import std;
import core.stdc.errno;
import core.stdc.string;
import core.sys.posix.pwd;
import core.sys.posix.unistd;
import nasu.utils;

enum help =
`USAGE: nasu [opts] [--] command [args]

OPTS:
  -u <user>         run as <user>
  -h, --help        show this help
      --version     show version`;

enum ver = "nasu v0.0";

auto main(string[] args) {
  string username = "root";
  bool showHelp, showVersion;

  try {
    getopt(args,
      std.getopt.config.caseSensitive,
      std.getopt.config.bundling,
      "u",            &username,
      "help|h",       &showHelp,
      "version|v",    &showVersion);
  } catch(GetOptException e) {
    e.message.err;
    stderr.writeln('\n', help);
    return 1;
  }

  if(showHelp) {
    help.writeln;
    return 0;
  }
  if(showVersion) {
    ver.writeln;
    return 0;
  }

  const cmd = args[1..$];
  if(cmd.empty) {
    err("command empty");
    return 1;
  }

  const pw = getpwnam(username.toStringz);
  if(!pw) {
    err(errno.strerror.fromStringz);
    return 1;
  }

  if(setreuid(pw.pw_uid, pw.pw_uid)) {
    err(errno.strerror.fromStringz);
    return 1;
  }

  return execvp(cmd[0], cmd);
}

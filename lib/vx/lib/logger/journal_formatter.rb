require 'oj'

module Vx ; module Lib ; module Logger

  module JournalFormatter

    @@exe   = $PROGRAM_NAME
    @@gid   = ::Process.gid
    @@uid   = ::Process.uid
    @@pid   = ::Process.pid
    @@host  = ::Socket.gethostname

    def self.call(level, progname, message, payload)
      m = ::Oj.dump(
        payload.merge(
          MESSAGE:           message.to_s,
          SYSLOG_IDENTIFIER: progname,
          _EXE:              @@exe,
          _GID:              @@gid,
          _UID:              @@uid,
          _PID:              @@pid,
          _HOSTNAME:         @@host,
          level:             level,
        ),
        mode: :compat
      )
      m.encode("UTF-8", invalid: :replace, replace: "?") << "\n"
    end
  end

end ; end ; end

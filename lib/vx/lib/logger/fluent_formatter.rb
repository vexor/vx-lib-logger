
module Vx ; module Lib ; module Logger
  module FluentFormatter

    @@exe   = $PROGRAM_NAME
    @@gid   = ::Process.gid
    @@uid   = ::Process.uid
    @@pid   = ::Process.pid
    @@host  = ::Socket.gethostname

    def self.call(level, progname, message, payload)
      payload.merge(
        level:    level.to_s,
        progname: progname,
        message:  message,
        EXE:      @@exe,
        GID:      @@gid,
        UID:      @@uid,
        PID:      @@pid,
        HOSTNAME: @@host,
      )
    end
  end
end; end; end

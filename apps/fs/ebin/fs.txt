{application,fs,
             [{description,"FS VXZ Listener"},
              {vsn,"1.9"},
              {registered,[]},
              {applications,[kernel,stdlib]},
              {mod,{fs_app,[]}},
              {env,[]},
              {modules,[fs,fs_app,fs_event_bridge,fs_server,fs_sup,fsevents,
                        inotifywait,inotifywait_win32,kqueue]}]}.

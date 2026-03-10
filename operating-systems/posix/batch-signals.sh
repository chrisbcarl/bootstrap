gcc operating-systems/posix/self-pipe.c -o dist/main && \
( ./dist/main -d & ) && sleep 0.5 && PID=$(pgrep -f main | head -n 1) && \
    kill -s USR1 $PID && sleep 2 && \
    kill -s USR2 $PID && sleep 0.5 && \
    kill -s TERM $PID && \
    wait

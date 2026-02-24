(python -c "import time; time.sleep(10)" &) && sleep 1 && kill -s INT $(pgrep -f python | head -n 1)
# pkill python is an alternative to finding the exact one you're looking for.

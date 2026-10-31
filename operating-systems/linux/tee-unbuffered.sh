sudo apt install expect -y  # get access to unbuffer

unbuffer python long-running-chatty.py | tee output.log

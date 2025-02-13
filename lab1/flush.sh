#!bin/bash

userdel -r u1 2>>/dev/null
userdel -r u2 2>>/dev/null


groupdel g1 2>>/dev/null

rm -rf /home/test13
rm -rf /home/test14
rm -f work3.log

echo "Deleted successfuly"

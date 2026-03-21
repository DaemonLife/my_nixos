#!/usr/bin/env bash

myphone_username=$1
myphone_port=$2
PHONE_HOME="/data/data/com.termux/files/home"
LINE="#############################"

echo
echo $LINE
echo -e "         Notes sync"
echo -e "     phone <--> computer"
echo $LINE
echo

unison -ignorelocks $HOME/Documents/Notes ssh://$myphone_username@myphone:$myphone_port/$PHONE_HOME/Notes \
&& echo -e ".\n.\n. . . Done"

echo
echo $LINE
echo -e "\tJournal sync"
echo -e "     phone ---> computer"
echo $LINE
echo

scp -P $myphone_port $myphone_username@myphone:$PHONE_HOME/.local/share/jrnl/journal.txt /tmp/ \
&& jrnl --import --file /tmp/journal.txt \
&& echo && echo -e "Creating a backup and clearing current journal \n(for secure synchronization later) on your phone." \
&& ssh -p $myphone_port $myphone_username@myphone "cd $PHONE_HOME && cd .local/share/jrnl && touch journal.txt_bkp && jrnl --import --file ./journal.txt_bkp 2> /dev/null && mv journal.txt journal.txt_bkp -f && touch journal.txt && echo -e '. \n. \n. . . Done'" \
&& echo -e "\nSync complited!"

#!/usr/bin/python3
import datetime

events = []

f_lock_screen = open('lock_screen.log')
for line in f_lock_screen:
  line_split = line.strip().split()
  # TODO %Z for matches the current timezone only, so any change, e.g. daylight savings breaks this for older records
  # TODO potentially use dateutil.parser instead
  # Screen unlocked on Fri Jul 16 04:30:12 PM CEST 2021
  timestamp = datetime.datetime.strptime(" ".join(line_split[3:10]), '%a %b %d %I:%M:%S %p %Z %Y')
  events.append([timestamp, " ".join(line_split[:3] + line_split[10:])])

auth_interesting = ["Lid closed", "Suspending", "Lid opened", "unlocked login keyring", "Operation 'sleep' finished"]

f_auth = open('/var/log/auth.log')
for line in f_auth:
  line_split = line.strip().split()
  # Jul 16 11:12:50 andrei-laptop systemd-logind[860]: Lid closed.
  descr = " ".join(line_split[5:])
  for interesting in auth_interesting:
    if descr.find(interesting) != -1:
      timestamp = datetime.datetime.strptime(" ".join(line_split[:3]), '%b %d %X')
      #print(datetime.datetime.today().year)
      timestamp = timestamp.replace(year = datetime.datetime.today().year)
      events.append([timestamp, descr])

events.sort()

for event in events:
  print(event[0], event[1])

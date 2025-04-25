#!/usr/bin/python3
import datetime

events = []

f_lock_screen = open('lock_screen.log')
for line in f_lock_screen:
  line_split = line.strip().split()
  # 2025-04-11T16:25:50+02:00 Screen unlocked. Wi-Fi: xxx
  timestamp = datetime.datetime.fromisoformat(line_split[0])
  events.append([timestamp, " ".join(line_split[1:])])

auth_interesting = ["Lid closed", "Suspending", "Lid opened", "unlocked login keyring", "Operation 'sleep' finished"]

f_auth = open('/var/log/auth.log')
for line in f_auth:
  line_split = line.strip().split()
  # 2025-04-08T11:19:35.410373+02:00 andrei-laptop systemd-logind[1597]: Lid opened
  descr = " ".join(line_split[3:])
  for interesting in auth_interesting:
    if descr.find(interesting) != -1:
      timestamp = datetime.datetime.fromisoformat(line_split[0])
      events.append([timestamp, descr])

events.sort()

for event in events:
  print(event[0], event[1])

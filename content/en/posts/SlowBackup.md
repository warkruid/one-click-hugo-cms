---
title: "POC: Semi Offline Backup Via A DataDiode"
date: 2022-04-20T11:12:01+02:00
draft: false 
categories: [hardware, DIY, security]
tags: [datadiode, diy, security]
---

What:
    This post is going to describe a POC of a backup method via a datadiode.


Why:
    To prevent ransomware destroying or altering backups.
    Ransomware often tries to destroy data that is stored on devices that are connected to the victim computer. Ie. the backup drive.
    By using a datadiode the data thats stored behind the datadiode can not be directly accessed or destroyed.
    NB. The destroyed data can still make it into the backups, but the older data in the backup cycle is still intact an can not be altered from the victim computer


Who:
    Me.

How:
    Connect two SOC's via a homemade data diode with usb-to-serial circuits
    The first SOC 
		  1) stores the incoming backups, 
                  2) compresses them (Maybe convert certain formats to text only?)
                  3) and generates error correcting blocks.
                  4) The backups and error correcting blocks are then transmitted over the datadiode to the seccond SOC
    The second SOC then 
			1) checks the received backup against the error blocks. 
                        2) In case of errors it fixes the backup.
                        3) Uncompresses the backup.
                        4) Generates logs with extensive error messages
                        5) Runs regular checks on the disk(s)


    This backup is then stored in a git repo. (via BUP?) on a external HD connected to the second SOC.


When:
    April/Mai 2022

Where:
    On my home network. As this is a combination of a hardware and software project.


Challenges:
    This method is going to be _SLOW_ ! The first full backup is going to take ages.
    Make a program that only sends the recently changed or added files to the backup, 
    then bit by bit transfer other files in background mode.
    This needs a database, and a hourly job on the machine that is to be backed up.

TODO
    Look at encrypted backup?

Thread model:
    Malware inside the perimeter


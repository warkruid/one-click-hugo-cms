---
title: "OpenSLL_Living_Of_The_land"
date: 2022-04-08T09:18:12+02:00
draft: false
---

There was a question on stackoverflow about the OpenSSL s_client functionality in relation to SMTP mail.
This question seemed a "red team" question to me. 

(Red Team stands for a team that attacks a site or service to test it's security)

How can you use OpenSSL to send mail out of a system?

Let's take a look.

You can pipe SMTP commands into openssl with "<<<"

```
SMTPSERVER="smtp.example.com"
SMTPPORT=587
SMTPCOMMANDS="QUIT"
openssl s_client -crlf -quiet -starttls smtp -connect ${SMTPSERVER}:${SMTPPORT} <<< ${SMTPCOMMAND}
```

Openssl connects to the smtp server via ttls and opens a command line shell. 
When the command "QUIT" is entered the connection is closed.

Nice, but how to send an email?

For that you have to give a series of SMTP commands to the mail server.

You construct the sets commands the following way. Instead of "QUIT", a long string containing commands is fed
to the openssl command.

```
SMTPCOMMANDS="\
helo example.com\r\
mail from: you@example.com\r\
rcpt to: example@target.com\r\
data\r\
subject: testsubject\r\
\r\
This is a test message\r\
.\r\
\r\
QUIT\r
"
```

This set of commands is fired blindly at openssl and there is no way to detect if something goes wrong.
It succeeds or not.





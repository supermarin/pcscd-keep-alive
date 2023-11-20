#!/usr/bin/env python3

from smartcard.System import readers
from smartcard.scard import SCARD_LEAVE_CARD
from smartcard.Exceptions import CardConnectionException
from time import sleep

# use the 1st reader
connection = readers()[0].createConnection()

while True:
    try:
        connection.connect(disposition=SCARD_LEAVE_CARD)
        connection.disconnect()
    except CardConnectionException:
        pass
    sleep(4)

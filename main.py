from rich import print
import threading
from src.mail_handler import MailHandler
from aiosmtpd.controller import Controller

handler = MailHandler()
controller = Controller(handler, hostname='0.0.0.0', port=1025)
print(controller.hostname, controller.port)

if __name__ == "__main__":
    print("STARTING")
    print(f"[blue]Main thread: {threading.get_ident()}[/blue]")
    controller.start()
    while True:
        pass


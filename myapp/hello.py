from dotenv import load_dotenv
import os
import sys

load_dotenv()

name = "World"
if "--name=Sarah" in sys.argv:
    name = "Sarah"

email_user = os.getenv("EMAIL_USER", "default@example.com")
email_pass = os.getenv("EMAIL_PASS", "no-pass")

print(f"Hello, {name}!")
print(f"Using email credentials: {email_user} / {len(email_pass) * '*'}")

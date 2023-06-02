from firebase_admin import messaging

from accounts.models import DeviceToken


def send_notification(arg, msg):
    if isinstance(arg, str):
        send_notification_by_token(arg, msg)
    else:
        device_token = DeviceToken.objects.get(user=arg)
        send_notification_by_token(device_token.token, msg)


def send_notification_by_token(token: str, msg: dict):
    message = messaging.Message(
        notification=messaging.Notification(
            title=msg['title'],
            body=msg['body'],
        ),
        token=token,
    )
    response = messaging.send(message)
    print('Successfully sent message:', response)

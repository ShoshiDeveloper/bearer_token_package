A package that generates a ready-made Bearer Token for you based on a secret key.

## Features

- Generating a Bearer Token with a lot of data.
- Bearer Token parse with a lot of data
- Generating a Bearer Token with a userId
- Parsing a Bearer Token with a userId

## Getting started

Just add package in project.

## Usage

To generate a token with a userId, use `getToken`:
```dart
String token = BearerToken.getUserIDToken('something text', DateTime(2025), 'Your 32 length key..............')
```
To parse a token with a lot of data, use `getData`:
```dart
String data = BearerToken.getData(token, 'Your 32 length key..............');
```

**Please note that the secret key must be 32 characters long**

## Additional information

In addition to encrypting the userID, you can also give any data as a string.
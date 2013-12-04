# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
Scale::Application.config.secret_key_base = 'a63b74314a527c953478e737203f453d214ac9a8d01e502a3b06274c3af471bb1609b54f22d55cfa6601112b83ce5e7068db46136e67b1d91d8274d43664ef5c'

# Identicon

An identicon is a visual representation of a hash value, typically used as an avatar when a user does not upload a personal image. The idea is that instead of a generic avatar or the default "user" icon, an identicon provides a unique, recognizable image for each user. The image is generated algorithmically from a user's unique information, such as a username or email address, which is then hashed to create a unique identifier. This identifier is then used to generate a geometric pattern that serves as the identicon. The pattern is typically a grid of colored squares arranged in a specific way, and the color, size and position of each square is determined by the values of the hash. Identicons are used as an easy way to visually identify users, as well as to prevent duplicate usernames or emails.

Here we take an input/string (this can be whatever you want(letters/numbers, etc.))

## Installation

Run the following in the root project folder to install the dependencies

```
mix deps.get
```

## Usage

Run the following in the root project folder to generate docs

```
mix docs
```

Follow the instructions in the Identicon module to create your identicon

